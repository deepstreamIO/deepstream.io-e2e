@records @records-offline @permissions
Feature: Record Connectivity

  Background:
    Given "complex" permissions are used
      And client A connects and logs into server 1
      And client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3
      And a small amount of time passes
      And all clients get the record "record-offline/A"
      And client A sets the record "record-offline/A" with data '{ "user": { "firstname": "John" } }'

  Scenario: go offline and do updates then when back online not permissioned errors
    When client B goes offline
      And client B sets the record "record-offline/A" and path "user.firstname" with data 'Bob'
      And client B sets the record "record-offline/A" and path "user.firstname" with data 'Charlie'
    When client B comes back online
      And a small amount of time passes
      Then client A,C,D have record "record-offline/A" with data '{ "user": { "firstname": "John" } }'
       And client B receives a "MESSAGE_DENIED" error on record "record-offline/A"
