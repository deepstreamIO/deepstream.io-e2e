@presence @connection
Feature: Presence Connectivity
  Presence subscriptions must be resent to the
  server after connection issues to guarantee
  it continues recieving them correctly.

  Scenario: Subscriptions to all users should be resumed after servers restart
    Given client A connects and logs into server 1
        And client A subscribes to presence events

    When server 1 goes down
      And server 2 goes down
      And server 3 goes down
      And server 1 comes back up
      And server 2 comes back up
      And server 3 comes back up

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

    When server 1 goes down
      And server 2 goes down
      And server 3 goes down
      And server 1 comes back up
      And server 2 comes back up
      And server 3 comes back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		  And client "A" is notified that clients "B,C,D" logged in

    When client B logs out
      And client C logs out
      And client D logs out
		  Then client "A" is notified that clients "B,C,D" logged out

  Scenario: Unsubscribing while offline works
    Given client A connects and logs into server 1
		  And client A subscribes to presence events for "B,C,D"

    When server 1 goes down
      And server 2 goes down
      And server 3 goes down
		  And client A unsubscribes to presence events for "B,C,D"
      And server 1 comes back up
      And server 2 comes back up
      And server 3 comes back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		  And client "A" is not notified that clients "B,C,D" logged in

    When client B logs out
      And client C logs out
      And client D logs out
		  Then client "A" is not notified that clients "B,C,D" logged out

  Scenario: Subscribing while offline works
    Given client A connects and logs into server 1

    When server 1 goes down
      And server 2 goes down
      And server 3 goes down
		  And client A subscribes to presence events for "B,C,D"
      And server 1 comes back up
      And server 2 comes back up
      And server 3 comes back up

    When client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
		  And client "A" is notified that clients "B,C,D" logged in

    When client B logs out
      And client C logs out
      And client D logs out
		  Then client "A" is notified that clients "B,C,D" logged out
