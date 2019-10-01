@rpcs @connection
Feature: RPC Connectivity
  RPC subscriptions must be resent to the
  server after connection issues to guarantee
  other clients can call them properly.

  Scenario: Subscriptions to all users should be resumed after servers restart
    Given client A connects and logs into server 1
      And client A provides the RPC "addTwo"

    When all servers go down
      And all servers come back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    When client B calls the RPC "addTwo" with arguments { "numA": 3, "numB": 7 }
      And client C calls the RPC "addTwo" with arguments { "numA": 3, "numB": 7 }
      And client D calls the RPC "addTwo" with arguments { "numA": 3, "numB": 7 }

    Then client B receives a response for RPC "addTwo" with data 10
      And client C receives a response for RPC "addTwo" with data 10
      And client D receives a response for RPC "addTwo" with data 10
      And client A's RPC "addTwo" is called 3 times

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"

  Scenario: Subscriptions can be removed while server is down
    Given client A connects and logs into server 1
      And client A provides the RPC "addTwo"

    When all servers go down
      And client A unprovides the RPC "addTwo"
      And all servers come back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    When client B calls the RPC "addTwo" with arguments { "numA": 3, "numB": 7 }
      And client C calls the RPC "addTwo" with arguments { "numA": 3, "numB": 7 }
      And client D calls the RPC "addTwo" with arguments { "numA": 3, "numB": 7 }

    Then client B receives a response for RPC "addTwo" with error "NO_RPC_PROVIDER"
      Then client C receives a response for RPC "addTwo" with error "NO_RPC_PROVIDER"
      Then client D receives a response for RPC "addTwo" with error "NO_RPC_PROVIDER"

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"

  Scenario: Subscriptions can be added before servers are added to the cluster
    When all servers go down
      And server 1 comes back up

    Given client A connects and logs into server 1
      And client A provides the RPC "addTwo"

    When server 2 comes back up
      And client B connects and logs into server 2

    When client B calls the RPC "addTwo" with arguments { "numA": 3, "numB": 7 }
    Then client B receives a response for RPC "addTwo" with data 10
