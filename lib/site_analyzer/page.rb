module SiteAnalyzer
  # Get site page and provide metods for analyse
  require 'nokogiri'
  require 'addressable/uri'
  require 'timeout'
  class Page
    attr_reader :page_url, :titles, :page
    def initialize(url)
      @page_url = url
      @page = get_page(url)
      @site_url = get_domain url
      @titles = all_titles
    end

    def to_s
      "Page url: #{@page_url} Site url: #{@site_url}"
    end

    def get_page(url)
      begin
        timeout(30) { Nokogiri::HTML(open(url)) }
      rescue Timeout::Error, EOFError, OpenURI::HTTPError
        return nil
      end
    end

    def get_domain(url)
      timeout(30) { Addressable::URI.parse(url).host } rescue nil
    end

    def title_good?
      @page.css('title').size == 1 && @page.css('title').text.size < 70 if @page
    end
    # true if title and h1 have no dublicates
    def title_and_h1_good?
      if @page
        arr = []
        @page.css('h1').each { |node| arr << node.text }
        @page.css('title').size == 1 && arr.uniq.size == arr.size
      end
    end
    # true if metadescription less then 200 symbols
    def metadescription_good?
      if @page
        tags = @page.css("meta[name='description']")
        return false if tags.size == 0
        tags.each do |t|
          unless t['value'].nil?
            return false if t['content'].size == 0 || t['content'].size > 200
          end
        end
        true
      end
    end
    # true if keywords less then 600 symbols
    def keywords_good?
      if @page
        tags = @page.css("meta[name='keywords']")
        return false if tags.size == 0
        tags.each do |t|
          unless t['value'].nil?
            return false if t['content'].size == 0 || t['content'].size > 600
          end
        end
        true
      end
    end
    # true if code less then text
    def code_less?
      if @page
        sum = 0
        page_text = @page.text.size
        @page.css('script').each do |tag|
          sum += tag.text.size
        end
        sum < page_text / 2
      end
    end

    def collect_metadates
      @page.css('meta') if @page
    end

    def metadates_good?
      if @page
        meta_tags = collect_metadates
        return false if @page.css('title').size > 1 || meta_tags.nil?
        node_names = []
        meta_tags.each { |node| node_names << node['name'] }
        return false if node_names.compact!.size < 1
        node_names.uniq.size == node_names.size
      end
    end
    # return hash with all titles, h1 and h2
    def all_titles_h1_h2
      if @page
        out = []
        out << @page.css('title').text << { @page_url => @page.css('h1').text }
        out << { @page_url => @page.css('h2').text }
      end
    end

    def home_a
      if @page
        home_a = []
        all_a_tags_href.each do |link|
          home_a << link if link.include? @site_url
        end
        home_a
      end
    end

    def remote_a
      if @page
        remote_a = []
        all_a_tags_href.uniq.each do |link|
          remote_a << link unless link.include? @site_url
        end
        remote_a
      end
    end

    def all_a_tags_href
      if @page
        tags = []
          @page.css('a').each do |node|
            tags << node['href']
          end
        tags.compact
      end
    end

    def wrong_a
      if @page
        wrong_a = []
        all_a_tags_href.each do |link|
          wrong_a << link if link.include? '?meta='
        end
        wrong_a
      end
    end

    def h2?
      @page.css('h2').size > 0 if @page
    end

    def page_text_size
      @page.text.size if @page
    end

    def all_a_tags
      if @page
        tags = []
        @page.css('a').each do |node|
          tags << [node['href'], node['target'], node['rel']]
        end
        tags.compact
      end
    end

    def all_titles
      if @page
        titles = []
        @page.css('title').each { |tag| titles << tag.text }
        titles
      end
    end

    def all_meta_description_content
      if @page
        tags = []
        @page.css("meta[name='description']").each do |t|
          tags << t['content']
        end
        tags
      end
    end

    def h2
      if @page
        h2s = []
        @page.css('h2').each { |tag| h2s << tag.text }
        h2s
      end
    end
  end
end
