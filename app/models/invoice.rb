class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.revenue_by_date(start_date, end_date)
    joins(:transactions, :invoice_items)
    .where('transactions.result = ? and invoices.status = ?', 'success', 'shipped')
    .where('invoices.created_at >= ? and invoices.created_at <= ?', start_date, end_date)
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
