# Tests of Site class
require 'spec_helper'
require 'site_analyzer'
RSpec.describe SiteAnalyzer::Site do
  subject(:site) { SiteAnalyzer::Site.new initial_values, 10 }
  let(:initial_values) { 'http://yandex.ru' }

  describe '#all_site_pages(url)' do
    before do
      site.all_site_pages
    end
    it 'recursively get all pages of site' do
      expect(site.pages).not_to eq nil
    end
  end
  describe '#redirection_off(url)' do
    let(:initial_values) { 'http://mail.ru' }
    it 'return url after redirection' do
      expect(site.redirection_off(site.main_url)).to eq nil
    end
  end
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
end
