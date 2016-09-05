@events
Feature: Presence
	Presence is deepstream's way of allowing clients to know
	about other clients

	Background:
		Given subscriber A connects to server 1
			And subscriber A logs in with username "A" and password "pass"
			#And subscriber X connects to server 2
			#And subscriber X logs in with username "user" and password "pass"

	Scenario: Client is notified of logins
		Given subscriber A subscribes to client login events

		When subscriber B connects to server 1
			And subscriber B logs in with username "B" and password "pass"

		Then subscriber A is notified that client B logged in