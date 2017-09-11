@presence @permissions
Feature: Presence Permissions

  Background:
    Given "complex" permissions are used
      And clients A,B connect and log into server 1

  Scenario: Clients that are not permissioned can't subscribe
    When clients A,B subscribes to presence events
      And client C connects and logs into server 1

    Then client A receives "PRESENCE" error "MESSAGE_DENIED"
      And client B is notified that client C logged in

  Scenario: Clients that are not permissioned can't query
    When clients A,B queries for connected clients
      And a small amount of time passes
    Then client B is notified that clients "A" are connected
      And client A receives "PRESENCE" error "MESSAGE_DENIED"
