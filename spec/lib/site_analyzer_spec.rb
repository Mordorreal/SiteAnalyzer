require 'spec_helper'
require 'site_analyzer'

RSpec.describe SiteAnalyzer do
  it 'has a version number' do
    expect(SiteAnalyzer::VERSION).to be
  end
  it 'can create report without robot.txt' do
    expect(SiteAnalyzer::Report.create site: 'http://savchuk.space', pages: '10', robot: 'false').to be
  end
  it 'can create report with robot.txt' do
    expect(SiteAnalyzer::Report.create site: 'http://mail.ru', pages: '10', robot: 'true').to be
  end
  it 'can make output to console' do
    expect(SiteAnalyzer::Report.create site: 'http://nash-farfor.ru', pages: '10', robot: 'true', console: 'true').to be
  end
  it 'can return hash with report' do
    expect(SiteAnalyzer::Report.create site: 'http://mail.ru', pages: '10', robot: 'false').to be
  end
  it 'test of hash params' do
    expect(SiteAnalyzer::Report.create({:site => "http://google.com", :pages => "10", :robot => "false"})).to be
  end
end
