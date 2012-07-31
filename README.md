# Text Your City [![Build Status](https://secure.travis-ci.org/codeforamerica/textizen.png?branch=master)][travis]

[travis]: http://travis-ci.org/codeforamerica/textizen

## Installation

    $ bundle install
    $ rake db:create
    $ rake db:migrate
    $ rake db:seed

## Configuring Tropo

1. [Create a Tropo account](https://www.tropo.com/account/register.jsp) if you don't already have one, and login
2. Create a new WebAPI application. Enter an arbitrary Application ID, e.g. `mytextyourcity`. Enter the URL that powers your app, which is _[Your Domain]/responses/receive_message_, e.g. `http://my.example.com/responses/receive_message`
3. Take note of your Tropo _Username_, _Password_ and _Outbound Messaging Token_ (for setting up your environment variables in the _Other Stuff_ section)
4. Lastly, take note of your Application ID by visiting `http://api.tropo.com/v1/applications`, entering your Tropo username/password and take note of the value of your app's `id` from the resulting JSON. It should be a 6-7 digit number.


### Other stuff
Make sure you have these environment variables set to enable SMS; you can acquire them in steps 2 and 3 of the _Configuring Tropo_ section above. You can either add them to your $PATH or rename the included `sample.env` to `.env` if using Foreman.

    export TROPO_USERNAME=
    export TROPO_PASSWORD=
    export TROPO_TOKEN=
    export TROPO_APP_ID=

## Usage

    $ rails server

With Foreman:

    $ foreman run bundle exec rails server -p $PORT

_Remember, deploying locally means that you can't receive Tropo messages via their webhook. See below for deploying to Heroku._
## Environment vars
  sign_up_path
  block_registrations

## Deploying to Heroku

    $ heroku create mytextyourcity --stack cedar
    $ git push heroku master
    $ heroku run rake db:migrate
    $ heroku config:add TROPO_USERNAME=##############
    $ heroku config:add TROPO_PASSWORD=##############
    $ heroku config:add TROPO_TOKEN=#################
    $ heroku config:add TROPO_APP_ID=################

## Testing

TextYourCity uses the `rspec` gem for testing.  Make sure you create a test database: `textyourcity_test` and set it up with `$ rake environment RAILS_ENV=test db:migrate`. You can run tests by `$ rspec` or `$ bundle exec rspec` (if your global rspec is of a different version).

## Contributing
In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by [translating to a new language][locales]
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues][]
* by reviewing patches
* [financially][]

[locales]: https://github.com/codeforamerica/cfa_template/tree/master/config/locales
[issues]: https://github.com/codeforamerica/cfa_template/issues
[financially]: https://secure.codeforamerica.org/page/contribute

## Submitting an Issue
We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. You can indicate support for an existing issue by
voting it up. When submitting a bug report, please include a [Gist][] that
includes a stack trace and any details that may be necessary to reproduce the
bug, including your gem version, Ruby version, and operating system. Ideally, a
bug report should include a pull request with failing specs.

[gist]: https://gist.github.com/

## Submitting a Pull Request
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add tests for your feature or bug fix.
5. Run `bundle exec rake test`. If your changes are not 100% covered, go back
   to step 4.
6. Commit and push your changes.
7. Submit a pull request. Please do not include changes to the gemspec or
   version file. (If you want to create your own version for some reason,
   please do so in a separate commit.)

## Supported Ruby Versions
This library aims to support and is [tested against][travis] the following Ruby
implementations:

 * Ruby 1.9.3

If something doesn't work on one of these interpreters, it should be considered
a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2012 Code for America. See [LICENSE][] for details.

[license]: https://github.com/codeforamerica/cfa_template/blob/master/LICENSE.mkd

[![Code for America Tracker](http://stats.codeforamerica.org/codeforamerica/textizen.png)][tracker]

[tracker]: http://stats.codeforamerica.org/projects/textizen

## Changelog
6/15/12 v0.1.1 pushed with bugfixes for csv export and poll viewing
5/31/12 v0.1.0 now pushed! Ready for our first pilot with the Philadelphia City Planning Commission. Look for launch announcements coming shortly...
