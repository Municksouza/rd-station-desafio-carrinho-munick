require 'rails_helper'

RSpec.describe Api::ProductsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/products').to route_to('api/products#index')
    end

    it 'routes to #show' do
      expect(get: '/api/products/1').to route_to('api/products#show', id: '1')
    end
  end
end
