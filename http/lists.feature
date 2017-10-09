@http @records
Feature: Interact with lists via the HTTP APIs

  Background:
    Given "complex" permissions are used
      And client A connects and logs into server 1
      And client B authenticates with http server 2

  Scenario: Getting a list
    Given client A gets the list "some-list"
      And client A sets the entries on the list "some-list" to '["alex", "jeff"]'

    When client B queues a fetch for list "some-list"
      And client B flushes their http queue

    Then client B receives the list "some-list" with data '["alex", "jeff"]'

  Scenario: Creating a record
    When client B queues a write to list "new-list" with data '["an-entry"]'
      And client B flushes their http queue
      And client A gets the list "new-list"

    Then client A have a list "new-list" with entries '["an-entry"]'

  Scenario: Updating a list
    Given client A gets the list "update-list"
      And client A sets the entries on the list "update-list" to '["stale"]'

    When client B queues a write to list "update-list" with data '["fresh"]'
      And client B flushes their http queue

    Then client A have a list "update-list" with entries '["fresh"]'

  Scenario: Deleting a record
    Given client A gets the record "delete-list"

    When client B queues a delete for list "delete-list"
      And client B flushes their http queue

    Then client A gets notified of record "delete-list" getting deleted

  Scenario: Updating a list with non string entries fails
    When client B queues a write to list "failure-list" with data '[ { "willFail": true } ]'
      And client B flushes their http queue
    Then client B's last response had an error matching "Failed to parse JIF object"
