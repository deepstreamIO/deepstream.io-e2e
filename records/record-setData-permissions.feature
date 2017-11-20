@records @permissions
Feature: Clients able to set data of a record without being subscribed to it

  Background:
    Given "complex" permissions are used
      And client A connects and logs into server 1
      And client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3

  Scenario: Clients receive global permission error on stateless writes
    Given client A gets the record "public-read-private-write/A"
      And client A subscribes to record "public-read-private-write/A"

    When client B sets the record "public-read-private-write/A" without being subscribed with data '{"value": 0}'
      Then client A doesn't receive an update for record "public-read-private-write/A"
      And client B receives "RECORD" error "MESSAGE_DENIED"

  # write acknowledgements

  Scenario: Clients receive write ack permission error
    Given client A gets the record "public-read-private-write/A"
      And client A subscribes to record "public-read-private-write/A"

    When client B sets the record "public-read-private-write/A" without being subscribed with data '{"value": 0}' and requires write acknowledgement
      Then client A doesn't receive an update for record "public-read-private-write/A"
      Then client B is told that the record "public-read-private-write/A" experienced error "MESSAGE_DENIED" while setting
