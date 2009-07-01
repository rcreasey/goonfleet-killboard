Feature: Database Bootstraping
  In order to reference CCP game data
  As an application
  I want to bootstrap the database with CCP SQL dumps 
  
  Scenario: Import CCP SQL Data
    Given I have no Regions
    And I have no Solar Systems
    When I run the rake task "db:bootstrap"
    Then I should have 97 Regions  
    And I should have 7929 Solar Systems
    And I should see the Solar System "Jita"
    And I should see the Region "Delve"