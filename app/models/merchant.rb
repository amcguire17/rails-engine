class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.quantity_by_revenue(quantity_params)
    joins(invoices: [:transactions, :invoice_items])
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where('transactions.result = ? and invoices.status = ?', 'success', 'shipped')
    .group('merchants.id')
    .order('revenue DESC')
    .limit(quantity_params)
  end
  def self.quantity_by_items(quantity_params)
    joins(invoices: [:transactions, :invoice_items])
    .select('merchants.*, sum(invoice_items.quantity) as count')
    .where('transactions.result = ? and invoices.status = ?', 'success', 'shipped')
    .group('merchants.id')
    .order('count DESC')
    .limit(quantity_params)
  end
  def self.total_revenue(merchant_params)
    joins(invoices: [:transactions, :invoice_items])
    .select('merchants.id, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where('transactions.result = ? and invoices.status = ?', 'success', 'shipped')
    .group('merchants.id')
    .find(merchant_params)
  end
end
