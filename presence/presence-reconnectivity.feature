@presence @connection
Feature: Presence Connectivity
  Presence subscriptions must be resent to the
  server after connection issues to guarantee
  it continues recieving them correctly.

  Scenario: Subscriptions to all users should be resumed after servers restart
    Given client A connects and logs into server 1
        And client A subscribes to presence events

    When all servers go down
      And all servers come back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		And client "A" is notified that clients "B,C,D" logged in

    When client B logs out
        And client C logs out
        And client D logs out
		Then client "A" is notified that clients "B,C,D" logged out

  Scenario: Subscriptions to individual users resumed after server restarts
    Given client A connects and logs into server 1
		  And client A subscribes to presence events for "B,C,D"

    When all servers go down
      And all servers come back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		  And client "A" is notified that clients "B,C,D" logged in

    When client B logs out
      And client C logs out
      And client D logs out
		  Then client "A" is notified that clients "B,C,D" logged out

  Scenario: Unsubscribing to individual users while offline works
    Given client A connects and logs into server 1
		  And client A subscribes to presence events for "B,C,D"

    When all servers go down
		  And client A unsubscribes to presence events for "B,C,D"
      And all servers come back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		  And client "A" is not notified that clients "B,C,D" logged in

    When client B logs out
      And client C logs out
      And client D logs out
		  Then client "A" is not notified that clients "B,C,D" logged out

  Scenario: Subscribing to individual users while offline works
    Given client A connects and logs into server 1

    When all servers go down
		  And client A subscribes to presence events for "B,C,D"
      And all servers come back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		  And client "A" is notified that clients "B,C,D" logged in

    When client B,C,D logs out
		  Then client "A" is notified that clients "B,C,D" logged out

  Scenario: Unsubscribing to all users while offline works
    Given client A connects and logs into server 1
		  And client A subscribes to presence events

    When all servers go down
		  And client A unsubscribes to presence events
      And all servers come back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		  And client "A" is not notified that clients "B,C,D" logged in

    When client B logs out
      And client C logs out
      And client D logs out
		  Then client "A" is not notified that clients "B,C,D" logged out

  Scenario: Subscribing to all users while offline works
    Given client A connects and logs into server 1

    When all servers go down
		  And client A subscribes to presence events
      And all servers come back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		  And client "A" is notified that clients "B,C,D" logged in

    When client B logs out
      And client C logs out
      And client D logs out
		  Then client "A" is notified that clients "B,C,D" logged out