FactoryBot.define do
   factory :transaction do
     credit_card_number { '1234567891011123'  }
     credit_card_expiration_date { '0825'  }
     result { 'success'}
     invoice
   end
 end
