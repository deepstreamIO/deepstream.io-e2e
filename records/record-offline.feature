@records @records-offline
Feature: Record Connectivity
  Background:
    Given client A connects and logs into server 1
     And client B connects and logs into server 1
     And client C connects and logs into server 2
     And client D connects and logs into server 3
      And a small amount of time passes
      And all clients get the record "record"
      And client A sets the record "record" with data '{ "user": { "firstname": "John" } }'

  Scenario: Have record, go offline, don't make any updates then come back online and have same data
    When client A goes offline
      And a small amount of time passes
      And client A comes back online
      And a small amount of time passes
      Then all clients have record "record" with path "user.firstname" and data 'John'

  Scenario: Multiple updates by offline client are received properly by other clients (online has incorrect version)
    When client A goes offline
      And a small amount of time passes
      And client A sets the record "record" and path "user.firstname" with data 'Bob'
      And client A sets the record "record" and path "user.firstname" with data 'Alex'
      And client A sets the record "record" and path "user.firstname" with data 'Charlie'
     When client A comes back online
      And a small amount of time passes
     Then all clients have record "record" with path "user.firstname" and data 'Charlie'

  Scenario: Multiple updates by clients are received properly by offline client (offline has incorrect version)
    When client A goes offline
      And client B sets the record "record" and path "user.firstname" with data 'Bob'
      And client C sets the record "record" and path "user.firstname" with data 'Alex'
      And client D sets the record "record" and path "user.firstname" with data 'Charlie'
      And a small amount of time passes
    When client A comes back online
      And a small amount of time passes
      Then all clients have record "record" with path "user.firstname" and data 'Charlie'

  Scenario: Creating records and updating created records while offline
    When client A goes offline
      And client A gets the record "record-offline"
      And client A sets the record "record-offline" and path "user.firstname" with data 'Murilo'
    When client A comes back online
      And And all clients get the record "record-offline"
      And a small amount of time passes
      Then all clients have record "record-offline" with path "user.firstname" and data 'Murilo'

  Scenario: Create record while offline then receive remote updates
    When client A goes offline
      And client A gets the record "empty-offline"
      And client B gets the record "empty-offline"
      And client B sets the record "empty-offline" and path "user.firstname" with data 'Srushtika'
      And a small amount of time passes
    When client A comes back online
      And And all clients get the record "empty-offline"
      And a small amount of time passes
      Then all clients have record "empty-offline" with path "user.firstname" and data 'Srushtika'

  Scenario: Update record while servers are down
    When server 1,2,3,4 goes down
      And a small amount of time passes
      And client A sets the record "record" and path "user.firstname" with data 'Maria'
     When server 1 comes back up
      And a small amount of time passes
      Then all clients have record "record" with path "user.firstname" and data 'Maria'
      And all clients receives at least one "CONNECTION" error "CONNECTION_ERROR"
@wip
  Scenario: Discarding while offline
    When client A goes offline
    And a small amount of time passes
      And client A sets the record "record" and path "user.firstname" with data 'Joao'
      And client A discards record "record"
      And a small amount of time passes
      And client A comes back online
      And a small amount of time passes
    Then client B,C,D have record "record" with path "user.firstname" and data 'John'

@ignore
  Scenario: Deleting while offline
    When client A goes offline
      And client A deletes record "record"
      And client B sets the record "record" and path "user.firstname" with data 'Bob'
      And client C sets the record "record" and path "user.firstname" with data 'Alex'
      And client D sets the record "record" and path "user.firstname" with data 'Charlie'

    When client A comes back online
      And a small amount of time passes
      Then all clients get notified of record "record" getting deleted

@ignore
  Scenario: update and come back online but record has been deleted
    When client A goes offline
      And client A sets the record "record" with data '{ "hello": "there" }'
      And client B deletes record "record"
    When client A comes back online
      Then client A recieves a "record has been deleted error"
      And all clients get notified of record "record" getting deleted

@ignore
  Scenario: Deleting/discarding/creating records (changelog type thing) while offline and come back online
    When client A goes offline
      And client A deletes record "record"
      And client A gets the record "record"
      And client A sets the record "record" with data '{ "hello": "there" }'
    When client A comes back online
      Then all clients get notified of record "record" getting deleted
    When all clients get the record "record"
      Then all clients have record "record" with data '{ "hello": "there" }'
