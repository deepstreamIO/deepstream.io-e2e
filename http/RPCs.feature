@http @rpcs
Feature: Interact with RPCs via the HTTP APIs

  Background:
    Given client A connects and logs into server 1
      And client B authenticates with http server 2

  Scenario: make an RPC without data
    Given client A provides the RPC "stringify"

    When client B queues an RPC call to "stringify"
      And client B flushes their http queue

    Then client B receives an RPC response with data "undefined"

  Scenario: make an RPC with data
    Given client A provides the RPC "addTwo"

    When client B queues an RPC call to "addTwo" with arguments { "numA": 1, "numB": 2 }
      And client B flushes their http queue

    Then client B receives an RPC response with data 3

  Scenario: http tries to make an RPC that has not been provided
    When client B queues an RPC call to "notProvided" with arguments { "billy": 11, "jean": 22 }
      And client B flushes their http queue

    Then client B's last response had an "rpc" error matching "no provider"

  Scenario: When the only provider of an RPC rejects, give an error
    Given client A provides the RPC "alwaysReject"

    When client B queues an RPC call to "alwaysReject" with arguments { "bill": 1, "ben": 2 }
      And client B flushes their http queue

    Then client B's last response had an "rpc" error matching "no provider"

  Scenario: When the only provider of an RPC never responsds, give an error
    Given client A provides the RPC "neverRespond"

    When client B queues an RPC call to "neverRespond" with arguments {}
      And client B flushes their http queue

    Then client B's last response had an "rpc" error matching "response timeout"
