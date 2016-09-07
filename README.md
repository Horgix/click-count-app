**This application should be deployed automatically on and by the
infrastructure described in [another
project](https://github.com/Horgix/click-count-infra), based on Docker,
Mesos/Marathon and GitLab CI. Most of the content is in the documentation of
the infrastructure project, so make sure to check it.**

# What it does

This application basically just counts clicks on a button and stores the number
of clicks in redis. It exposes 3 endpoints :

- GET on `rest/click`: get the current click counter value from redis
- PUT on `rest/click`: increment and get the click counter value; this is what
  is called when the button is pressed
- GET on `rest/healtcheck`: provides the state (ok / ko) of the redis
  connection

In addition to that, a basic HTML page is also returned when GET-ting `/`,
containing the current counter value and the previously presented button.

The redis host it connects to is provided by the environment variable
`REDIS_HOST`, with no default value in case it is not provided so don't forget
to set it !

# Workflow

There are currently 4 steps:

- build
- cleanup
- (test)
- staging
- production

The first steps are run on **each commit**, while deployments to staging or
production are ruled like this:

- Every tag is deployed to staging
- Every commit/merge in master is deployed to production

This way, it lets a lot of "liberty" to the developers; just commit on the
branch when you want to have your work built and tested, tag to release to
staging, and submit a Merge Request on `master` for a production release.

# Development and manual testing

While developing the application, you can:

- run `make build` to build the Docker image `horgix/click-count` with the tag
  `dev`
- run `make dev` to:
    - run a local instance of redis
    - run a local instance of the application built by the previous step,
      linked to the redis, and accesible at `localhost:8080`
