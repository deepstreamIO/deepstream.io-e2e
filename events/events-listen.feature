@events
Feature: Event Listening
	Events Listen are deepstream's active publish-subscribe
	providers.

	Background:
		Given publisher A connects and logs into server 1
			And publisher B connects and logs into server 1
			And publisher C connects and logs into server 2
			And publisher D connects and logs into server 3

			And subscriber 1 connects and logs into server 1
			And subscriber 2 connects and logs into server 2
			And subscriber 3 connects and logs into server 3

	Scenario: A long scenario that does lots of random stuff

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher D listens to an event with pattern "event/.*"

		When publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
			And subscriber 1 subscribes to an event named "event/1"
		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"
		Then publisher D receives 0 match "event/1" for pattern "event/.*"

		When publisher A rejects a match "event/2" for pattern "event/[a-z0-9]"
			And publisher D accepts a match "event/2" for pattern "event/.*"
			And subscriber 3 subscribes to an event named "event/2"
		Then publisher A receives 0 match "event/2" for pattern "event/[a-z0-9]"
		Then publisher D receives 1 match "event/2" for pattern "event/.*"

		When publisher C listens to an event with pattern "another-event"
			And publisher C accepts a match "another-event" for pattern "another-event"
			And subscriber 3 subscribes to an event named "another-event"
		Then publisher C receives 1 match "another-event" for pattern "another-event"

		When subscriber 2 subscribes to an event named "another-event"
		Then publisher C receives 1 match "another-event" for pattern "another-event"

		When subscriber 2 unsubscribes from an event named "another-event"
			And subscriber 3 unsubscribes from an event named "another-event"
		Then publisher C removed 1 match "another-event" for pattern "another-event"

		When subscriber 1 subscribes to an event named "another-event"
		Then publisher C receives 2 matches "another-event" for pattern "another-event"

		When server 2 goes down
			And server 2 comes back up

		Then publisher C receives 3 matches "another-event" for pattern "another-event"

	Scenario: A publisher which accepts two times to a pattern

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
			And publisher A accepts a match "event/2" for pattern "event/[a-z0-9]"
			And subscriber 1 subscribes to an event named "event/1"
			And subscriber 1 subscribes to an event named "event/2"
			And subscriber 1 subscribes to an event named "weather"

		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"
			And publisher A receives 1 match "event/2" for pattern "event/[a-z0-9]"
			And publisher A does not receive a match "weather" for pattern "event/[a-z0-9]"

	Scenario: A publisher which listen, unlisten and listen again

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
			And subscriber 1 subscribes to an event named "event/1"

		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"
			And publisher A does not receive a match "weather" for pattern "event/[a-z0-9]"

		When publisher A unlistens to the pattern "event/[a-z0-9]"
			And publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"

		Then publisher A receives 2 matches "event/1" for pattern "event/[a-z0-9]"
			And publisher A does not receive a match "weather" for pattern "event/[a-z0-9]"

	Scenario: Two publishers, first rejects and second accepts

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher B listens to an event with pattern "event/.*"
			And publisher A rejects a match "event/1" for pattern "event/[a-z0-9]"
			And publisher B accepts a match "event/1" for pattern "event/.*"
			And subscriber 1 subscribes to an event named "event/1"

		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"
			And publisher B receives 1 match "event/1" for pattern "event/.*"

	Scenario: Two publishers, first accepts, second gets nothing

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher B listens to an event with pattern "event/.*"
			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
			And subscriber 1 subscribes to an event named "event/1"

		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"
			And publisher B does not receive a match "event/1" for pattern "event/.*"

	Scenario: Three publishers, first two rejects, third accepts

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher B listens to an event with pattern "event/.*"
			And publisher C listens to an event with pattern "event/[0-9]"
			And publisher A rejects a match "event/1" for pattern "event/[a-z0-9]"
			And publisher B rejects a match "event/1" for pattern "event/.*"
			And publisher C accepts a match "event/1" for pattern "event/[0-9]"
			And subscriber 1 subscribes to an event named "event/1"

		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"
			And publisher B receives 1 match "event/1" for pattern "event/.*"
			And publisher C receives 1 match "event/1" for pattern "event/[0-9]"

	Scenario: Four publishers, first three rejects, third accepts

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher B listens to an event with pattern "event/.*"
			And publisher C listens to an event with pattern "event/[0-9]"
			And publisher D listens to an event with pattern "event/[0-9]"
			And publisher A rejects a match "event/1" for pattern "event/[a-z0-9]"
			And publisher B rejects a match "event/1" for pattern "event/.*"
			And publisher C rejects a match "event/1" for pattern "event/[0-9]"
			And publisher D accepts a match "event/1" for pattern "event/[0-9]"
			And subscriber 1 subscribes to an event named "event/1"

		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"
			And publisher B receives 1 match "event/1" for pattern "event/.*"
			# Can't guarantee C recieves it since it could ask D first
			And publisher C receives 1 match "event/1" for pattern "event/[0-9]"
			And publisher D receives 1 match "event/1" for pattern "event/[0-9]"


	Scenario: A single publisher on a different server as the subscriber

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
			And subscriber 3 subscribes to an event named "event/1"

		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"


	Scenario: Two publishers, first accepts, unlistens and then second accepts

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher D listens to an event with pattern "event/.*"
			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
			And publisher D accepts a match "event/1" for pattern "event/.*"
			And subscriber 1 subscribes to an event named "event/1"

		Then publisher A receives 1 match "event/1" for pattern "event/[a-z0-9]"
			And publisher D does not receive a match "event/1" for pattern "event/.*"

		When publisher A unlistens to the pattern "event/[a-z0-9]"

		Then publisher D receives 1 match "event/1" for pattern "event/.*"
