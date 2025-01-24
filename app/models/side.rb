class Side < ApplicationRecord
  belongs_to :order,optional: true
end