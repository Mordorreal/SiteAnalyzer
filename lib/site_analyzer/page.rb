module SiteAnalyzer
  # Get site page and provide data for future analyse
  require 'nokogiri'
  require 'addressable/uri'
  require 'timeout'
  require 'stringex_lite'
  require 'open-uri'
  class Page
    attr_reader :page_url, :page_path, :site_domain,
                :all_titles, :title_good, :title_and_h1_good,
                :meta_description_good, :meta_keywords, :code_less,
                :meta_data, :meta_title_duplicates, :title_h1_h2,
                :have_h2, :page_text_size, :page_a_tags,
                :meta_desc_content, :h2_text, :hlu
    # create page object, fill date and clear don't needed elements
    def initialize(url)
      @page_url = url
      get_page(url)
      fill_data_field! if @page
      clear!
    end
    # to_s for report
    def to_s
      "Page url: #{@page_url} Site url: #{@site_domain}"
    end
    # get all home (that on this site) url on page
    def home_a
      if @page_a_tags
        home_a = []
        @page_a_tags.uniq.each do |link|
          uri = URI(link[0].to_ascii) rescue nil #TODO: write additional logic for link to image
          if uri && @site_domain
            home_a << link[0] if uri.host == @site_domain
          end
        end
        home_a
      end
    end
    # get all remote link on page
    def remote_a
      if @page_a_tags
        remote_a = []
        @page_a_tags.uniq.each do |link|
          uri = URI(link[0].to_ascii)
          if uri && @site_domain
            remote_a << link[0] unless uri.host == @site_domain
          end
        end
        remote_a
      end
    end

    private

    # fill Page instant with data for report
    def fill_data_field!
      @all_titles = titles
      @meta_data = collect_metadates
      @title_h1_h2 = all_titles_h1_h2
      @page_text_size = text_size
      @page_a_tags = all_a_tags
      @meta_desc_content = all_meta_description_content
      @h2_text = h2
      @hlu = bad_url
      @title_good = title_good?
      @title_and_h1_good = title_and_h1_good?
      @meta_description_good = metadescription_good?
      @meta_keywords = keywords_good?
      @code_less = code_less?
      @meta_title_duplicates = metadates_good?
      @have_h2 = h2?
    end
    # get page with open-uri, then parse it with Nokogiri. Get site domain and path from URI
    def get_page(url)
      begin
        timeout(30) do
          page = open(url)
          @site_domain = page.base_uri.host
          @page_path = page.base_uri.request_uri
          @page = Nokogiri::HTML(page)
        end
      rescue Timeout::Error, EOFError, OpenURI::HTTPError, Errno::ENOENT
        return nil
      end
    end
    # check that title is one and less then 70 symbols
    def title_good?
      @page.css('title').size == 1 && @page.css('title').text.size < 70 if @page
    end
    # true if title and h1 have no duplicates
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
    # true if code of page less then text on it
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
    # collect meta tags for future report
    def collect_metadates
      meta = []
      meta = @page.css('meta') if @page
      meta
    end
    # check meta and title tags duplicates
    def metadates_good?
      if @page
        return false if @all_titles.size > 1 || @meta_data.empty?
        node_names = []
        @meta_data.each { |node| node_names << node['name'] }
        node_names.compact!
        node_names.uniq.size == node_names.size unless node_names.nil? || node_names.size < 1
      end
    end
    # return hash with all titles, h1 and h2
    def all_titles_h1_h2
      if @page
        out = []
        out << @page.css('title').text << { @page_url => @page.css('h1').text }
        out << { @page_url => @page.css('h2').text }
        out
      end
    end
    # check if page have h2 tags
    def h2?
      @page.css('h2').size > 0 if @page
    end
    # return page size in symbols
    def text_size
      @page.text.size if @page
    end
    # get all a tags
    def all_a_tags
      if @page
        tags = []
        @page.css('a').each do |node|
          tags << [node['href'], node['target'], node['rel']]
        end
        tags.compact
      end
    end
    # return all page titles
    def titles
      if @page
        titles = []
        @page.css('title').each { |tag| titles << tag.text }
        titles
      end
    end
    # return all meta description content
    def all_meta_description_content
      if @page
        tags = []
        @page.css("meta[name='description']").each do |t|
          tags << t['content']
        end
        tags
      end
    end
    # return all h2 tags text
    def h2
      if @page
        h2s = []
        @page.css('h2').each { |tag| h2s << tag.text }
        h2s
      end
    end
    # check url of page that is must be HLU
    def bad_url
      @page_url if @page_path.size > 1 unless @page_path =~ /^[\w.\-\/]+$/i
    end
    # clear page from don't needed information
    def clear!
      @page = nil
    end
  end
end
