# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'home/index.html.erb', type: :view do
  it 'displays the please login message' do
    render
    expect(rendered).to have_text('You are not logged in. Please login.')
  end
end

RSpec.describe 'home/index.html.erb', type: :view do
  it 'displays the welcome message with name' do
    session[:userinfo] = { 'name' => 'Peter', 'sub' => 1 }
    render
    expect(rendered).to have_text('Peter - Welcome to Our Rails App')
  end
end
