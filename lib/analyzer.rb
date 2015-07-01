# Main class for program
module SiteAnalyzer
  require 'analyzer/page'
  require 'analyzer/site'
  require 'analyzer/report'
  require 'rubygems'
  require 'nokogiri'
  require 'addressable/uri'
  require 'open-uri'
  require 'timeout'
  require 'robotstxt'
  class << self
    def new
      @instance = nil
      @instance ||= self
    end
  end
end
