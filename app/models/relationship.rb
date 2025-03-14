class Relationship < ApplicationRecord
  belongs_to :follower, class_name: Settings.defaults.user_class
  belongs_to :followed, class_name: Settings.defaults.user_class
end
