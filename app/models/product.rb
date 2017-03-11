class Product < ActiveRecord::Base

	has_many :images
	has_many :tags
	has_many :categories
end
