# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SurveyProfilesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/survey_profiles').to route_to('survey_profiles#index')
    end

    it 'routes to #new' do
      expect(get: '/survey_profiles/new').to route_to('survey_profiles#new')
    end

    it 'routes to #show' do
      expect(get: '/survey_profiles/1').to route_to('survey_profiles#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/survey_profiles/1/edit').to route_to('survey_profiles#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/survey_profiles').to route_to('survey_profiles#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/survey_profiles/1').to route_to('survey_profiles#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/survey_profiles/1').to route_to('survey_profiles#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/survey_profiles/1').to route_to('survey_profiles#destroy', id: '1')
    end
  end
end
