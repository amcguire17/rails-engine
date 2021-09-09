class WeeklyRevenueSerializer
  def self.format_data(id, revenue)
    {
      "data": map_revenue(id, revenue)
    }
  end

  def self.map_revenue(id, revenue)
    revenue.map do |k, v|
      {
        "id": id,
        "type": 'weekly_revenue',
        "attributes": {
          "week": k.to_date.to_s,
          "revenue": v
        }
      }
    end
  end
end
