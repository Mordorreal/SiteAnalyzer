# Main class for program
module SiteAnalyzer
  %w(page site report version open-uri-patching).each do |file|
    require "site_analyzer/#{file}"
  end
  Stringex::Localization.default_locale = :en
end
