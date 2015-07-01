module SiteAnalyzer
  # Create report for site
  class Report
    attr_reader :site, :report
    def initialize(site_url, deep)
      @site_url = site_url
      @deep = deep
      @site = Site.new(@site_url, @deep)
    end

    def make_report
      @report = {}
      @report[:title_more_then_70_symbols] = check_titles_text_less_than_70
      @report[:title_and_h1_have_doubles] = check_title_and_h1_for_doubles
      @report[:meta_description_more_than_200] = check_meta_description_less_then_200
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
      puts "=======================Report for #{@site_url} with #{@deep} pages deep======================="
      @report.each_pair do |key, value|
        puts "=====================================#{key}====================================="
        puts value
        puts '===================================================================================================='
      end
    end

    def check_titles_text_less_than_70
      result = []
      @site.pages.each_pair do |url, page|
        result << url unless page.title_good?
      end
      result
    end

    def check_title_and_h1_for_doubles
      result = []
      @site.pages.each_pair do |url, page|
        result << url unless page.title_and_h1_good?
      end
      result
    end

    def check_meta_description_less_then_200
      result = []
      @site.pages.each_pair do |url, page|
        result << url unless page.metadescription_good?
      end
      result
    end

    def check_meta_keywords_tags
      result = []
      @site.pages.each_pair do |url, page|
        result << url unless page.keywords_good?
      end
      result
    end

    def check_h2
      result = []
      @site.pages.each_pair do |url, page|
        result << url unless page.h2?
      end
      result
    end

    def pages_size
      result = []
      @site.pages.each_pair do |url, page|
        result << [url, page.page_text_size]
      end
      result
    end

    def code_more
      result = []
      @site.pages.each_pair do |url, page|
        result << url unless page.code_less?
      end
      result
    end

    def a_tag_array
      result = []
      @site.pages.each_pair do |home_page_of_url, page|
        page.all_a_tags.each do |link|
          result << [home_page_of_url, link[0], link[1], link[2]]
        end
      end
      result
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

    def bad_url
      result = []
      a_tag_array.each do |url|
        result << url if url[1].include? '?meta='
      end
      result
    end

    def h2_doubles
      find_doubles(@site.all_h2)
    end

    def not_uniq_words_in_h2
      find_not_uniq_words @site.all_h2
    end

    # in_array must be [[url_of_page, words_in_string_with_space],[next, same_element]]
    def find_not_uniq_words(in_array)
      all_words = []
      counter = {}
      result = []
      in_array.each do |url_desc_cont|
        url_desc_cont[0][1].scan(/\w+/).each do |word|
          all_words << word
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
      result
    end
    # in_array must be [[url_of_page, words_in_string_with_space],[next, same_element]]
    def find_doubles(in_array)
      result = []
      find_not_uniq_words(in_array).each do |not_uniq_word|
        in_array.each do |url_desc_cont|
          result << url_desc_cont if url_desc_cont[0][1].include? not_uniq_word
        end
      end
      result
    end
  end
end
