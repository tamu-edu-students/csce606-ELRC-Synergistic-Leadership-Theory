# Synergistic Leadership Theory Survey Application

[![Test Coverage](https://api.codeclimate.com/v1/badges/62f4dd4fb092b4211973/test_coverage)](https://codeclimate.com/repos/65caed0abc0d27237b1794c9/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/62f4dd4fb092b4211973/maintainability)](https://codeclimate.com/repos/65caed0abc0d27237b1794c9/maintainability)
![rubocop](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/barnden/c7b2d5e19079e12445b300407e383294/raw/badge.json)

- [Deployed Application](https://elrc-app-dfcfc7cd862b.herokuapp.com/)
- [Code Climate Reports](https://codeclimate.com/repos/65caed0abc0d27237b1794c9/maintainability)
- [GitHub Repo](https://github.com/tamu-edu-students/csce606-ELRC-Synergistic-Leadership-Theory)
- [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/2690137)
- [Slack](https://app.slack.com/client/T06GRHECJEM/C06GY2R74KX)

<details open="open">
<summary>Table of Contents</summary>

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)

</details>

---

## Getting Started

### Prerequisites

- [Ruby 3.3.0](https://www.ruby-lang.org/en/)
- [Rails](https://rubyonrails.org/)
- [Bundler](https://bundler.io/)
- [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

### Installation

Clone repository

```
git clone git@github.com:tamu-edu-students/csce606-ELRC-Synergistic-Leadership-Theory.git
```

Install all dependencies

```
cd csce606-ELRC-Synergistic-Leadership-Theory/rails_root
bundle install
```

## Usage

### Run locally

Create master key (future improvement - remove master key from repo)

```
cd rails_root
echo "d98b20070bfcf9059926029b3a959b64" > ./config/master.key
```

Generate database

```
rails db:migrate
rails db:seed
```

Start server

```
rails server
```

### Run tests

Setup test database

```
rails db:test:prepare
```

Run rspec tests

```
bundle exec rspec
```

Run cucumber tests

```
bundle exec cucumber
```

### Deploy

Create Heroku application

```
heroku create [appname]
```

Add buildpacks

```
heroku buildpacks:add https://github.com/timanovsky/subdir-heroku-buildpack.git
heroku buildpacks:add heroku/ruby
```

Add config vars

```
heroku config:set PROJECT_PATH=rails_root
heroku config:set RAILS_MASTER_KEY=d98b20070bfcf9059926029b3a959b64
```

Install [Heroku Postgres](https://elements.heroku.com/addons/heroku-postgresql) and attach to application

Push to heroku app

```
git push heroku main
```

Generate database

```
heroku run rails db:migrate
heroku run rails db:seed
```

## Contacts
Andres Santiago <Andylsantiago20@tamu.edu>

Jacob Mathes <thejacobm1@tamu.edu>

Minseo Park <minseo.park@tamu.edu>

Brandon Nguyen <bgn@tamu.edu>

Yi-Ting Lee <lucalee207@tamu.edu>

Chengyuan Qian <cyqian@tamu.edu>
