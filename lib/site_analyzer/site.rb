module SiteAnalyzer
  require 'robotstxt'
  require 'open-uri'
  require 'timeout'
  # Create site object with all scans
  class Site
    attr_reader :main_url, :pages, :domain, :pages_for_scan, :max_pages, :scanned_pages
    def initialize(url, max_pages = 10, use_robot_txt = false)
      Stringex::Localization.default_locale = :en
      @main_url = url
      @pages = []
      @use_robot_txt = use_robot_txt
      @scanned_pages = []
      @pages_for_scan = []
      @max_pages = max_pages - 1
      @pages << Page.new(convert_to_valid(@main_url))
      scan_site!
    end

    def robot_txt_allowed?(url)
      if @use_robot_txt
        Robotstxt.allowed?(url, '*') rescue nil
      else
        true
      end
    end

    def scan_site!
      add_pages_for_scan!
      while @pages_for_scan.size > 0
        page = convert_to_valid @pages_for_scan.pop
        if page
          @max_pages -= 1
          add_page convert_to_valid(page)
          return if @max_pages <= 0
          add_pages_for_scan!
          optimize_scan!
        end
      end
    end

    def add_pages_for_scan!
      @pages_for_scan = []
      @bad_pages = []
      @pages.each do |page|
        @bad_pages << page.page_url unless page.page
        if page.page
          page.home_a.each do |link|
            @pages_for_scan << link unless link.nil? || link.start_with?('mailto:') || link.start_with?('skype:') || link.end_with?('.jpg')
          end
        end
      end
    end

    def add_page(url)
      unless robot_txt_allowed?(url)
        @scanned_pages << url
        return nil
      end
      page = Page.new(url)
      @pages << page
      @scanned_pages << url
    end

    def all_titles
      result = []
      @pages.each do |page|
        if page.page
          result << [page.page_url, page.titles]
        end
      end
      result
    end

    def all_descriptions
      result = []
      @pages.each do |page|
        if page.page
          result << [page.page_url, page.all_meta_description_content]
        end
      end
      result
    end

    def all_h2
      result = []
      @pages.each do |page|
        unless page.page
          result << [page.page_url, page.h2]
        end
      end
      result
    end

    def all_a
      result = []
      @pages.each do |page|
        if page.page
          page.all_a_tags.compact.each do |tag|
            tag[0] = '-' unless tag[0]
            tag[1] = '-' unless tag[1]
            tag[2] = '-' unless tag[2]
            result << [page.page_url, tag[0], tag[1], tag[2]]
          end
        end
      end
      result.compact
    end

    def pages_url
      result = []
      @pages.each do |page|
         result << page.page_url if page.page
      end
      result
    end

    def optimize_scan!
      @pages_for_scan.uniq.compact!
      @scanned_pages.uniq.compact!
      @pages_for_scan = @pages_for_scan - @scanned_pages
    end

    def convert_to_valid(url)
      link = URI(url.to_ascii)
      main_page = URI(@main_url.to_ascii)
      if link && link.scheme && link.scheme.empty?
        link.scheme = main_page.scheme
      elsif link.nil?
        return nil
      end
      if link.scheme == 'http' || link.scheme == 'https'
        request = link.scheme + '://' + link.host
        if link.request_uri
          request += link.request_uri
        end
      else
        request = nil
      end
      request
    end
  end
end
