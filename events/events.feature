@events
Feature: Event publishing and subscribing
	Events are deepstream's publish-subscribe
	pattern.

	Background:
		Given publisher A connects to server 1
			And publisher A logs in with username "user" and password "pass"
			And subscriber X connects to server 2
			And subscriber X logs in with username "user" and password "pass"

	Scenario: Publish to a subscriber at the pubisher itself
		Given publisher A subscribes to an event named "event1"
			And subscriber X subscribes to an event named "event1"

		When subscriber X publishes an event named "event1" with data "someData"

		Then publisher A received the event "event1" with data "someData"
			And subscriber X received the event "event1" with data "someData"

		When publisher A unsubscribes from an event named "event1"
			And publisher A publishes an event named "event1" with data "someOtherData"

		Then publisher A recieved no event named "event1"
			But subscriber X received the event "event1" with data "someOtherData"
