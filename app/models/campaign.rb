class Campaign < ActiveRecord::Base

  # This integrate FriendlyId within our model
  # we're using the `name` to generate the `slug`
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  validates :name, presence: true, uniqueness: true
  validates :goal, presence: true, numericality: {greater_than: 10}

  belongs_to :user
  has_many :pledges, dependent: :destroy

  # This is CarrierWave config:
  # :image is the field in the database that will store the image name
  # ImageUploader is the uplaoder class we created in /app/uploaders/image_uploader.rb
  mount_uploader :image, ImageUploader

  # default `to_param` method
  # def to_param
  #   id
  # end

  # def to_param
  #   # for `to_param` to work there must be and id with non-numerical character
  #   # right after. It's good to call a method like `parameterize` which makes it
  #   # url friendly. For instance, `parameterize` replaces spaces with `-`s
  #   "#{id}-#{name}".parameterize
  # end
end
