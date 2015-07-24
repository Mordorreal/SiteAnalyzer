module SiteAnalyzer
  # require 'log4r'
  require 'robotstxt'
  require 'open-uri'
  require 'timeout'
  # Create site object with all scans
  class Site
    # include Log4r
    attr_reader :main_url, :pages, :domain
    def initialize(url, max_pages = 10, use_robot_txt = false)
      @main_url = url
      @pages = []
      @max_pages = max_pages
      @domain = Addressable::URI.parse(url).host
      @use_robot_txt = use_robot_txt
      @scanned_pages = []
      @page_for_scan = []
      add_page url
      # logging!
    end

    # def logging!
    #   @log = Logger.new "Site:#{@main_url}"
    #   @log.outputters = FileOutputter.new('site', filename: "log/#{@domain}.log")
    #   @log.level = DEBUG
    # end

    def robot_txt_allowed?(url)
      if @use_robot_txt
        Robotstxt.allowed?(url, '*') rescue nil
      else
        true
      end
    end

    def start_scan
      while @page_for_scan.size > 0 || @max_pages > 0
        fill_page_for_scan
      end
    end

    def fill_page_for_scan
      add_pages_for_scan!
      while @page_for_scan.size > 0
        add_page @page_for_scan.pop
        return if @max_pages < 0
      end
    end

    def add_pages_for_scan!
      @page_for_scan = []
      @pages.each do |page|
        page.home_a.each do |link|
          @page_for_scan << link unless @scanned_pages.include?(link) || link.include?('mailto:')
        end
      end
      @page_for_scan.empty? if @page_for_scan.size == 0
    end

    def add_page(url)
      # @log.debug "#{Time.new} add page #{url} to site with option: allowed by robot? #{robot_txt_allowed?(url)}"
      return unless robot_txt_allowed?(url)
      page = Page.new(url)
      # @log.debug "#{Time.new} #{page.to_s}"
      # @log.debug "#{Time.new} page created and not nil #{!page.nil?}"
      @pages << page
      @max_pages -= 1
      @scanned_pages << url
    end

    def all_titles
      result = []
      @pages.each do |page|
        result << [page.page_url, page.titles]
      end
      result
    end

    def all_descriptions
      result = []
      @pages.each do |page|
        result << [page.page_url, page.all_meta_description_content]
      end
      result
    end

    def all_h2
      result = []
      @pages.each do |page|
        result << [page.page_url, page.h2]
      end
      result
    end
  end
end
