<p align="center">
  <a href="https://github.com/makigas/makigas/releases"><img src="https://img.shields.io/github/tag/makigas/makigas.svg" alt="Latest release"></a>
</p>

<p align="center">
<img src="http://i.imgur.com/GPJvkq1.png" alt="makigas">
</p>

# About

This is the public source code for makigas.es. The whole application was
recently redesigned from scratch using the Ruby on Rails framework. This web
site, just like previous iterations, still displays information about videos
and playlists in the system.

# Setting up

**To use the experimental Docker images, see below.**

## Requirements

Supported operating systems:

* Production environments: GNU/Linux.
* Development environments: GNU/Linux, MacOS X.

Requirements:

* Ruby 2.4+ and Bundler. Older Ruby versions are not supported.
* PostgreSQL 9.1+. Other SQL engines such as MySQL or sqlite3 are not supported.
* Node.js + Yarn, for the front-end dependencies.
* `libpq-dev`. If `bundle install` refuses to install pg, check this.
* `imagemagick`. Required for image manipulation on thumbnails and such.

Additional testing dependencies:

* ChromeDriver. It's required to run the system tests. It's not in the Gemfile,
  so you'll have to manually get it either from your package manager if present
  or by downloading it for your operating system (Windows, Linux, macOS) at
  http://chromedriver.chromium.org/.

## Getting the code

To install the web application:

    $ git clone https://github.com/makigas/makigas
    $ cd makigas
    $ bundle install

## Yarn dependencies

Rails 5.1 has adopted JavaScript and now it has first class support for Yarn,
Webpack and other JavaScript related tools. At the moment Yarn is used for
fetching front-end dependencies (Bootstrap, jQuery...), but I expect to use it
more and more in the future.

Make sure Node.js is installed on your system. LTS versions are recommended
for production servers. Make sure that Yarn is installed. Install front-end
dependencies using `bundle exec rake yarn:install` or simply `yarn`.

## Database

Upstream database is PostgreSQL and that is the officially supported one. Said
that, this web application may work on MySQL and sqlite3 as well, although I
haven't tested this, and it's not officially supported. If you experience bugs
by using MySQL, they cannot be fix.

**Note that no database.yml has been committed.** Copy the example file
`config/database.yml.example` and modify it to suit your needs. **It is
important not to commit sensitive information such as passwords to the
repository**.

    $ cp config/database.yml.example config/database.yml
    $ vim config/database.yml
    $ rake db:setup

## secrets.yml

There is no secrets.yml file committed to the project because it is dangerous
to track secret keys in public open source projects. Copy the example file
`config/secrets.yml.example` and fill the commented keys with the secret keys
that you want to use.

    $ cp config/secrets.yml.example config/secrets.yml
    $ vim config/secrets.yml

You can generate new secret keys using `rake secret` command.

## Creating administration users

Because the dashboard is a private system, it is not possible for you to
register as a new user using a web interface. Only an existing user can create
new users using the dashboard. Therefore, in order to set up the first user,
you will have to use the Rails console to seed the first user, like so:

    $ rails console
    ...
    > User.create(email: 'foo@example.com', password: '123456')

# Docker support

This repository has support for Docker. At the moment Docker helps during
development and testing of the web application because external dependencies
such as PostgreSQL or Minio can be set up without user intervention.

Later on I want to add production support for my Dockerfile so that I can run
the web application inside a Docker container in my server. This is still not
finished so running the Docker image in production is not recommended at the
moment.

## How to develop using Docker

* Start a development session: `docker-compose up`. This will also start
  PostgreSQL and Minio. The web application will be available as usual at
  `http://localhost:3000` once the Docker image is built and up.

* Run migrations: `docker-compose exec web rake db:schema:load`. The web
  application will refuse to work until the schema is loaded into the database.
  Run this one-off command in a second terminal.

## How to test using Docker

There is a second Dockerfile in the spec directory that compiles the web
application with some additional dependencies such as Chrome and ChromeDriver
(which is required for running system tests).

It's tricky to run tests in Docker because you probably want a second database
to run your tests without breaking your development database. However, you
probably don't want your second database to stay after running unit tests.

There is a helper script at `spec/rspec-docker.sh` that you can use to
orchestrate tests inside Docker. It builds and runs the testing Dockerfile
and manages a Docker image for PostgreSQL, destroying the database container
after unit tests are run, to clean up. The testing image is kept in your local
image registry, but the contianers are removed after RSpec are run. The exit
code of the RSpec command is kept and exited by the `rspec-docker.sh` script
itself.

# Contributing

Read the [CONTRIBUTING.md][1] file for more information on how to contribute to
the project. Follow the [Code of Conduct][2]. My two favourite guidelines from
the Contributing file:

* Send as many issues as you need, but please, keep one topic per issue
  in order to keep things clean and easy to track.
* Don't submit surprise PRs with new code. Always discuss your intentions
  in a tracking issue before starting to work so that we can provide you all
  the help you need, allocate your idea into the roadmap, or politely reject
  your idea if we consider it's outside the scope of the project.

If you find a bug in this source code or an issue or visual glitch on the web
site, please file a bug. If you find a security vulnerability on this source
code, please disclose it in a private way to me. [My e-mail address and my
PGP key is on my personal website][3].

# License

    makigas v5 - source code for the makigas.es application
    Copyright (C) 2016-2017 Dani Rodríguez

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Frequently Asked Questions

* **Why did you rewrite makigas.es again?**
  Previous versions of makigas.es used a blogging engine such as WordPress with
  a lot of plugins and hacks in order to work as general purpose CMS systems.
  This version was crafted specifically for the data structures required for
  the web site and therefore it is more concise, flexible and easy to develop
  and maintain.

* **What is the point on sharing the source code?**
  I don't have any particular interest in this source code at this moment. I
  just want an app that works and that allows me to manage my videos and keep
  my information up to date.

[1]: https://github.com/makigas/makigas/blob/master/CONTRIBUTING.md
[2]: https://github.com/makigas/makigas/blob/master/CODE_OF_CONDUCT.md
[3]: https://www.danirod.es/contact/
