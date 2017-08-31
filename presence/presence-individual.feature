@presence
Feature: Presence Individual
	Presence is deepstream's way of allowing clients to know
	about other clients

	Scenario: Multiple client's are notified of login from other server

		Given client A connects and logs into server 1
			And client B connects and logs into server 1
			And client C connects and logs into server 2

		When clients "A,B,C" subscribes to presence events for "D"
			And client D connects and logs into server 1
		
		Then clients "A,B,C" are notified that client "D" logged in

	Scenario: Client is notified of logins from other servers

		Given client A connects and logs into server 1
			And client A subscribes to presence events for "C"

		When client B connects and logs into server 1
			And client C connects and logs into server 2
			And client OPEN connects and logs into server 2

		Then client "A" is notified that clients "C" logged in

	Scenario: Multiple client's are notified of logout from other server

		Given client A connects and logs into server 1
			And client B connects and logs into server 1
			And client C connects and logs into server 2
			And client D connects and logs into server 2

		When clients "A,B,C" subscribes to presence events for "D"
			And client D logs out

		Then clients "A,B,C" are notified that client "D" logged out
