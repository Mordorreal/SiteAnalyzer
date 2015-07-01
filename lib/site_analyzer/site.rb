module SiteAnalyzer
  require 'robotstxt'
  # Create site object with all scans
  class Site
    attr_reader :main_url, :pages, :domain
    def initialize(url, max_pages = 10, use_robot_txt = false)
      @main_url = url
      @pages = {}
      @max_pages = max_pages
      @domain = Addressable::URI.parse(url).host
      @use_robot_txt = use_robot_txt
      all_site_pages(url)
    end

    def robot_txt_allowed?(url)
      Robotstxt.allowed?(url, '*') rescue nil
    end

    def all_site_pages(url = main_url)
      return nil if @max_pages < 0 || redirection_off(url).nil? || (robot_txt_allowed?(url) if @use_robot_txt)
      @max_pages -= 1
      page = Page.new url
      urls_array = urls_of_pages(page)
      if urls_array.size > 0
        urls_array.each do |url_in|
          all_site_pages(url_in) unless @pages.key?(url_in) || url_in.nil?
        end
      end
      @pages[url] = page
    end

    def urls_of_pages(page)
      page.home_a.uniq.delete_if { |url| url.start_with?('mailto') }
    end

    def redirection_off(url)
      timeout(10) { open(url).base_uri.to_s }
    rescue
      nil
    end

    def all_titles
      result = []
      @pages.each_pair do |url, page|
        result << [url, page.titles]
      end
      result
    end

    def all_descriptions
      result = []
      @pages.each_pair do |url, page|
        result << [url, page.all_meta_description_content]
      end
      result
    end

    def all_h2
      result = []
      @pages.each_pair do |url, page|
        result << [url, page.h2]
      end
      result
    end
  end
end