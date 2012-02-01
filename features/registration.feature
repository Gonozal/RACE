Feature: Account and character registration
  In order to create an account
  As a guest
  I want to use the registration form
  
  @javascript
  Scenario: successfully register an account plus character
    Given there are no accounts
    And there are no corporations
    And there are no characters
    And there are no roles
    When I go to the account registration page
    Then I should see the account registration form
    When I fill in "Name" with "Codas"
    And I fill in "Password" with "secretpw"
    And I fill in "Password confirmation" with "secretpw"
    And I fill in "Email" with "test@test.com"
    And I fill in "Email confirmation" with "test@test.com"
    And I press "create account"
    Then I should see "Your Account has successfully been created!"
    When I follow "Character Registration Page"
    Then I should be on the character registration page
    And I should see the character registration form
    When I fill in "User ID" with "1144806"
    And I fill in "API Key" with "A7416C2DAA5D4283AE4EE7BB8F27BDBC96F3A01B14534656842A9783AC135A8A"
    And I press "Get Characters"
    # Mr Printman
    And I check "account_character_465753202"
    # Mr Labman
    And I check "account_character_563818696"
    And I press "Add Characters"
    Then I should see "Your character(s) have succesfully been added to your account"
    And I should have 1 Account
    And I should have 2 Characters
    And I should have 1 Corporation
  
  @javascript
  Scenario: try to create an invalid account
    Given there are no accounts
    And there are no corporations
    And there are no characters
    And there are no roles
    When I go to the account registration page
    Then I should see the account registration form
    When I fill in the following:
      | Name | Co |
      | Password | 123456 |
      | Password confirmation | 1234567 |
      | Email | keinemail |
      | Email confirmation | keinemail |
    And I press "create account"
    Then I should see "is too short (minimum is 3 characters)" within ".alert"
    And I should see "doesn't match confirmation"
    And I should see "not a valid email address"
    