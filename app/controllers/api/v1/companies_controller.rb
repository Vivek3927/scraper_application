class Api::V1::CompaniesController < ApplicationController

  def index
    n = params[:n].to_i
    filters = params[:filters].permit!.to_h || {}
    scraper = YCombinatorScraperService.new(n, filters)
    scraper.scrape_and_save

    render json: { message: "#{n} companies scraped and saved to CSV." }
  end
end
