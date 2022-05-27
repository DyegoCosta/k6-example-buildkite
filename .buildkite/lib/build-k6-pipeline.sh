#!/bin/bash

set -euo pipefail

BUILDKITE_PARALLELISM=$(buildkite-agent meta-data get buildkite-parallelism)
BASE_URL=$(buildkite-agent meta-data get base-url)
MAX_VIRTUAL_USERS=$(buildkite-agent meta-data get max-virtual-users)
AUTH_TOKEN=$(buildkite-agent meta-data get auth-token)
VIRTUAL_USERS_RAMP_UP_DURATION=$(buildkite-agent meta-data get virtual-users-ramp-up-duration)
VIRTUAL_USERS_SUSTAINED_DURATION=$(buildkite-agent meta-data get virtual-users-sustained-duration)
VIRTUAL_USERS_RAMP_DOWN_DURATION=$(buildkite-agent meta-data get virtual-users-ramp-down-duration)

declare -i x=MAX_VIRTUAL_USERS
declare -i y=BUILDKITE_PARALLELISM
let max_virtual_users_per_buildkite_step=x/y

echo "
  - label: ':k6: Load Test %n'
    command: docker-compose up --exit-code-from k6 --abort-on-container-exit
    timeout_in_minutes: 120
    parallelism: \"${BUILDKITE_PARALLELISM}\"
    env:
      BASE_URL: \"${BASE_URL}\"
      TEST_RUN_ID: \"${BUILDKITE_BUILD_ID}\"
      TENANT_SUBDOMAIN: \"${TENANT_SUBDOMAIN}\"
      AUTH_TOKEN: \"${AUTH_TOKEN}\"
      ENVIRONMENT: \"${ENVIRONMENT}\"
      MAX_VIRTUAL_USERS: \"${max_virtual_users_per_buildkite_step}\"
      VIRTUAL_USERS_RAMP_UP_DURATION: \"${VIRTUAL_USERS_RAMP_UP_DURATION}\"
      VIRTUAL_USERS_SUSTAINED_DURATION: \"${VIRTUAL_USERS_SUSTAINED_DURATION}\"
      VIRTUAL_USERS_RAMP_DOWN_DURATION: \"${VIRTUAL_USERS_RAMP_DOWN_DURATION}\"
"
