# Automated k6 load testing with Buildkite

## Running on Buildkite

[![Add to Buildkite](https://buildkite.com/button.svg)](https://buildkite.com/new?template=https://github.com/DyegoCosta/k6-example-buildkite)

Once the pipeline is installed on your Buildkite account you should be able to start a "New Build".

<img alt="Build setup" src="https://user-images.githubusercontent.com/636899/170772348-e73ea0fd-c775-4120-8701-7e9a0864929f.png">
<img alt="Build running" src="https://user-images.githubusercontent.com/636899/170772372-2908fe4c-c6c4-4539-8bfe-624f98721983.png">

## Running Locally

Clone this repo and run:

```shell
BASE_URL=https://example.com docker-compose up
```

## Options

|                                  | Description                                                                                                                 | Required | Default |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------|----------|---------|
| BASE_URL                         | Base URL used for the k6 HTTP session                                                                                       | Yes      |         |
| AUTH_TOKEN                       | Add your Bearer token here if the API under test requires it                                                                | No       |         |
| TEST_RUN_ID                      | Identification string for the test run. Used to tag k6 results                                                              | No       | local   |
| MAX_VIRTUAL_USERS                | Max number of concurrent users across all k6 parallel instances                                                             | No       | 10      |
| VIRTUAL_USERS_RAMP_UP_DURATION   | Time for going from zero to maximum virtual users                                                                           | No       | 1m      |
| VIRTUAL_USERS_SUSTAINED_DURATION | Time for sustaining the maximum number of virtual users                                                                     | No       | 3m30s   |
| VIRTUAL_USERS_RAMP_DOWN_DURATION | Time for going from maximum virtual users count to zero                                                                     | No       | 30s     |
| BUILDKITE_PARALLELISM            | Split your test run into multiple Buildkite steps. This is particularly useful to test APIs with IP-based rate limiting [1] | No       | 1       |

[1] You can use this to enable requests from multiple concurrent IPs. You'll need to have a Buildkite Agent queue set up with 1 agent per host (e.g. if you're using Buildkite's [Elastic CI Stack for AWS](https://buildkite.com/docs/agent/v3/elastic-ci-aws/parameters) you should have AgentsPerInstance=1)
