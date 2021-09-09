class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.revenue_by_date(start_date, end_date)
    joins(:transactions, :invoice_items)
      .where('transactions.result = ? and invoices.status = ?', 'success', 'shipped')
      .where('invoices.created_at >= ? and invoices.created_at <= ?', start_date, end_date)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.potential_revenue(quantity)
    joins(:transactions, :invoice_items)
      .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue')
      .where('transactions.result = ?', 'success')
      .where.not('invoices.status = ?', 'shipped')
      .group('invoices.id')
      .order('potential_revenue DESC')
      .limit(quantity)
  end

  def self.revenue_by_week
    joins(:transactions, :invoice_items)
      .where('transactions.result = ? and invoices.status = ?', 'success', 'shipped')
      .group("date_trunc('week', invoices.created_at)")
      .order(Arel.sql("date_trunc('week', invoices.created_at)"))
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
