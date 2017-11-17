@http @batching
Feature: Interacting with events via the http APIs

  Background:
    Given client A connects and logs into server 1
      And client B authenticates with http server 2

  Scenario: emit many events
    Given client A subscribes to the event "batch_event"

    When client B queues "5000" events "batch_event" with data { "x": "my_data" }
      And client B flushes their http queue

    Then client B's last response was a "SUCCESS" with length "5000"
      And client A eventually receives "5000" events "batch_event" with data { "x": "my_data" }

  Scenario: emit many random messages
    Given client A subscribes to the event "eventName"
      And client A gets the record "recordName"
      And client A provides the RPC "addTwo"

    When client B queues "100" random messages
      And client B flushes their http queue

    Then client B's last response was a "SUCCESS" with length "100"

