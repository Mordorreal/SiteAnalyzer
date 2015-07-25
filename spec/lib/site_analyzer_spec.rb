require 'spec_helper'
require 'site_analyzer'

RSpec.describe SiteAnalyzer do
  it 'has a version number' do
    expect(SiteAnalyzer::VERSION).to be
  end
  before do
      SiteAnalyzer.add_site 'http://savchuk.space', 5, false
      SiteAnalyzer.add_site 'https://mail.ru', 5
      SiteAnalyzer.add_site 'http://google.ru', 15, false
      SiteAnalyzer.start
  end
  describe '.add_site(site_url, max_pages = 100, robottxt = false)' do
    it 'add site with deep and robot.txt if needed in list' do
      expect(SiteAnalyzer.add_site 'https://mail.ru', 5, true).to be
    end
  end
  describe '.start' do
    it 'make report for each site in list @report' do
      expect(SiteAnalyzer.start).to be
    end
  end
  describe '.show_all_reports' do
    it 'show all reports in console' do
      expect(SiteAnalyzer.show_all_reports).to be
    end
  end
  describe '.show_report(number)' do
    it 'show report with number' do
      expect(SiteAnalyzer.show_report(1)).to be
    end
  end
end
