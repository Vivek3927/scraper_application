require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Companies API', type: :request do
  describe 'GET /api/v1/companies' do
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
      get '/api/v1/companies', params: { n: 10, filters: filters }

      expect(response).to have_http_status(:success)
      expect(response.header['Content-Type']).to include 'text/csv'
    end
  end
end
