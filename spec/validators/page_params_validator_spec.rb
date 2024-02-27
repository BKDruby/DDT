# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageParamsValidator do
  let(:params) { ActionController::Parameters.new(params_value) }

  subject { described_class.new(params).call }

  describe '#call' do
    context 'when fields not a hash' do
      let(:params_value) { { 'fields' => 'not_a_hash' } }

      it 'should return errors' do
        expect(subject).to include('fields should be a Hash')
      end
    end

    context 'when fields.meta not an array' do
      let(:params_value) { { 'fields' => { 'meta' => 'not_an_array' } } }

      it 'should return errors' do
        expect(subject).to include('fields.meta should be a Array')
      end
    end

    context 'when params valid but empty' do
      let(:params_value) { { 'fields' => { 'meta' => [] } } }

      it 'should return empty array' do
        expect(subject).to be_empty
      end
    end
  end
end
