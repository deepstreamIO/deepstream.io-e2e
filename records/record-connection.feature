@records @records-connectivity
Feature: Record Connectivity

  Background:
    Given client A connects and logs into server 1
      And client B connects and logs into server 1
      And client C connects and logs into server 2
      And client D connects and logs into server 3
      And all clients get the record "record"
      And client A sets the record "record" with data '{ "user": { "firstname": "John" } }'

  Scenario: Maintains a local copy of the record
    When client A sets the record "record" and path "user.firstname" with data 'Bob'

    Then all clients have record "record" with path "user.firstname" and data 'Bob'

    When all servers go down

    Then all clients have record "record" with path "user.firstname" and data 'Bob'

    When all servers come back up


    Then all clients receive at least one "CONNECTION" error "CONNECTION_ERROR"
      And all clients have record "record" with path "user.firstname" and data 'Bob'

  @V4
  Scenario: Remote wins by default
    When server 1 goes down
      And client A sets the record "record" and path "user.firstname" with data 'Mike'
      And client A sets the record "record" and path "user.firstname" with data 'Mike1'
      And client A sets the record "record" and path "user.firstname" with data 'Mike2'

    Then client A has record "record" with path "user.firstname" and data 'Mike2'
    Then client B has record "record" with path "user.firstname" and data 'John'
    Then client C has record "record" with path "user.firstname" and data 'John'
    Then client D has record "record" with path "user.firstname" and data 'John'

    When server 1 comes back up

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
      And client B receives at least one "CONNECTION" error "CONNECTION_ERROR"
      And all clients have record "record" with path "user.firstname" and data 'John'

  #Flaky test
  #Scenario: Remote wins by default
    #When server 1 goes down
      #And client A sets the record "record" and path "user.firstname" with data 'Mike'
      #And client B sets the record "record" and path "user.firstname" with data 'Sam'

    #Then client A has record "record" with path "user.firstname" and data 'Mike'
    #Then client B has record "record" with path "user.firstname" and data 'Sam'
    #Then client C has record "record" with path "user.firstname" and data 'John'
    #Then client D has record "record" with path "user.firstname" and data 'John'

    #When server 1 comes back up

    #Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
      #And client B receives at least one "CONNECTION" error "CONNECTION_ERROR"
      #And all clients have record "record" with path "user.firstname" and data 'Mike'


