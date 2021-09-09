class RevenueDateSerializer
  def self.format_revenue(id, revenue)
    {
      "data": {
        "id": id,
        "type": 'revenue',
        "attributes": {
          "revenue": revenue
        }
      }
    }
  end
end
