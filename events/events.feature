@events
Feature: Events
	Events are deepstream's publish-subscribe
	pattern.

Scenario: Events

	# The client is connected
	Given the servers are ready
		And client 1 connects to server 1
		And client 1 logs in with username "XXX" and password "YYY"
		And client 2 connects to server 2
		And client 2 logs in with username "XXX" and password "YYY"

	# Client 1 subscribes to an event
	Given client 1 subscribes to an event named "event1"
		And client 2 subscribes to an event named "event1"

	# Client 2 publishes an event
	When client 2 publishes an event named "event1" with data "someData"

	# Client 1 and Client 2 recieved the event
	Then client 1 received the event "event1" with data "someData"
		And client 2 received the event "event1" with data "someData"

	# The client unsubscribes from an event
	When client 1 unsubscribes from an event named "event1"

	# Client 1 publishes an event
	When client 1 publishes an event named "event1" with data "someOtherData"

	# Only client 2 recieved the event
	Then client 1 recieved no event named "event1"
		And client 2 received the event "event1" with data "someOtherData"

	Then the servers are stopped
