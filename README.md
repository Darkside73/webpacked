[![Build Status](https://travis-ci.org/Darkside73/webpacked.svg?branch=master)](https://travis-ci.org/Darkside73/webpacked) [![Gem Version](https://badge.fury.io/rb/webpacked.svg)](http://badge.fury.io/rb/webpacked)

# webpacked

**webpacked** helps you to integrate Webpack in to a Ruby on Rails application.

It can be used alongside sprockets but normaly you no need sprockets at all now: webpack replaces sprockets completely.
Using **webpacked** and webpack itself means that Javascript is a first-class citizen: you should use `npm` to manage packages (no more gemified Javascript libraries!).

In development mode assets are served via [webpack-dev-server](http://webpack.github.io/docs/webpack-dev-server.html) that brings a cool hot module reloading feature to your workflow. Webpack's manifest file is generated using [assets-webpack-plugin](https://github.com/kossnocorp/assets-webpack-plugin).

Also **webpacked** offers deploy automation within capistrano task (see detailed instructions bellow).

## Requirements

  1. Node.js > 4
  1. NPM > 3

## Installation

  1. Add `webpacked` to your Gemfile
  1. Run `bundle install` to install the gem
  1. Run `bin/rails generate webpacked:install` to get required files in your application, install NPM packages and foreman gem if you wish so
  1. Run `foreman start` (if you've decided to install it) to start `webpack-dev-server` and `rails server` at the same time

## Usage

### Webpack configuration

Webpack configs are divided into on three files:

  1. `frontend/base.config.js` contains common setup for all environments
  1. `frontend/development.config.js` contains setup specific for development
  1. `frontend/production.config.js` includes production optimizations

Follow comments in these files and webpack official docs to conclude what meets you requirements.

Environment is defined via `NODE_ENV` variable and initialized in`frontend/main.config.js`. Normally you don't need to manual set up `NODE_ENV` unless you want to add another environment for your frontend application.

In development mode webpack-dev-server starts using `npm run dev:server` command or simply `foreman start`. Internally it uses `frontend/dev-server.js`.

Just in case there are a bunch other preconfigured NPM commands shipped (you can find them in the `package.json`):

  * `npm run build:dev` runs webpack build for development environment
  * `npm run build:production` same for production environment

### View helpers

To add webpacked assets in to your application, use following helpers:

```erb
<% # layout.html.erb  %>
<!DOCTYPE html>
<html>
  <head>
    <%= webpacked_css_tags 'application' %>
  </head>
  <body>
    <%= webpacked_js_tags 'application' %>
  </body>
</html>
```

Where `'application'` is a one of the your entry points in webpack config.

NOTE: if you using [common chunks optimization](https://webpack.github.io/docs/code-splitting.html#split-app-and-vendor-code) (it is so indeed in production most likely), these helpers may produce additional CSS/Javascript include tag for that common bundle.

You should not concern about including any extra scripts to get hot module reloading works: it integrates transparently through a same webpack manifest file.

### Controller helper

**webpacked** offers an optional approach to link entry points with Rails application. The idea is in mapping *controllers* to entry points. Consider the following code:

```ruby
class ApplicationController < ActionController::Base
  include Webpacked::ControllerHelper
  webpacked_entry "application"
end

class FooController < ApplicationController
  webpacked_entry "foo"
end

class BarController < ApplicationController
  webpacked_entry "bar"
end
```

```erb
<%= webpacked_css_tags webpacked_entry_name %>
<%= webpacked_js_tags webpacked_entry_name %>
```

In the example above the decision which entry point to use comes in controllers instead views. Therefore in layout we can use a common `webpacked_entry_name` helper method. Notice that `webpacked_entry` in `ApplicationController` will be used if concrete controller does not define its own entry.

### Alternative ways

If you don't like none of the mentioned above, you can use more generic helpers to access webpack manifest:

  * `asset_tag(entry, kind)` return include tags for entry point `entry`; `kind` could be `:js` or `:css`
  * `webpacked_asset_path(entry, kind = nil)` return only assets path for given entry

Be aware that common entry point is not included by these methods. So if you use common chunks optimization do not forget to include `common` (or whatever name you pick) entry point manually.

### Rails configuration and other assumptions

Gem exposes a few configuration options:

  * `webpacked.enabled` default to `true`; you probably want to disable webpacked in test environment, so helpers will not fail if manifest does not exist
  * `webpacked.manifest_path` default to `webpack-assets.json`
  * `webpacked.load_manifest_on_initialize` default to `false`; if `true` then parse manifest on application bootstrap
  * `webpacked.common_entry_name` default to `common` (if you've changes this, you need to change it in webpack config as well)
  * `webpacked.bin` default to `node_modules/.bin/webpack`
  * `webpacked.config` default to `frontend/main.config.js`
  * `webpacked.dev_server` enabled only in development mode
  * webpack-dev-server starts on port 3500 on localhost via HTTP (use `WEBPACK_DEV_HOST` and `WEBPACK_DEV_PORT` env variables to change it)
  * assets compiled to `public/assets/webpack`; you can change it in webpack config (and `deploy.rb` if capistrano webpacked task used)

## Capistrano deployment

### Installation and usage

To deploy generated assets add `require "capistrano/webpacked"` to your `Capfile`. The `deploy:webpacked:build` task will run automaticaly as after `deploy:updated` hook.

Also you need to set up the `:assets_roles` in `deploy.rb` so **webpacked** to run its tasks.

What under hood? The task makes diff of files and folders (specified in `:webpacked_dependencies` option) in current release against previous release and decides whether to run production webpack build. If there is no diff then simply a manifest copied from previous release path. If some of dependencies were changed then production build starts *locally* and assets synchronized via `rsync` over SSH.

NOTE: scince webpack build runs locally, you should pay an extra attention to your working copy condition: current branch, not published commits, not commited changes, etc.

Additionally there are some extra tasks exposed (they are used by `deploy:webpacked:build` internally):

  * `deploy:webpacked:build_force` unconditionally invokes production build on local machine
  * `deploy:webpacked:sync` synchronize assets under `:webpacked_release_output_path` with remote server

### Configuration

There are following options available to set up (example values are defaults in fact):

  * `set :webpacked_dependencies, %w(frontend npm-shrinkwrap.json)` webpacked build will perform if one of these will be changed
  * `set :webpacked_manifest_path, "webpack-assets.json"` same as `Rails.configuration.webpacked.manifest_path`
  * `set :webpacked_deploy_manifest_path, "webpack-assets-deploy.json"` used for production manifest only; choose another path to not clash with local dev manifest
  * `set :webpacked_local_output_path, "public/#{fetch(:assets_prefix)}/webpack"` where webpack generates its assets
  * `set :webpacked_release_output_path, "public/#{fetch(:assets_prefix)}/webpack"` where webpack assets are stored on the deploy server (started from `shared_path`)

## TODO

  * deploy with remote webpack build performing

## Contributing

Pull requests, issues and discussion are welcomed

## Thanks

* Marketplacer team for their [webpack-rails](https://github.com/mipearson/webpack-rails) gem which guides this implementation in some way ;)
* Contributors of [capistrano-faster-assets](https://github.com/capistrano-plugins/capistrano-faster-assets) gem for conditionally assets compile idea
