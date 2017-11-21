@login @reconnectivity
Feature: Reauthorisation to deepstream

  Scenario: Client reconnects with successfully unchanged client data
    Given client A connects to server 1
     When client A logs in with username "userA" and password "abcdefgh"
      And server 1 goes down
      And server 1 comes back up

    Then client A receives at least one "CONNECTION" error "CONNECTION_ERROR"
      And client A's "login" callback was called once
      And client A's "reauthenticationFailure" callback was not called
      And client A's "clientDataChanged" callback was not called once

  Scenario: Client reconnects with changed client data
    Given client randomClientData's connects and logs into server 1
      And client randomClientData's "clientDataChanged" callback was called once
      And server 1 goes down
      And server 1 comes back up

    Then client randomClientData receives at least one "CONNECTION" error "CONNECTION_ERROR"
      And client randomClientData's "login" callback was called once
      And client randomClientData's "reauthenticationFailure" callback was not called
      And client randomClientData's "clientDataChanged" callback was called once

  Scenario: Client reconnection fails
    Given client onlyLoginOnce connects and logs into server 1
      And server 1 goes down
      And server 1 comes back up

    Then client onlyLoginOnce receives at least one "CONNECTION" error "CONNECTION_ERROR"
      And client onlyLoginOnce's "login" callback was called once
      And client onlyLoginOnce's "reauthenticationFailure" callback was called once
      And client onlyLoginOnce's "clientDataChanged" callback was not called
