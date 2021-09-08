FactoryBot.define do
   factory :invoice do
     status { 'completed' }
     merchant
     customer
   end
 end
