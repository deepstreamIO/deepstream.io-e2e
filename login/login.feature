@login
Feature: Login and authorisation to deepstream

  Scenario: If a client logs in with correct details, success
    Given client A connects to server 1

    When client A logs in with username "userA" and password "abcdefgh"
    Then client A receives an authenticated login response

  Scenario: If tries to login after timeout, an error is thrown
    When client A connects to server 1
    Then client A's connection times out

    When client A attempts to login with username "userA" and password "abcdefgh"
    Then client A receives no login response
      And client A receives X error IS_CLOSED

  Scenario: If username is invalid, an error is thrown
    Given client A connects to server 1

    When client A logs in with username "doesnotexist" and password "abcdefgh"
    Then client A receives an unauthenticated login response

    When client A logs in with username "doesnotexist" and password "abcdefgh"
    Then client A is notified of too many login attempts

    When client A attempts to login with username "userA" and password "abcdefgh"
    Then client A receives no login response
      And client A receives X error IS_CLOSED
