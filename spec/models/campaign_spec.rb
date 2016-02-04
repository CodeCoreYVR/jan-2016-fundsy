require 'rails_helper'

RSpec.describe Campaign, type: :model do

  describe "validations" do
    # it is a method that
    # takes a test example description and
    # a block of code where you can construct your test
    # every test scenario must be put with in an 'it' or 'specify' block
    it "doesn't allow creating a compain with no name" do
      # Given: compain with no title
      c = Campaign.new

      # When: we validate the campaign
      campaign_valid = c.valid?

      #Then: expect that campaign_valid = false
      expect(campaign_valid).to eq(false)
    end

    it "requires a goal" do
      # GIVEN:
      c = Campaign.new
      # WHEN:
      c.valid?
      # THEN:
      expect(c.errors).to have_key(:goal)
      # we call methods like: have_key matchers
      # RSpec and RSpec Rails come with many built-in matchers
    end

    it "requires a goal that is more than 10" do
      # Given:
      c = Campaign.new(goal: 6)

      # When:
      c.valid?

      # Then:
      expect(c.errors).to have_key(:goal)
    end

    it "requires a unique name" do
      # Given:
      Campaign.create({name: "anything abc sure", goal: 100, description: "abc"})
      c = Campaign.new(name: "anything abc sure")

      # When:
      c.valid?

      # Then:
      expect(c.errors).to have_key(:name)
    end

  end
end
