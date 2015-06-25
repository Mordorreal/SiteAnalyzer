# Tests of Report class
require 'spec_helper'
require 'analyzer/report'
RSpec.describe SiteAnalyzer::Report do
  before(:each) do
    @report_savchuk = SiteAnalyzer::Report.new('https://mail.ru', 10)
    @report_savchuk.start
  end

  describe '#start' do
    it 'parse site with provided deep' do
      expect(@report_savchuk.site).not_to eq nil
    end
  end
  describe '#make_and_show_report' do
    it 'run all metods and generate report' do
      @report_savchuk.make_and_show_report
      expect(@report_savchuk.report).not_to eq nil
    end
  end
  describe '#check_titles_text_less_than_70' do
    it 'check all titles on all pages and return array with bad pages url' do
      expect(@report_savchuk.check_titles_text_less_than_70).not_to eq nil
    end
  end
  describe '#check_title_and_h1_for_doubles' do
    it 'on page and return array with bad pages url' do
      expect(@report_savchuk.check_title_and_h1_for_doubles).not_to eq nil
    end
  end
  describe '#check_meta_description_less_then_200' do
    it 'and return array with bad pages url' do
      expect(@report_savchuk.check_meta_description_less_then_200).not_to eq nil
    end
  end
  describe '#check_meta_keywords_tags' do
    it 'that all words uniq and less than 600 and return array with bad pages' do
      expect(@report_savchuk.check_meta_keywords_tags).not_to eq nil
    end
  end
  describe '#check_h2' do
    it 'that it persist on page and return array of bad pages' do
      expect(@report_savchuk.check_h2).not_to eq nil
    end
  end
  describe '#pages_size' do
    it 'return array with url and size of pages' do
      expect(@report_savchuk.pages_size.size).to be > 0
    end
  end
  describe '#code_more' do
    it 'return array with url of pages where code more then text' do
      expect(@report_savchuk.code_more.size).to be > 0
    end
  end
  describe '#a_tag_array' do
    it 'return array [home_page_of_url, href, target, rel]' do
      expect(@report_savchuk.a_tag_array.size).to be > 0
    end
  end
  describe '#title_doubles' do
    it ' return array of page where titles double' do
      pending 'Need to implement method'
      expect(@report_savchuk.title_doubles).not_to eq nil
    end
  end
end
