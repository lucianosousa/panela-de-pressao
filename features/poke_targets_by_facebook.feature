Feature: Poke targets by Facebook
  In order to engage influencers to the campaign
  As a citizen
  I want to poke targets by Facebook

  @omniauth_test @koala @javascript
  Scenario: when I have a Facebook authorization
    Given I'm logged in
    And there is a campaign called "Impeça a demolição da praça Nossa Senhora da Paz"
    And there is a target for this campaign
    And I already poked this campaign
    And I'm in this campaign page
    When I press "Pressionar no facebook"
    Then a facebook poke should be added to the target
    And an email called "Impeça a demolição da praça Nossa Senhora da Paz" should be sent

  @omniauth_test @javascript @koala
  Scenario: when I poke a campaign twice
    Given I'm logged in
    And there is a campaign called "Impeça a demolição da praça Nossa Senhora da Paz"
    And there is a target for this campaign
    And I already poked this campaign
    And I'm in this campaign page
    When I press "Pressionar no facebook"
    Then an email called "Impeça a demolição da praça Nossa Senhora da Paz" should be sent
  
  @omniauth_test @koala
  Scenario: when I'm not logged in
    Given there is a campaign called "Impeça a demolição da praça Nossa Senhora da Paz"
    And there is a target for this campaign
    And I'm in this campaign page
    When I press "Pressionar no facebook"
    Then a facebook poke should be added to the target
    And an email called "Impeça a demolição da praça Nossa Senhora da Paz" should be sent
