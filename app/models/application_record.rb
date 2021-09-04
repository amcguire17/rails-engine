class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.get_list(page, per_page)
    offset(page * per_page).limit(per_page)
  end
end
