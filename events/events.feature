@events
Feature: Event publishing and subscribing
  Events are deepstream's publish-subscribe
  pattern.

  Background:
    Given publisher A connects to server 1
      And publisher A logs in with username "user" and password "pass"
      And subscriber B connects to server 2
      And subscriber B logs in with username "user" and password "pass"

  Scenario: Client receives event they are subscribed to
    Given client A subscribes to an event named "event1"

    When client B publishes an event named "event1" with data "someData"

    Then client A receives the event "event1" with data "someData"

  Scenario: Client receives its own event
    Given client A subscribes to an event named "event2"
      And client B subscribes to an event named "event2"

    When client B publishes an event named "event2" with data 44

    Then client A receives the event "event2" with data 44
      And client B receives the event "event2" with data 44

  Scenario: Client subscribes and unsubscribes
    Given client A subscribes to an event named "event3"
      And client B subscribes to an event named "event3"

    When client B publishes an event named "event3" with data {"an": "object"}

    Then client A receives the event "event3" with data {"an": "object"}
      And client B receives the event "event3" with data {"an": "object"}

    When client A unsubscribes from an event named "event3"
      And client A publishes an event named "event3" with data "someOtherData"

    Then client A receives no event named "event3"
      But client B receives the event "event3" with data "someOtherData"
