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

# Annotate build

buildkite-agent annotate --style "default" "
  <h4>Load Test Configuration</h4>
  <dl class='flex flex-wrap mxn1'>
    <div class='m1'>
      <dt>Base URL</dt>
      <dd>
        ${BASE_URL}
      </dd>
    </div>
    <div class='m1'>
      <dt>Max VUs</dt>
      <dd>
        ${MAX_VIRTUAL_USERS}
      </dd>
    </div>
    <div class='m1'>
      <dt>VUs Ramp Up Duration</dt>
      <dd>
        ${VIRTUAL_USERS_RAMP_UP_DURATION}
      </dd>
    </div>
    <div class='m1'>
      <dt>VUs Sustained Duration</dt>
      <dd>
        ${VIRTUAL_USERS_SUSTAINED_DURATION}
      </dd>
    </div>
    <div class='m1'>
      <dt>VUs Ramp Down Duration</dt>
      <dd>
        ${VIRTUAL_USERS_RAMP_DOWN_DURATION}
      </dd>
    </div>
  </dl>
"

# Construct build

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
