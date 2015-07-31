module SiteAnalyzer
  require 'robotstxt'
  require 'open-uri'
  require 'timeout'
  # Create site object with all scans
  class Site
    attr_reader :main_url, :pages, :pages_for_scan, :max_pages, :scanned_pages
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
    # check if page blocked by robot txt
    def robot_txt_allowed?(url)
      if @use_robot_txt
        Robotstxt.allowed?(url, '*') rescue nil
      else
        true
      end
    end
    # scan pages: add page to scan, if still can scan do it, add new pages for scan from it and optimize massive of links
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
    # add pages for scan array, also add bad pages to bad_pages array
    def add_pages_for_scan!
      @pages_for_scan = []
      @bad_pages = []
      @pages.each do |page|
        @bad_pages << page.page_url unless page.page_a_tags
        if page.page_a_tags
          page.home_a.each do |link|
            @pages_for_scan << link
          end
        end
      end
    end
    # create Page and add to to site
    def add_page(url)
      unless robot_txt_allowed?(url)
        @scanned_pages << url
        return nil
      end
      page = Page.new(url)
      @pages << page
      @scanned_pages << url
    end
    # get all titles on site and return array of them
    def all_titles
      result = []
      @pages.each do |page|
        if page.page_a_tags
          result << [page.page_url, page.all_titles]
        end
      end
      result
    end
    # get all meta description tags content and return it as array
    def all_descriptions
      result = []
      @pages.each do |page|
        if page.page_a_tags
          result << [page.page_url, page.meta_desc_content]
        end
      end
      result
    end
    # get all h2 tags and return array of it
    def all_h2
      result = []
      @pages.each do |page|
        unless page.page_a_tags
          result << [page.page_url, page.h2_text]
        end
      end
      result
    end
    # get all a tags and return array of it
    def all_a
      result = []
      @pages.each do |page|
        if page.page_a_tags
          page.page_a_tags.compact.each do |tag|
            tag[0] = '-' unless tag[0]
            tag[1] = '-' unless tag[1]
            tag[2] = '-' unless tag[2]
            result << [page.page_url, tag[0], tag[1], tag[2]]
          end
        end
      end
      result.compact
    end
    # get all non HLU url and return array
    def bad_urls
      result = []
      @pages.each do |page|
        result << page.hlu
      end
      result.compact!
    end
    # get new array pages for scan and compact it
    def optimize_scan!
      @pages_for_scan = @pages_for_scan.compact.uniq
      @scanned_pages = @scanned_pages.compact.uniq
      @pages_for_scan = @pages_for_scan - @scanned_pages
    end
    # check url and try to convert it to valid, remove .jpg links, add scheme to url
    def convert_to_valid(url)
      return nil if url =~ /.jpg$/i
      url.insert(0, @main_url.first(5)) if url.start_with? '//'
      link = URI(url)
      main_page = URI(@main_url)
      if link && link.scheme && link.scheme.empty?
        link.scheme = main_page.scheme
      elsif link.nil?
        return nil
      end
      if link.scheme =~ /^http/
        request = link.to_s
      else
        request = nil
      end
      request
    rescue
      link
    end
  end
end
