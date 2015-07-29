# Tests of Site class
require 'spec_helper'
require_relative '../../../lib/site_analyzer/site'

RSpec.describe SiteAnalyzer::Site do
  subject(:site) { SiteAnalyzer::Site.new initial_values, 10, false }
  let(:initial_values) { 'http://www.placewoman.ru' }

  describe '#all_titles' do
    let(:initial_values) { 'http://mail.ru'}
    it 'return array [page_url, title_tag_text]' do
      expect(subject.all_titles.size).to be > 0
    end
  end
  describe '#all_descriptions' do
    it 'return array [page_url, [description_content]]' do
      expect(subject.all_descriptions.size).to be > 0
    end
  end
  describe '#all_h2' do
    it 'return array [page_url, [h2_text]]' do
      expect(subject.all_h2).to be
      expect(subject.all_h2.size).to be >=0
      expect(subject.all_h2).to be_an_instance_of Array
    end
  end
  describe '#robot_txt_allowed?(url)' do
    it 'check page with robottxt file' do
      expect(subject.robot_txt_allowed? 'http://savchuk.space'). to be
    end
  end
  describe '#add_page(url)' do
    it 'add page to site' do
      site = SiteAnalyzer::Site.new 'http://yandex.ru', 10, false
      expect(site.pages.size).to eq 10
    end
  end
  describe '#add_pages_for_scan!' do
    it 'add pages for scan to @pages_for_scan array' do
      subject.add_page 'https://mail.ru'
      subject.add_pages_for_scan!
      expect(subject.pages_for_scan.size).to be > 1
    end
  end
  describe '#scan_site!' do
    it 'using @pages_for_scan scan this pages' do
      subject.add_page 'http://www.placewoman.ru/'
      subject.scan_site!
      expect(subject.max_pages).to be < 0
      expect(subject.pages.size).to be >= 10
    end
  end
  describe '#pages_url' do
    it 'return array of pages url' do
      expect(subject.pages_url.size).to be > 0
    end
  end
  describe '#optimize_scan!' do
    it 'optimize search arrays' do
      subject.optimize_scan!
      expect(subject.pages_for_scan).to be
      expect(subject.scanned_pages).to be
    end
  end
end
