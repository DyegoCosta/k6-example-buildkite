import { sleep, group } from 'k6'

export default function main(http) {
  group('Example 2', function () {
    group('FooBar', function () {
      http.get('/foobar')
    })
  })
}
