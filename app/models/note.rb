class Note < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
end