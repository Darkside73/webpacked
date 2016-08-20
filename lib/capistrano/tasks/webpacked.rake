# based on capistrano-faster-assets gem

class WebpackedBuildRequired < StandardError; end

namespace :deploy do
  namespace :webpacked do
    OPTIONS = lambda do |option|
      {
        dependencies:         fetch(:webpacked_dependencies)        || %w(frontend npm-shrinkwrap.json),
        manifest_path:        fetch(:webpacked_manifest_path)       || 'webpack-assets.json',
        deploy_manifest_path: fetch(:webpacked_local_manifest_path) || 'webpack-assets-deploy.json',
        local_output_path:    fetch(:webpacked_local_output_path)   || "public/#{fetch(:assets_prefix)}/webpack",
        release_output_path:  fetch(:webpacked_release_output_path) || "public/#{fetch(:assets_prefix)}/webpack"
      }.fetch(option)
    end

    desc 'Webpack build assets'
    task :build do
      on roles(fetch(:assets_roles)) do
        with rails_env: fetch(:rails_env) do
          begin
            latest_release = capture(:ls, '-xr', releases_path).split[1]
            raise WebpackedBuildRequired unless latest_release
            latest_release_path = releases_path.join(latest_release)

            OPTIONS.(:dependencies).each do |dep|
              release = release_path.join(dep)
              latest = latest_release_path.join(dep)
              # skip if both directories/files do not exist
              next if [release, latest].map { |d| test "test -e #{d}" }.uniq == [false]
              # execute raises if there is a diff
              begin
                execute(:diff, '-Nqr', release, latest)
              rescue SSHKit::Runner::ExecuteError
                raise WebpackedBuildRequired
              end
            end

            info 'Skipping webpack build, no diff found'

            execute(
              :cp,
              latest_release_path.join(OPTIONS.(:manifest_path)),
              release_path.join(OPTIONS.(:manifest_path))
            )
          rescue WebpackedBuildRequired
            invoke 'deploy:webpacked:build_force'
          end
        end
      end
    end
    after 'deploy:updated', 'deploy:webpacked:build'

    task :build_force do
      run_locally do
        info 'Create webpack local build'
        `RAILS_ENV=#{fetch(:rails_env)} npm run build:production`
        invoke 'deploy:webpacked:sync'
      end
    end

    desc 'Sync locally compiled assets with current release path'

    task :sync do
      on roles(fetch(:assets_roles)) do
        info 'Sync assets...'
        upload!(
          OPTIONS.(:deploy_manifest_path),
          release_path.join(OPTIONS.(:manifest_path))
        )
        execute(:mkdir, '-p', shared_path.join(OPTIONS.(:release_output_path)))
      end
      roles(fetch(:assets_roles)).each do |host|
        run_locally do
          local_output_path = fetch(:webpacked_local_output_path)
          release_output_path = shared_path.join(OPTIONS.(:release_output_path))
          `rsync -avzr --delete #{local_output_path} #{host.user}@#{host.hostname}:#{release_output_path.parent}`
        end
      end
    end
  end
end
