<a href="https://github.com/Mordorreal/SiteAnalyzer"><b>Site Analyzer</b><a/>

Site Analyzer is a Ruby SEO site analizer gem.

Site Analyzer check site and make report for you.

<b>Requirements</b>

    Ruby >= 1.8.7
    Nokogiri >= 1.6.6.2
    Addressable >= 2.3.8
    Robotstxt >= 0.5.4

<b>Installation</b>

This library is intended to be installed via the RubyGems system.

$ gem install site_analyzer

You might need administrator privileges on your system to install it.

<b>How to use</b>

require 'site_analyzer'
SiteAnalyzer.add_site 'http://savchuk.space' # add site to list
SiteAnalyzer.start # start creating of reports
SiteAnalyzer.show_all_reports # show all reports in console
SiteAnalyzer.show_report 5 # show report number 5 starting from 1 in console
SiteAnalyzer.report[0].report # return Hash report

<b>Author</b>

Denis Savchuk <a href="mailto:denis@savchuk.space"><denis@savchuk.space></a>

<b>Resources</b>

   Homepage  <a href="savchuk.space" target="_blank">savchuk.space</a>

<b>License</b>

Copyright © 2015 Denis Savchuk, SiteAnalyzer is released under the MIT license.