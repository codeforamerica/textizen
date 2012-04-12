bundle install
rake db:migrate
rake db:seed

heroku config:add TROPO_APP_ID=2340349
get from api.tropo.com/v1/applications
export instead of heroku config:add for local apps (but tropo won't work without tunnlr)
heroku config:add TROPO_USERNAME=
heroku config:add TROPO_PASSWORD=
heroku config:add TROPO_TOKEN=
heroku config:add TROPO_APP_ID=
