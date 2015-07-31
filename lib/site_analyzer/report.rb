require 'terminal-table'
require 'uri'

module SiteAnalyzer
  # Create report for site
  class Report
    attr_reader :site, :report
    def initialize(site_url, max_pages = 10, use_robot = false)
      @site_domain = site_url
      @max_pages = max_pages
      @use_robot = use_robot
      @site = Site.new(@site_domain, @max_pages, @use_robot)
    end
    # Entry point for gem. Create and show report. return array, show in console if select
    def self.create(options)
      options[:robot] = false if options[:robot] == 'false'
      options[:console] = false if options[:console] == 'false'
      rep = Report.new options[:site].to_s.strip, options[:pages].to_i, options[:robot]
      rep.make_report
      rep.to_s if options[:console]
      rep.report
    end

    def make_report
      @report = {}
      @report[:title_more_then_70_symbols] = check_titles_text_less_than_70
      @report[:title_and_h1_have_doubles] = check_title_and_h1_for_doubles
      @report[:meta_description_more_than_200] = check_meta_description
      @report[:meta_keywords_tags_more_than_600] = check_meta_keywords_tags
      @report[:dont_have_h2_tags] = check_h2
      @report[:pages_size_with_url] = pages_size
      @report[:code_more_then_text_on] = code_more
      @report[:a_tags_list] = a_tag_array
      @report[:title_doubles] = title_doubles
      @report[:meta_description_doubles] = meta_description_doubles
      @report[:bad_url] = bad_url
      @report[:h2_doubles] = h2_doubles
      @report
    end

    def to_s
      return 'Report is empty' if @report.nil? || @report.empty?
      header = Terminal::Table.new title: "Report for #{@site_domain} with #{@max_pages} pages and robot.txt check is #{@use_robot}"
      puts header
      @report.each_pair do |key, value|
        rows = []
        value = ['Too many for console report'] if key == :a_tags_list
        value.each do |r|
          r = [r] if r.class == String
          rows << r
        end
        table = Terminal::Table.new title: key, rows: rows
        puts table
      end
    end

    def check_titles_text_less_than_70
      result = []
      @site.pages.each do |page|
        result << page.page_url unless page.title_good
      end
      result
    end

    def check_title_and_h1_for_doubles
      result = []
      @site.pages.each do |page|
        result << page.page_url unless page.title_and_h1_good
      end
      result
    end

    def check_meta_description
      result = []
      @site.pages.each do |page|
        result << page.page_url unless page.meta_description_good
      end
      result
    end

    def check_meta_keywords_tags
      result = []
      @site.pages.each do |page|
        result << page.page_url unless page.meta_keywords
      end
      result
    end

    def check_h2
      result = []
      @site.pages.each do |page|
        result << page.page_url unless page.have_h2
      end
      result
    end

    def pages_size
      result = []
      @site.pages.each do |page|
        result << [page.page_url , page.page_text_size]
      end
      result
    end

    def code_more
      result = []
      @site.pages.each do |page|
        result << page.page_url unless page.code_less
      end
      result
    end

    def a_tag_array
      @site.all_a
    end

    def bad_url
      @site.bad_urls
    end

    def title_doubles
      find_doubles @site.all_titles
    end

    def not_uniq_words_in_meta
      find_not_uniq_words @site.all_descriptions
    end

    def meta_description_doubles
      find_doubles @site.all_descriptions
    end

    def h2_doubles
      find_doubles @site.all_h2
    end

    def not_uniq_words_in_h2
      find_not_uniq_words @site.all_h2
    end

    # in_array must be [[url_of_page, words_in_string_with_space],[next, same_element]]
    def find_not_uniq_words(in_array)
      all_words = []
      counter = {}
      result = []
      in_array.compact.each do |url_desc_cont|
        if url_desc_cont[1][0]
          url_desc_cont[1][0].scan(/\w+/).each do |word|
            all_words << word
          end
        end
      end
      all_words.each do |word|
        if counter[word]
          counter[word] += 1
        else
          counter[word] = 1
        end
      end
      counter.each_pair do |word, number|
        result << word if number > 1
      end
      result.uniq
    end
    # in_array must be [[url_of_page, words_in_string_with_space],[next, same_element]]
    def find_doubles(in_array)
      result = []
      find_not_uniq_words(in_array).each do |not_uniq_word|
        in_array.each do |url_desc_cont|
          result << url_desc_cont if url_desc_cont[1][0] && url_desc_cont[1][0].include?(not_uniq_word)
        end
      end
      result
    end
  end
end
