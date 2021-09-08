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
  def self.quantity_by_revenue(quantity_params)
    joins(invoices: [:transactions])
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where('transactions.result = ? and invoices.status = ?', 'success', 'shipped')
    .group('items.id')
    .order('revenue DESC')
    .limit(quantity_params)
  end
end
