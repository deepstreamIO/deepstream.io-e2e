@http @records
Feature: Interact with records via the HTTP APIs

  Background:
    Given "complex" permissions are used
      And client A connects and logs into server 1
      And client B authenticates with http server 2


  Scenario: Getting a record
    Given client A gets the record "some-record"
      And client A sets the record "some-record" with data '{ "name": "alex" }'

    When client B queues a fetch for record "some-record"
      And client B flushes their http queue

    Then client B receives the record "some-record" with data '{ "name": "alex" }'

  Scenario: Creating a record
    When client B queues a write to record "new-record" with data '{ "x": { "y": "z" } }'
      And client B flushes their http queue
      And client A gets the record "new-record"

    Then client A has record "new-record" with data '{ "x": { "y": "z" } }'

  Scenario: Creating a record with array data
    When client B queues a write to record "new-record" with data '["x", "y", "z"]'
      And client B flushes their http queue
      And client A gets the record "new-record"

    Then client A has record "new-record" with data '["x", "y", "z"]'

  Scenario: Updating a record
    Given client A gets the record "update-record"
      And client A sets the record "update-record" with data '{ "stale": true }'

    When client B queues a write to record "update-record" with data '{ "fresh": true }'
      And client B flushes their http queue

    Then client A has record "update-record" with data '{ "fresh": true }'

  Scenario: Multiple updates
    Given client A gets the record "rec"
      And client B sends the data { "token": "letmein", "body": [ { "topic": "record", "recordName": "rec", "action": "write", "data": { "a": "b" } }, { "topic": "record", "recordName": "rec", "action": "write", "data": { "a": "b" }, "version": 1 } ] }

    Then client A has record "rec" with data '{ "a": "b" }'
      And client B last response was a "PARTIAL_SUCCESS"
      And client B last response had a success at index "0"
      And client B last response had a "record" error matching "Record update failed" at index "1"


  Scenario: Updating a record with a path
    Given client A gets the record "nested-record"
      And client A sets the record "nested-record" with data '{ "user": { "firstName": "Morty", "lastName": "Smith" } }'

    When client B queues a write to record "nested-record" and path "user.firstName" with data 'Rick'
      And client B queues a write to record "nested-record" and path "user.lastName" with data 'Sanchez'
      And client B flushes their http queue

    Then client A has record "nested-record" with data '{ "user": { "firstName": "Rick", "lastName": "Sanchez" } }'

  Scenario: Deleting a record
    Given client A gets the record "delete-record"

    When client B queues a delete for record "delete-record"
      And client B flushes their http queue

    Then client A gets notified of record "delete-record" getting deleted


  Scenario: Getting the HEAD of a record
    Given client A gets the record "versioned-record"
      And client A sets the record "versioned-record" and path "num" with data '1'
      And client A sets the record "versioned-record" and path "num" with data '2'

    When client B queues a head for record "versioned-record"
      And client B flushes their http queue

    Then client B receives the record head "versioned-record" with version "2"

  Scenario: Updating a record with specific versions
    When client B queues a write to record "clean" with data '{"x": 1}' and version "1"
      And client B flushes their http queue

    Then client B's last response was a "SUCCESS"

    When client B queues a head for record "clean"
      And client B flushes their http queue

    Then client B receives the record head "clean" with version "1"

    When client B queues a write to record "clean" with data '{"x": 2}' and version "2"
      And client B flushes their http queue

    Then client B's last response was a "SUCCESS"

    When client B queues a write to record "clean" with data '{"x": 3}' and version "-1"
      And client B flushes their http queue

    Then client B's last response was a "SUCCESS"

    When client B queues a head for record "clean"
      And client B flushes their http queue

    Then client B receives the record head "clean" with version "3"

    When client B queues a write to record "clean" with data '{"x": 3833}' and version "3"
      And client B flushes their http queue

    Then client B's last response was a "FAILURE"

    When client B queues a fetch for record "clean"
      And client B flushes their http queue

    Then client B receives the record "clean" with data '{"x": 3}' and version "3"

  Scenario: Reading a non-existant record with fully-restricted permissions
    When client B queues a fetch for record "forbidden"
      And client B flushes their http queue

    Then client B's last response had a "record" error matching "message denied.*snapshot"

  Scenario: Creating a record with fully-restricted permissions
    When client B queues a write to record "forbidden" with data '{"Alan":"Partridge"}'
      And client B flushes their http queue

    Then client B's last response had a "record" error matching "message denied.*create"

  Scenario: Creating and setting a record with create but not write permissions
    Given client A gets the record "read-only"

    When client B queues a fetch for record "read-only"
      And client B flushes their http queue

    Then client B receives the record "read-only" with data '{}'

    When client B queues a write to record "read-only" and path "user" with data 'Morty Smith'
      And client B flushes their http queue

    Then client B's last response had a "record" error matching "message denied.*update"
