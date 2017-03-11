module Admin
	class ProductsController < ApplicationController

		def index
			@products = Product.all
		end

		def new
			@product = Product.new
		end

		def edit
			@product = Product.find_by_id(params[:id])    
		end

		def create
			@product = Product.new
			@product.name = params[:product][:name]
			@product.sku = params[:product][:sku]
			@product.price = params[:product][:price]
			if params[:product]['expire_date(2i)'].length == 1
				params[:product]['expire_date(2i)'] = "0" + params[:product]['expire_date(2i)']
			end
			if params[:product]['expire_date(3i)'].length == 1
				params[:product]['expire_date(3i)'] = "0" + params[:product]['expire_date(3i)']
			end
			expire_date = params[:product]['expire_date(1i)'] + "-" + params[:product]['expire_date(2i)'] + "-" + params[:product]['expire_date(3i)']
			@product.expire_date = Time.parse(expire_date)
			tag_values = params[:tags].split(',') unless params[:tags].nil?
			category_values = params[:categories].split(',') unless params[:categories].nil?
			image_path = params[:images].split(',') unless params[:images].nil?
			@product.save!
			unless tag_values.nil?
				tag_values.each do |tag|
					@product.tags.create(:tag_value => tag)
				end
			end
			unless category_values.nil?
				category_values.each do |category|
					@product.categories.create(:category_name => category)
				end
			end
			unless image_path.nil?
				image_path.each do |image_path|
					@product.images.create(:path => image_path)
				end
			end
			redirect_to admin_products_path
		end

		def update
			@product = Product.find(params[:id])
			redirect_to :action => "index" if @product.nil?
			@product.name = params[:product][:name]
			@product.sku = params[:product][:sku]
			@product.price = params[:product][:price]
			if params[:product]['expire_date(2i)'].length == 1
				params[:product]['expire_date(2i)'] = "0" + params[:product]['expire_date(2i)']
			end
			if params[:product]['expire_date(3i)'].length == 1
				params[:product]['expire_date(3i)'] = "0" + params[:product]['expire_date(3i)']
			end
			expire_date = params[:product]['expire_date(1i)'] + "-" + params[:product]['expire_date(2i)'] + "-" + params[:product]['expire_date(3i)']
			@product.expire_date = Time.parse(expire_date)
			@product.save!
			@product.tags.delete_all
			@product.categories.delete_all
			tag_values = params[:tags].split(',') unless params[:tags].nil?
			category_values = params[:categories].split(',') unless params[:categories].nil?
			image_path = params[:images].split(',') unless params[:images].nil?
			unless tag_values.nil?
				tag_values.each do |tag|
					@product.tags.create(:tag_value => tag)
				end
			end
			unless category_values.nil?
				category_values.each do |category|
					@product.categories.create(:category_name => category)
				end
			end
			unless image_path.nil?
				image_path.each do |image_path|
					@product.images.create(:path => image_path)
				end
			end
			redirect_to :action => "index"
		end
	end
end