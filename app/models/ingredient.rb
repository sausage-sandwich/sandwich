# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :nullify
  has_many :recipes, through: :recipe_ingredients
end
