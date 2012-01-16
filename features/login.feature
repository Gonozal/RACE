@javascript
Feature: A User should be able to Manage and create his account.
  In order to manage my account
  As a user
  I want to be able to login and logout

  Scenario Outline: login
    Given the following account record
      | name    | password | email             |
      | Gonozal | 123456   | mail@some-mail.de |
    And the following character record
      | name      |
      | Mr Labman |
    When I go to the login page
    And I fill in "Name" with "<name>"
    And I fill in "Password" with "<password>"
    And I press "login"
    Then I should <action1>
    And I should <action2>
    
    Examples:
      | name      | password  | action1                         | action2       |
      | Gonozal   | 123456    | see "Welcome to RACE"           | see "logout"  |
      | Gonozal3  | 123456    | see "invalid account name or password" | see "login"   |
      | Gonozal   | 1234567   | see "invalid account name or password" | see "login"   |
      | '*å‚√åƒ   | ¶][¢ƒ™]   | see "invalid account name or password" | see "login"   |
      
  @javascript
  Scenario: password recoverey Step 1
    Given the following account record
      | name    | password | email             |
      | Gonozal | 123456   | mail@some-mail.de |
    When I go to the login page
    And I follow "password_forgotten"
    Then I should be on the forget page
    When I fill in "Email" with "mail@some-mail.de"
    And I press "change password"
    Then I should see "An email with further instructions"
    
  @javascript
  Scenario: Password recovery Step 2
    Given the following account record
      | name    | password | email             | forgot_password_hash |
      | Gonozal | 123456   | mail@some-mail.de | 123ABC               |
    When I go to the password_reset page
    Then I should see the edit account form
    When I fill in "Password" with "1234567"
    And I fill in "Password confirmation" with "1234567"
    And I press "change password"
    Then I should see "Successfully set new password."
    And I should be on the login page
    When I fill in "Name" with "Gonozal"
    And I fill in "Password" with "1234567"
    And I press "login"
    Then I should see "logout"
    
  @javascript
  Scenario: Failed password recovery
    Given the following account record
      | name    | password | email             | forgot_password_hash |
      | Gonozal | 123456   | mail@some-mail.de | 123ABC               |
    When I go to the password_reset page
    Then I should see the edit account form
    When I fill in "Password" with "1234567"
    And I fill in "Password confirmation" with "1987654321"
    And I press "change password"
    Then I should see "doesn't match confirmation" within ".alert"
  
  
  