**This application should be deployed automatically on and by the infrastructure
described in [another project](TODO). Most of the content is in the
documentation of the infrastructure project, so make sure to check it.**

# What it does

This basic application basically just counts clicks on a button and stores the
number of clicks in redis. It exposes 3 endpoints :

- GET on `rest/click`: get the current click counter value from redis
- PUT on `rest/click`: increment and get the click counter value; this is what
  is called when the button is pressed
- GET on `rest/healtcheck`: provides the state (ok / ko) of the redis
  connection

In addition to that, a basic HTML page is also returned when GET-ting `/`,
containing the current counter value and the previously presented button.

The redis host it connects to is provided by the environment variable
`REDIS_HOST`, with no default value in case it's not provided.

# Workflow

# Development and manual testing

While developing the application, you can:

- run `make build` to build the Docker image `horgix/click-count` with the tag
  `dev`
- run `make dev` to:
    - run a local instance of redis
    - run a local instance of the application built by the previous step,
      linked to the redis, and accesible at `localhost:8080`
