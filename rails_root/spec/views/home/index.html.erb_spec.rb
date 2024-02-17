# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'home/index.html.erb', type: :view do
  it 'displays the welcome message' do
    render

    expect(rendered).to have_text('welcome to Our Rails App')
  end
end
