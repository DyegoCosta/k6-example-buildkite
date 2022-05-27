import { sleep, group } from 'k6'

export default function main(http) {
  group('Example 1', function () {
    group('Root', function () {
      http.get('/')
    })
  })
}
