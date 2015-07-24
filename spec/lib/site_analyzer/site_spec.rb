# Tests of Site class
require 'spec_helper'
require 'site_analyzer'
RSpec.describe SiteAnalyzer::Site do
  subject(:site) { SiteAnalyzer::Site.new initial_values, 10, false }
  let(:initial_values) { 'http://savchuk.space' }

  describe '#all_titles' do
    it 'return array [page_url, title_tag_text]' do
      expect(site.all_titles.size).to be > 0
    end
  end
  describe '#all_descriptions' do
    it 'return array [page_url, [description_content]]' do
      expect(site.all_descriptions.size).to be > 0
    end
  end
  describe '#all_h2' do
    it 'return array [page_url, [h2_text]]' do
      expect(site.all_h2).to be
      expect(site.all_h2.size).to be >=0
      expect(site.all_h2).to be_an_instance_of Array
    end
  end
  describe '#robot_txt_allowed?(url)' do
    it 'check page with robottxt file' do
      expect(subject.robot_txt_allowed? 'http://savchuk.space'). to be
    end
  end
  describe '#add_page(url)' do
    it 'add page to site' do
      subject.add_page 'http://ya.ru'
      expect(subject.pages.size).to eq 2
    end
  end
  describe '#add_pages_for_scan!' do
    it 'add pages for scan to @pages_for_scan array' do

    end
  end
end
