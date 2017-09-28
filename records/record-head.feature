@records @head
Feature: Record HEAD

  Background:
    Given client A connects and logs into server 1
      And client B connects and logs into server 2
      And client A gets the record "headRecord"

  Scenario: Returns error when record not found
    Given client A asks for the version of record "nonExistantRecord"
      Then client A gets a head response for "nonExistantRecord" with error 'RECORD_NOT_FOUND'

  Scenario: Local HEAD returns correct version
    Given client A asks for the version of record "headRecord"
    Then client A gets told record "headRecord" has version 0

  Scenario: Remote HEAD returns correct version
    Given client B asks for the version of record "headRecord"
    Then client B gets told record "headRecord" has version 0

  Scenario: Record written to and new version returned
    Given client A gets the record "incrementVersion"
      When client B asks for the version of record "incrementVersion"
      Then client B gets told record "incrementVersion" has version 0

    When client A sets the record "incrementVersion" with data '{ "user": { "firstname": "John" } }'
      And a small amount of time passes
      And a small amount of time passes
      And client B asks for the version of record "incrementVersion"
      Then client B gets told record "incrementVersion" has version 1
