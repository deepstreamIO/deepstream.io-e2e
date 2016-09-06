@presence
Feature: Presence
	Presence is deepstream's way of allowing clients to know
	about other clients

	Background:
		Given subscriber A connects to server 1
			And subscriber A logs in with username "A" and password "pass"
		

	Scenario: Client is notified of logins and logouts
		Given subscriber A subscribes to client login events
			And subscriber A subscribes to client logout events
			
		When subscriber B connects to server 1
			And subscriber B logs in with username "B" and password "pass"
			Then subscriber A is notified that client B logged in

		When subscriber C connects to server 2
			And subscriber C logs in with username "C" and password "pass"
			Then subscriber A is notified that client C logged in

		When subscriber D connects to server 3
			And subscriber D logs in with username "D" and password "pass"
			Then subscriber A is notified that client D logged in

		When subscriber C logs out
			Then subscriber A is notified that client C logged out

		When subscriber B logs out
			Then subscriber A is notified that client B logged out

		When subscriber D logs out
			Then subscriber A is notified that client D logged out

	Scenario: Client is able to query for connected clients
		Given subscriber B connects to server 1
			And subscriber B logs in with username "B" and password "pass"

		Given subscriber C connects to server 2
			And subscriber C logs in with username "C" and password "pass"

		Given subscriber D connects to server 3
			And subscriber D logs in with username "D" and password "pass"

		When subscriber A queries for connected clients
			Then subscriber A knows that clients "A,B,C,D" are connected