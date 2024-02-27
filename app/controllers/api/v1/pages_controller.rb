module Api
  module V1
    class PagesController < ApiBaseController
      before_action :validate_params, only: :create

      def create
        render json: PageSerializer.new(page, params.require(:fields).permit!).as_json
      end

      private

      def validate_params
        errors = PageParamsValidator.new(params).call

        if errors.any?
          raise ArgumentError, errors
        end
      end

      def page
        @page ||= PageScrapper.new(params[:url])
      end
    end
  end
end
