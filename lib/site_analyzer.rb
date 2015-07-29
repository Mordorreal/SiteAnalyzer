# Main class for program
module SiteAnalyzer
  require 'stringex_lite'
  %w(open-uri-patching page report site version).each do |file|
    require "site_analyzer/#{file}"
  end
  Stringex::Localization.default_locale = :en
end
