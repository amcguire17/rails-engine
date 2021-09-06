class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, numericality: true

  def self.min_price(min_params)
    where("unit_price > ?", min_params).order(:name).first
  end
  def self.max_price(max_params)
    where("unit_price < ?", max_params).order(:name).first
  end
end
