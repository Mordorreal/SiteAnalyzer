# Tests of Report class
require 'spec_helper'
require 'site_analyzer'

RSpec.describe SiteAnalyzer::Report do
  subject(:subject) { SiteAnalyzer::Report.new('http://savchuk.space', 10, false) }
  describe '#make_report' do
    it 'run all metods and generate report' do
      subject.make_report
      expect(subject.report).to be
      expect(subject.report.size).to be > 0
    end
  end
  describe '#to_s' do
    it 'generate report output in console' do
      subject.make_report
      expect(subject.to_s).to be
    end
  end
  describe 'robottxt gem test' do
    let(:subject) { SiteAnalyzer::Report.new('http://nash-farfor.ru', 10, true) }
    it 'generate report without pages with restriction' do
      subject.make_report
      expect(subject.to_s).to be
    end
  end
  describe '#check_titles_text_less_than_70' do
    it 'check all titles on all pages and return array with bad pages url' do
      expect(subject.check_titles_text_less_than_70).to be
    end
  end
  describe '#check_title_and_h1_for_doubles' do
    it 'on page and return array with bad pages url' do
      expect(subject.check_title_and_h1_for_doubles).to be
    end
  end
  describe '#check_meta_description_less_then_200' do
    it 'and return array with bad pages url' do
      expect(subject.check_meta_description).to be
    end
  end
  describe '#check_meta_keywords_tags' do
    it 'that all words uniq and less than 600 and return array with bad pages' do
      expect(subject.check_meta_keywords_tags).to be
    end
  end
  describe '#check_h2' do
    it 'that it persist on page and return array of bad pages' do
      expect(subject.check_h2).to be
    end
  end
  describe '#pages_size' do
    it 'return array with url and size of pages' do
      expect(subject.pages_size.size).to be > 0
    end
  end
  describe '#code_more' do
    it 'return array with url of pages where code more then text' do
      expect(subject.code_more).to be
    end
  end
  describe '#a_tag_array' do
    it 'return array [home_page_of_url, href, target, rel]' do
      expect(subject.a_tag_array.size).to be > 0
    end
  end
  describe '#title_doubles' do
    it 'return array of pages where titles double' do
      expect(subject.title_doubles).to be
      expect(subject.title_doubles.size).to be >= 0
    end
  end
  describe '#not_uniq_words_in_meta' do
    it 'return array with not uniq word in meta tag description' do
      expect(subject.not_uniq_words_in_meta).to be
      expect(subject.not_uniq_words_in_meta.size).to be >= 0
    end
  end
  describe '#meta_description_doubles' do
    it 'return array of pages where description have doubles' do
      expect(subject.meta_description_doubles).to be_an_instance_of Array
    end
  end
  describe '#bad_url' do
    it 'find bad url and return array of it with page url' do
      mail = SiteAnalyzer::Report.new('http://www.placewoman.ru/', 50, false)
      expect(mail.bad_url.size).to be >= 0
      expect(mail.bad_url).to be_an_instance_of Array
    end
  end
  describe '#h2_doubles' do
    it 'return array of pages if h2 doubles' do
      expect(subject.h2_doubles.size).to be >= 0
      expect(subject.h2_doubles).to be_an_instance_of Array
    end
  end
  describe '#not_uniq_words_in_h2' do
    it 'return array of words' do
      expect(subject.not_uniq_words_in_h2.size).to be >= 0
      expect(subject.not_uniq_words_in_h2).to be_an_instance_of Array
    end
  end
  describe '#find_not_uniq_words(in_array)' do
    let(:arr) { [['aport.ru', 'good wrong bad'], ['mail.ru', 'hi privet'], ['mail.ru/123', 'privet']] }
    it 'find not uniq words in array of in_array must be [[url_of_page, words_in_string_with_space],[next, same_element]]' do
      expect(subject.find_not_uniq_words(arr).size).to be >= 0
    end
  end
  describe '#find_doubles(in_array)' do
    let(:arr) { [['aport.ru', 'good wrong bad'], ['mail.ru', 'hi privet'], ['mail.ru/123', 'privet']] }
    it 'find doubles in array and return array with page that have it' do
      expect(subject.find_doubles(arr).size).to be >= 0
      expect(subject.find_doubles(arr)).to be_an_instance_of Array
    end
  end
  describe '#bad_urls' do
    let(:subject) { SiteAnalyzer::Report.new('http://nash-farfor.ru', 10, true) }
    it 'return array with bad urls' do
      expect(subject.bad_url).to be
    end
  end
end
