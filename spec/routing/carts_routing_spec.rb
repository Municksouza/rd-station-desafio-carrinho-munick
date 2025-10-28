# spec/routing/carts_routing_spec.rb
require 'rails_helper'

RSpec.describe CartsController, type: :routing do
  it 'routes to #show' do
    expect(get: '/cart').to route_to('carts#show')
  end

  it 'routes to #create' do
    expect(post: '/cart').to route_to('carts#create')
  end

  it 'routes to #add_item' do
    expect(post: '/cart/add_item').to route_to('carts#add_item')
  end

  it 'routes to #destroy_item' do
    expect(delete: '/cart/123').to route_to('carts#destroy_item', id: '123')
  end
end
