require 'rails_helper'

RSpec.describe "discussions/index", type: :view do
  before(:each) do
    assign(:discussions, [
      Discussion.create!(
        :title => "Title",
        :body => "MyText"
      ),
      Discussion.create!(
        :title => "Title",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of discussions" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
