# Tests of Site class
require 'spec_helper'
require 'analyzer/site'
RSpec.describe SiteAnalyzer::Site do
  subject(:site) { SiteAnalyzer::Site.new initial_values }
  let(:initial_values) { 'https://mail.ru' }

  describe '#all_site_pages(url)' do
    before do
      site.all_site_pages
    end
    it 'reqursively get all pages of site' do
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
end
