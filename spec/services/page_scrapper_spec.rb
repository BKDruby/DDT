# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageScrapper do
  let(:url) { 'https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm' }
  let(:fields) { { "price": '.price-box__price', "rating_count": '.ratingCount', "rating_value": '.ratingValue' } }
  let(:html_response) { File.read('spec/support/files/response.html') }

  subject { described_class.new(url) }

  before do
    allow_any_instance_of(described_class).to receive(:scrape_html).and_return(true)
    allow_any_instance_of(described_class).to receive(:html).and_return(html_response)
  end

  describe '#initialize' do
    context 'if page not cached' do
      it 'should scrape page' do
        expect_any_instance_of(described_class).to receive(:scrape_html)
        subject
      end

      it 'should create page in db' do
        expect { subject }.to change(Page, :count).from(0).to(1)
      end
    end

    context 'when page with given url created less than a day ago' do
      let!(:page) { Page.create_from_html!(url:, html: html_response) }

      it 'should not scrape page' do
        expect_any_instance_of(described_class).to_not receive(:scrape_html)

        subject
      end

      it 'should not create new page' do
        expect { subject }.to_not change(Page, :count)
      end
    end
  end

  describe '#selector_text' do
    let!(:page) { Page.create_from_html!(url:, html: html_response) }

    context 'when selector exists on page' do
      it 'should return contained text' do
        expected_text = Nokogiri::HTML(html_response).css(fields[:price]).text
        expect(subject.selector_text(fields[:price])).to eq(expected_text)
      end
    end

    context 'when selector missing on page' do
      it 'should return blank string' do
        expect(subject.selector_text('.nonexistent-selector')).to eq('')
      end
    end
  end

  describe '#meta_tag_content' do
    let!(:page) { Page.create_from_html!(url:, html: html_response) }

    context 'when meta tag exists on page' do
      it 'should return tag content' do
        expected_content = Nokogiri::HTML(html_response).at("meta[name='description']").attr('content')
        expect(subject.meta_tag_content('description')).to eq(expected_content)
      end
    end

    context 'when meta tag missing on page' do
      it 'should return nil' do
        expect(subject.meta_tag_content('nonexistent-meta')).to be_nil
      end
    end
  end
end
