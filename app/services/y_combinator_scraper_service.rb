require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'csv'

class YCombinatorScraperService
  BASE_URL = 'https://www.ycombinator.com/companies'
  BATCHES = ['W21', 'S21']  # Add more batches as needed

  def initialize(n, filters)
    @n = n
    @filters = filters
  end

  def scrape_and_save
    companies = []
    page = 1
    while companies.size < @n
      url = "#{BASE_URL}?page=#{page}"
      response = HTTParty.get(url)
      break unless response.success?

      doc = Nokogiri::HTML(response.body)
      companies += parse_companies(doc)
      page += 1
    end

    save_to_csv(companies.first(@n))
  end

  private

  def parse_companies(doc)
    companies = []
    company_cards = doc.css('.companies-list .company')
    company_cards.each do |card|
      company = {}
      company[:name] = card.at_css('.company-name')&.text.strip
      company[:location] = card.at_css('.company-location')&.text.strip
      company[:short_description] = card.at_css('.company-short-description')&.text.strip
      company[:yc_batch] = parse_batch(card)
      companies << company
    end

    companies
  end

  def parse_batch(card)
    batch_info = card.at_css('.company-batch')&.text.strip
    batch_info&.match(/\b(W\d+)\b/)&.captures&.first
  end

  def save_to_csv(companies)
    CSV.open('yc_companies.csv', 'w') do |csv|
      csv << %w[Name Location Short_Description YC_Batch Website Founders LinkedIn_URLs]

      companies.each do |company|
        csv << [
          company[:name],
          company[:location],
          company[:short_description],
          company[:yc_batch],
          '',  # Placeholder for Website (not scraped in this example)
          '',  # Placeholder for Founders (not scraped in this example)
          ''   # Placeholder for LinkedIn URLs (not scraped in this example)
        ]
      end
    end
  end
end
