# Main class for program
module SiteAnalyzer
  require 'analyzer/page'
  require 'analyzer/site'
  require 'analyzer/report'
  require 'rubygems'
  require 'nokogiri'
  require 'addressable/uri'
  require 'open-uri'
  class << self
    def new
      @instance = nil
      @instance ||= self
    end
  end
end