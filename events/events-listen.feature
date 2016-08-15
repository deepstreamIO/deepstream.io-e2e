@events
Feature: Events
	Events Listen are deepstream's active publish-subscribe
	providers.

	Background:
		Given publisher A connects to server 1
			And publisher A logs in with username "user" and password "pass"
			And subscriber X connects to server 1
			And subscriber X logs in with username "user" and password "pass"

	Scenario: A publisher which accepts two times to a pattern

		When publisher A listens to an event with pattern "event/[a-z0-9]"
			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
			And publisher A accepts a match "event/2" for pattern "event/[a-z0-9]"
			And subscriber X subscribes to an event named "event/1"
			And subscriber X subscribes to an event named "event/2"
			And subscriber X subscribes to an event named "weather"

		Then publisher A receives a match "event/1" for pattern "event/[a-z0-9]"
			And publisher A receives a match "event/2" for pattern "event/[a-z0-9]"
			And publisher A does not receive a match "weather" for pattern "event/[a-z0-9]"

#	Scenario: A publisher which listen, unlisten and listen again
#
#		When publisher A listens to an event with pattern "event/[a-z0-9]"
#			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
#			And subscriber X subscribes to an event named "event/1"
#
#		Then publisher A receives a match "event/1" for pattern "event/[a-z0-9]"
#			And publisher A does not receive a match "weather" for pattern "event/[a-z0-9]"
#
#		When publisher A unlistens to the pattern "event/[a-z0-9]"
#			And publisher A listens to an event with pattern "event/[a-z0-9]" again
#			And publisher A accepts a match "event/1" for pattern "event/[a-z0-9]"
#
#		Then publisher A receives a match "event/1" for pattern "event/[a-z0-9]"
#			And publisher A does not receive a match "weather" for pattern "event/[a-z0-9]"
#
