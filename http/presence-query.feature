@http @presence
Feature: Querying presence via the http APIs

  Scenario: query for currently connected clients
    Given clients A,B,C connect and log into server 1
      And client D authenticates with http server 2

    When client D queues a presence query
      And client D flushes their http queue

    Then client D's last response said that clients "A,B,C" are connected

    When clients A,C log out
      And client D queues a presence query
      And client D flushes their http queue

    Then client D's last response said that clients "B" are connected
