require 'spec_helper'
require 'analyzer'

RSpec.describe SiteAnalyzer do
  describe '.new' do
    it 'singleton pattern. Create only one instance of program' do
      program1 = SiteAnalyzer.new
      program2 = SiteAnalyzer.new
      expect(program1).to eq program2
    end
  end
end
