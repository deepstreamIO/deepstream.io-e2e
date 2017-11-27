@records @listening
Feature: Record Listening
  Listening allows active-providing of records

  Background:
    Given publisher A connects and logs into server 1
    And publisher A listens to a record with pattern "^records/[a-z]+$"
    And publisher A accepts a record match "records/abc" for pattern "^records/[a-z]+$"
    And subscriber 1 connects and logs into server 1

  Scenario: Getting a record that has providers
    When subscriber 1 gets the record "records/abc"
    Then subscriber 1 has record "records/abc" with providers

  Scenario: Getting a record that has no providers
    When subscriber 1 gets the record "records/123"
    Then subscriber 1 has record "records/123" without providers

  Scenario: Unproviding a record notifies subscribers
    Given subscriber 1 gets the record "records/abc"
    When publisher A unlistens to the record pattern "^records/[a-z]+$"
    Then subscriber 1 has record "records/abc" without providers

  # FIXME: current framework does not allow listening and immediately accepting
  # Scenario: Providing a record notifies subscribers
  #   Given subscriber 1 gets the record "records/123"
  #   When publisher A listens to a record with pattern "^records/[0-9]+$"
  #     And publisher A accepts a record match "records/123" for pattern "^records/[0-9]+$"
  #   Then subscriber 1 has record "records/123" with providers
