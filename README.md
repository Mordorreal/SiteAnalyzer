<a href="https://github.com/Mordorreal/SiteAnalyzer"><b>Site Analyzer</b><a/>

Site Analyzer is a Ruby SEO site analizer gem.

Site Analyzer check site and make report for you.

<b>Requirements</b>

    Ruby >= 1.8.7
    Nokogiri >= 1.6.6.2
    Addressable >= 2.3.8
    Robotstxt >= 0.5.4
    Terminal-table >= 1.5.2

<b>Installation</b>

This library is intended to be installed via the RubyGems system.

$ gem install site_analyzer

You might need administrator privileges on your system to install it.

<b>How to use</b>

require 'site_analyzer'<br>
                                   <b>Site</b><b>Number of pages</b><b>Use robot.txt</b><b>Output to console</b>
SiteAnalyzer::Report.create 'http://savchuk.space',      10,                 true,                true 
Return hash with report.
<b>Author</b>

Denis Savchuk <a href="mailto:denis@savchuk.space"><denis@savchuk.space></a>

<b>Resources</b>

   Homepage  <a href="savchuk.space" target="_blank">savchuk.space</a>

<b>License</b>

Copyright © 2015 Denis Savchuk, SiteAnalyzer is released under the MIT license.
