# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PagesController, type: :controller do
  let(:url) { 'https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm' }
  let(:html_response) { File.read('spec/support/files/response.html') }

  before do
    allow_any_instance_of(PageScrapper).to receive(:scrape_html).and_return(true)
    allow_any_instance_of(PageScrapper).to receive(:html).and_return(html_response)
  end

  describe '#create' do
    context 'when request is valid' do
      let(:fields) { { "price": '.price-box__price', "rating_count": '.ratingCount', "rating_value": '.ratingValue' } }

      it 'returns fields and meta from page' do
        post :create, params: { url:, fields: }

        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response).to include('price', 'rating_count', 'rating_value')
        expect(json_response['price']).to eq(Nokogiri::HTML(html_response).css(fields[:price]).text)
        expect(json_response['rating_count']).to eq(Nokogiri::HTML(html_response).css(fields[:rating_count]).text)
        expect(json_response['rating_value']).to eq(Nokogiri::HTML(html_response).css(fields[:rating_value]).text)
      end
    end

    context 'when request is invalid' do
      let(:fields) { ["price": '.price-box__price'] }

      it 'returns error' do
        post :create, params: { url:, fields: }

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include('fields should be a Hash')
      end
    end
  end
end
