import example1Tests from './tests/example1.js'
import example2Tests from './tests/example2.js'
import { Httpx } from 'https://jslib.k6.io/httpx/0.0.3/index.js';

const session = new Httpx({
  baseURL: __ENV.BASE_URL,
  headers: {
    'Authorization': `Bearer ${__ENV.AUTH_TOKEN}`,
    accept: 'application/json, text/javascript, */*; q=0.01',
    'Accept-Encoding': 'gzip, deflate, br',
    'Content-Type': 'application/json',
  },
  timeout: 20000, // 20s timeout.
});

/* Options
Global options
stages - Ramping pattern
thresholds - pass/fail criteria for the test
*/
export let options = {
  stages: [
    // Linearly ramp up from 1 to maximum VUs during first minute
    { target: (__ENV.MAX_VIRTUAL_USERS), duration: (__ENV.VIRTUAL_USERS_RAMP_UP_DURATION || '1m') },
    // Hold at maximum VUs for the next 3 minutes and 30 seconds
    { target: (__ENV.MAX_VIRTUAL_USERS), duration: (__ENV.VIRTUAL_USERS_SUSTAINED_DURATION || '3m30s') },
    // Linearly ramp down from maximum VUs to 0 VUs over the last 30 seconds
    { target: 0, duration: (__ENV.VIRTUAL_USERS_RAMP_DOWN_DURATION || '30s') },
    // Total default execution time will be ~5 minutes
  ],
  thresholds: {
    // We want the 95th percentile of all HTTP request durations to be less than 500ms
    http_req_duration: ['p(95)<500'],
    // Thresholds based on the custom metric we defined and use to track application failures
    check_failure_rate: [
      // Global failure rate should be less than 1%
      'rate<0.01',
      // Abort the test early if it climbs over 3%
      { threshold: 'rate<=0.03', abortOnFail: true },
    ],
  },
}

export default function main() {
  example1Tests(session)
  example2Tests(session)
}
