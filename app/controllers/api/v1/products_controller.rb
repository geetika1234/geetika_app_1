module Api
	module V1
		class ProductsController < ApplicationController
			protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

			def create
				update_response = Hash.new
				#if product exists for that sku then updating the product
				@product = Product.find_by_sku(params[:sku_id])
				if @product.blank?
					@product = Product.new
					@product.sku = params[:sku_id]
					update_response['request'] = 'create'
				else
					update_response['request'] = 'update'
				end
				@product.name = params[:name]
				@product.price = params[:price]
				@product.expire_date = Time.parse(params[:expire_date])
				@product.save!
				@product.tags.delete
				@product.categories.delete
				unless params[:categories].nil?
					params[:categories].each do |category|
						@product.categories.create(:category_name => category)
					end
				end
				unless params[:tags].nil?
					params[:tags].each do |tag|
						@product.tags.create(:tag_value => tag)
					end
				end
				unless params[:images].nil?
					params[:images].each do |image|
						@product.images.create(:path => image['img_path'])
					end
				end
				update_response[params[:sku_id]] = 'created/updated'
				render :json => update_response
			end

		end
	end
end	