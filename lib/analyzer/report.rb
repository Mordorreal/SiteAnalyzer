module SiteAnalyzer
  # Create report for site
  class Report
    attr_reader :site, :report
    def initialize(site_url, deep)
      @site_url = site_url
      @deep = deep
    end

    def start
      @site = Site.new(@site_url, @deep)
    end

    def make_and_show_report
      @report = {}
      @report[:title_more_then_70_symbols_on] = check_titles_text_less_than_70
      @report[:title_and_h1_have_doubles_on] = check_title_and_h1_for_doubles
      @report[:meta_description_more_than_200_on] = check_meta_description_less_then_200
      @report[:meta_keywords_tags_more_than_600_on] = check_meta_keywords_tags
      @report[:dont_have_h2_tags] = check_h2
      @report[:pages_size_with_url] = pages_size
      @report[:code_more_then_text_on] = code_more
      @report[:a_tags_list] = a_tag_array
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
      result = []
      @site.all_titles.each do |title|
      end
    end
  end
end
