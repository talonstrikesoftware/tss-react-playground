#rails\_webpack

**Solution:** tss-rails
**Original Source:** rails\_webpack

**Description:** This is the rails component to the TSS app stack.  It is a basic rails app that supports webpacker. It assumes you already have a rails app you want to deploy. 

**Last Updated:** 16 Aug 2019

## Notes
This is a sort of a wierd setup.  You will clone this project then inside the data directory, you will clone the actual rails app itself. Next you will run the project-setup.sh script to tell the parent project about the child project.  This allows us to keep the container configuration separate from the app repo and make adjustments in both.

The project repo name will be placed in a .env file that will be picked up when the docker-compose file runs and utimately will be used by the Dockerfile to grab the Gemfile for the app.



## Pre-installation
- clone the actual rails project into ./data

## Installation/Configuration

#### Run the project-setup.sh script
```console
./project-setup.sh {project_directory_name}
```

#### Configure `rails/rails.env` file
- Edit the ./rails/rails.env file to set whether you want production or development (default)

#### Configure the application
- in the app directory, edit the db/db.yml file to connect to the postgres server (can you use secrets here)
- Setup the mailer settings

#### Build and run the image
```bash
docker-compose build
docker-compose up -d
```

Review different configs on main server
tempoararily expose port 3000 to try and connect

Note: At this point you have an image with rails, yarn and webpacker and all the dependencies installed.  However your rails project has not been properly 'instramented' to use webpacker.

- Attach to the running image
In another window attach to the container

```console
  docker-compose exec rails bash
```
Note: This will drop you into a bash shell in the container
https://www.youtube.com/watch?v=CcSN1WaubGg
- Install webpacker into your project

```console
  :/usr/src/app/# bundle 
  :/usr/src/app/# bundle exec rails webpacker:install 
  :/usr/src/app/# bundle exec rails webpacker:install:react # if you want react support
```

- Update config/initializers/content\_security\_policy.rb

From the webpacker github website, you need to allow webpack-dev-server host as an allowed origin for connect-src if you are running rails 5.2+ (which you are)

- Uncomment the begin/end pair of the block that defines the content_security_policy
- Add this line (everything else in this block can be left commented out)

  ```yaml
  policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
  ```
  When done the block should look like this:
  
  ```yaml
  Rails.application.config.content_security_policy do |policy|
#   policy.default_src :self, :https
#   policy.font_src    :self, :https, :data
#   policy.img_src     :self, :https, :data
#   policy.object_src  :none
#   policy.script_src  :self, :https
#   policy.style_src   :self, :https
#   # Specify URI for violation reports
#   # policy.report_uri "/csp-violation-report-endpoint"
  policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
end
  ```

* **Service name:** rails

## Post Install Notes/FAQ
#### Things to know
- Once the image is setup and running, you will need to connect to the rails service, interactively, to run generators. You will edit files on your local filesystem.
- You can create a simple controller and view with `rails g controller Welcome index`

#### How do I start development

- Start the rails server
 
```console
  docker-compose exec rails bash
  rails s -b 0.0.0.0
```
Note: This will be your rails server instance

- Start the webpack dev server (in a separate terminal window)

```console
  docker-compose exec rails bash
  bin/webpack-dev-server
```
Note: This will be your webpack server instance
Note: see below on why I am not using Foreman

- You are now cleared to start development
- This link is what got me going:
https://x-team.com/blog/get-in-full-stack-shape-with-rails-5-1-webpacker-and-reactjs/

### React Notes
If you installed React here are some additional notes to get started
- webpacker wants to load 'modules'.  These are sister directories (you create) to the packs directory.
- In the packs directory you create a js file for each module.  In it you import the 'module' (import 'module_name')
- This in turn will load up a index.js file that you create at the root of each 'module' directory.
- In the index.js file you import React and your components (recommended to be in a components subdirectory)
- Additionally the index.js file is where you select the div you are interested in (presumably by id) and then you mount your top level component (usually a react-router object) to it (i.e. ReactDom.render(<App />, div_id)
- At this point you are in the React world
- Installing axios may help with ajax calls.
- The only reason you need a view/route is to have a route to a view.  As long as you are mounting the component (javascript_pack_tag 'module_name') it will work
If you installed React you can connect up a react component be editing your 
- You know you have react installed as in your package.json you will have these dependencies
  babel-preset-react
  prop-types
  react
  react-dom
- Additionally you will have the following files:
  .babelrc
  ./config/webpack/loaders/react.js ??? Not there
  ./app/javascript/packs/hello_react.jsx
- To use it go to your view and insert this line
<%= javascript_pack_tag 'hello_react' %>
- If you create new React components you need to import them in your app/javascript/packs/application.js file otherwise you will see an error that your component isn't in the manifest.

####Things to work on:
- A lot of the tutorials will have you use Foreman.  Need to figure out how to install foreman into this container.
