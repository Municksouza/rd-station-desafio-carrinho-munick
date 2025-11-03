require 'rails_helper'

RSpec.describe Api::CartsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/cart').to route_to('api/carts#show')
    end

    it 'routes to #add_item' do
      expect(post: '/api/cart/add_item').to route_to('api/carts#add_item')
    end

    it 'routes to #destroy_item' do
      expect(delete: '/api/cart/1').to route_to('api/carts#destroy_item', id: '1')
    end
  end
end
