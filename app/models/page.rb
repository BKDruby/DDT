class Page < ApplicationRecord
  has_one_attached :html_file, dependent: :purge

  def self.create_from_html!(url:, html:)
    html_file = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(html),
      filename: "page#{Time.now.to_i}.html",
      content_type: 'text/html'
    )

    create!(url:, html_file:)
  end
end
