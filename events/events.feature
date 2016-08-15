@events
Feature: Events
	Events are deepstream's publish-subscribe
	pattern.


	Background:
		Given client 1 connects to server 1
			And client 1 logs in with username "XXX" and password "YYY"
			And client 2 connects to server 2
			And client 2 logs in with username "XXX" and password "YYY"

	Scenario: Events
		Given client 1 subscribes to an event named "event1"
			And client 2 subscribes to an event named "event1"

		When client 2 publishes an event named "event1" with data "someData"

		Then client 1 received the event "event1" with data "someData"
			And client 2 received the event "event1" with data "someData"

		When client 1 unsubscribes from an event named "event1"
			And client 1 publishes an event named "event1" with data "someOtherData"

		Then client 1 recieved no event named "event1"
			But client 2 received the event "event1" with data "someOtherData"
