class Campaign < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :goal, presence: true, numericality: {greater_than: 10}

  belongs_to :user
  has_many :pledges, dependent: :destroy
end
