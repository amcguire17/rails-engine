require 'rails_helper'

describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end
end
