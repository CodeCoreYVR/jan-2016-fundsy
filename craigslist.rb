require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'

Capybara.run_server = false
Capybara.current_driver = :webkit
Capybara.app_host = "http://vancouver.craigslist.ca"

module Spider
  class Craigslist
    include Capybara::DSL

    def search
      visit "/search/jjj"
      fill_in "query", with: "ruby"
      page.find(".searchbtn").click
      all("div.content p.row span.txt span.pl a").each do |a|
        puts a.text
      end
    end
  end
end

spider = Spider::Craigslist.new
spider.search
