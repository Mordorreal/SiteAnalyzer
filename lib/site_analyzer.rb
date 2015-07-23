# Main class for program
module SiteAnalyzer
  %w(page site report version).each do |file|
    require "site_analyzer/#{file}"
  end
  # require 'rubygems'
  # require 'nokogiri'
  # require 'addressable/uri'
  # require 'open-uri'
  # require 'timeout'
  # require 'robotstxt'
  class << self
    attr_reader :report
    def add_site(site_url, max_pages = 100, robottxt = false)
      @report = []
      @report << SiteAnalyzer::Report.new(site_url, max_pages, robottxt)
    end

    def start
      @report.each { |report| report.make_report }
    end

    def show_all_reports
      return "Don't have any reports" if @report.nil?
      @report.each {|report| report.to_s}
    end

    def show_report(number)
      return "Don't have report with number #{number}" if @report[number - 1].nil?
      number -= 1
      @report[number].to_s
    end

    def clear
      @report.clear
    end
  end
end
