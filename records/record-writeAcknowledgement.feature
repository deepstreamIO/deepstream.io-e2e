@records
Feature: Record write acknowledgement

  Background:
    Given client A connects and logs into server 1
      And client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3
      And all clients get the record "record"
      And all clients require write acknowledgements for record "record"

  Scenario: Receives acknowledgement that set worked
    When client A sets the record "record" and path "user.firstname" with data 'Bob'
    Then client A is told that the record "record" was set without error
    When client A sets the record "record" and path "user.firstname" with data 'Alex'
    Then client A is told that the record "record" was set without error
    When client B sets the record "record" and path "user.firstname" with data 'Charlie'
    Then client B is told that the record "record" was set without error
    Then all clients have record "record" with path "user.firstname" and data 'Charlie'