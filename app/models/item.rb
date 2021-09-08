class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, numericality: true

  def self.min_price(min_params)
    where("unit_price > ?", min_params).order(:name).first
  end
  def self.max_price(max_params)
    where("unit_price < ?", max_params).order(:name).first
  end
  def self.min_max_price(min_params, max_params)
    where("unit_price > ? and unit_price < ?", min_params, max_params).order(:name).first
  end
end
