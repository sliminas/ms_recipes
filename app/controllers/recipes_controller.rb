# frozen_string_literal: true

class RecipesController < ApplicationController
  def index
    client = Contentful::Client.new(
      space:           Rails.application.config.contentful.space_id,
      access_token:    Rails.application.config.contentful.access_token,
      dynamic_entries: :auto
    )

    @recipes = client.entries(content_type: 'recipe')
  end
end
