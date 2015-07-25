require 'spec_helper'
require 'site_analyzer'

RSpec.describe SiteAnalyzer do
  it 'has a version number' do
    expect(SiteAnalyzer::VERSION).to be
  end
  it 'can create report without robot.txt' do
    expect(SiteAnalyzer::Report.create site: 'http://savchuk.space', pages: 10, robot: false).to be
  end
  it 'can create report with robot.txt' do
    expect(SiteAnalyzer::Report.create site: 'http://mail.ru', pages: 10, robot: true).to be
  end
  it 'can make output to console' do
    expect(SiteAnalyzer::Report.create site: 'http://google.ru', pages: 10, robot: false, console: true).to be
  end
end
