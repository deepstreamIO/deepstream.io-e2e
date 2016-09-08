@rpcs
Feature: RPC providing and calling on single + across multiple nodes

  Background:
    Given client A connects and logs into server 1
      And client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

  Scenario: Clients can call a provided RPC
    Given client A provides the RPC "addTwo"

    When client A calls the RPC "addTwo" with arguments { "numA": 1, "numB": 2 }
    Then client A receives a response for RPC "addTwo" with data 3

    When client B calls the RPC "addTwo" with arguments { "numA": 3, "numB": 7 }
    Then client B receives a response for RPC "addTwo" with data 10

    When client C calls the RPC "addTwo" with arguments { "numA": 14, "numB": 35 }
    Then client C receives a response for RPC "addTwo" with data 49

    #When client D calls the RPC "addTwo" with arguments { "numA": "red", "numB": "rum" }
    #Then client D receives a response for RPC "addTwo" with data "redrum"

  Scenario: When the only provider of an RPC rejects, give an error
    Given client A provides the RPC "wontWork"

    When client B calls the RPC "wontWork" with arguments { "bill": 1, "ben": 2 }

    Then client B receives a response for RPC "wontWork" with error "NO_RPC_PROVIDER"
