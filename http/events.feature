@http @events
Feature: Interacting with events via the http APIs

  Background:
    Given "complex" permissions are used
      And client W connects and logs into server 1
      And client A authenticates with http server 2
      And client B authenticates with http server 2

  Scenario: emit an event without data
    Given client W subscribes to the event "emit_event"

    When client A queues an event "emit_event"
      And client A flushes their http queue

    Then client W receives the event "emit_event"

  Scenario: emit an event with data
    Given client W subscribes to the event "emit_event"

    When client A queues an event "emit_event" with data { "x": "my_data" }
      And client A flushes their http queue

    Then client W receives the event "emit_event" with data { "x": "my_data" }

  Scenario: emit multiple events
    Given client W subscribes to the event "eventOne"
      And client W subscribes to the event "eventTwo"

    When client A queues an event "eventOne" with data "1"
      And client A queues an event "eventTwo" with data "2"
      And client A flushes their http queue

    Then client W receives the event "eventOne" with data "1"
      And client W receives the event "eventTwo" with data "2"

  Scenario: Clients can be prevented from subscribing and publishing
    Given client W subscribes to an event "forbidden/this"

    When client A queues an event "forbidden/this" with data 44
      And client A flushes their http queue

    Then client W receives "EVENT" error "MESSAGE_DENIED"
      And client A's last response had an "event" error matching "message denied"

  Scenario: Concurrent event emits have correct permissions
    Given client W subscribes to an event "forbidden/this"

    When client A queues an event "forbidden/this" with data 1
      And client A queues an event "allow-this" with data 2
      And client A queues an event "forbidden/this" with data 3
      And client A queues an event "allow-this" with data 4
      And client A flushes their http queue

    Then client W receives "EVENT" error "MESSAGE_DENIED"
      And client A's last response had an "event" error matching "message denied" at index "0"
      And client A's last response had a success at index "1"
      And client A's last response had an "event" error matching "message denied" at index "2"
      And client A's last response had a success at index "3"

  Scenario: only a can emit the event a-to-b
    When clients A,B queue an event "a-to-b/some-event"
      And clients A,B flush their http queues

    Then client A's last response was a "SUCCESS"
      And client B's last response was a "FAILURE"

  Scenario: Asserts user roles using server data
    Given client C authenticates with http server 2 with details {"username": "userA", "password": "abcdefgh"}
      And client D authenticates with http server 2 with details {"username": "userB", "password": "123456789"}
      And client W subscribes to an event "admin-publish"

    When clients C,D queue an event "admin-publish"
      And client C flushes their http queue

    Then client C's last response had an "event" error matching "message denied"
      And client W receives no event "admin-publish"

    When client D flushes their http queue
    Then client D's last response was a "SUCCESS"
      And client W receives the event "admin-publish"
