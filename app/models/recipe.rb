# frozen_string_literal: true

class Recipe
  attr_reader :contentful_recipe

  delegate :id, :title, :calories, to: :contentful_recipe

  class << self
    def all
      api.entries(content_type: 'recipe').map { |recipe| new recipe }
    end

    def by_id(id)
      new api.entry(id, include: 1)
    end

    def api
      @api ||= Contentful::Client.new(
        space:           Rails.application.config.contentful.space_id,
        access_token:    Rails.application.config.contentful.access_token,
        dynamic_entries: :auto
      )
    end
  end

  def initialize(contentful_recipe)
    @contentful_recipe = contentful_recipe
  end

  def image_url
    contentful_recipe.photo.url
  end

  def chef
    contentful_recipe.chef.name if contentful_recipe.fields[:chef]
  end

  def tags
    contentful_recipe.tags.map(&:name).join(', ') if contentful_recipe.fields[:tags]
  end

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(contentful_recipe.description).html_safe
  end
end
