Feature: API Data Syncronization
  In order to reference CCP game data
  As an application
  I want to sync data from CCP API
  
  Scenario: Refresh Alliance Data
    Given I have no Alliances
    When I run the rake task "api:alliances:refresh"
    Then I should have at least 1 Alliances  
    And I should see the Alliance "GoonSwarm"

  Scenario: Refresh Alliance Logo Mapping
    Given the following Alliance records
    | name      | short_name | eve_id    |
    | GoonSwarm | OHGOD      | 824518128 |
    When I run the rake task "api:alliances:logos"
    And I should see the Alliance "GoonSwarm"
    Then the Alliance "GoonSwarm" has attribute "logo" set to "23_02"