Feature: API Data Syncronization
  In order to reference CCP game data
  As an application
  I want to sync data from CCP API
  
  Scenario: Refresh Alliance Data
    Given I have no Alliances
    When I run the rake task "api:alliances:refresh"
    Then I should have 1165 Alliances  
    And I should see the Alliance "GoonSwarm"
