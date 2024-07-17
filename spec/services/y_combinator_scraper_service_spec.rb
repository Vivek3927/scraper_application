require 'rails_helper'
require 'nokogiri'
require 'httparty'
require 'webmock/rspec'

RSpec.describe YCombinatorScraperService do
  describe '#call' do
    let(:filters) do
      {
        batch: 'W21',
        industry: 'Healthcare',
        region: 'United States',
        tag: 'Top Companies',
        company_size: '1-10',
        is_hiring: true,
        nonprofit: false,
        black_founded: true,
        hispanic_latino_founded: false,
        women_founded: true
      }
    end
    let(:service) { described_class.new(10, filters) }

    before do
      stub_request(:get, /ycombinator.com/).to_return(
        status: 200,
        body: file_fixture('y_combinator_companies.html').read,
        headers: { 'Content-Type' => 'text/html' }
      )

      stub_request(:get, "https://www.ycombinator.com/companies/company-a").to_return(
        status: 200,
        body: file_fixture('company_details.html').read,
        headers: { 'Content-Type' => 'text/html' }
      )
    end

    it 'returns a CSV file' do
      csv_data = service.call
      expect(csv_data).to be_a(String)
      expect(csv_data).to include('Name,Location,Description,Batch,Website,Founders,LinkedIn_URLs')
    end
  end
end
