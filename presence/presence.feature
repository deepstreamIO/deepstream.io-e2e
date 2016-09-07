@presence
Feature: Presence
	Presence is deepstream's way of allowing clients to know
	about other clients

	Scenario: Client's are notified of logins from other servers

		Given client A connects and logs into server 1
			And client B connects and logs into server 1
			And client C connects and logs into server 2	

		Then client A subscribes to presence login events
			And client B subscribes to presence login events
			And client C subscribes to presence login events
			
		When client D connects and logs into server 1
			Then clients "A,B,C" are notified that client D logged in

	Scenario: Client is notified of logins from other servers

		Given client A connects and logs into server 1
			And client A subscribes to presence login events

		When client B connects and logs into server 1
			And client C connects and logs into server 2
			And client OPEN connects and logs into server 2

		Then client "A" is notified that clients "B,C" logged in
