class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.get_list(page, per_page)
    offset(page * per_page).limit(per_page)
  end

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%").order(:name).first
  end

  def self.search_all(search_params)
    where("name ILIKE ?", "%#{search_params}%").order(:name)
  end
end
