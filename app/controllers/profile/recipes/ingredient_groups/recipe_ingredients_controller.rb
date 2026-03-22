# frozen_string_literal: true

module Profile
  module Recipes
    module IngredientGroups
      class RecipeIngredientsController < Profile::Recipes::IngredientGroups::ApplicationController
        def new
          @recipe_ingredient = current_ingredient_group.recipe_ingredients.new
        end

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def create
          recipe_ingredient = current_ingredient_group.recipe_ingredients.new(recipe_ingredient_params)
          recipe_ingredient.save

          respond_to do |format|
            format.html { redirect_to profile_recipe_ingredient_groups_path(current_recipe) }
            format.turbo_stream do
              render(
                turbo_stream: turbo_stream.update(
                  "ingredient_group_#{current_ingredient_group.id}_list",
                  partial: 'shared/recipe_ingredients',
                  locals: { ingredient_group: current_ingredient_group }
                )
              )
            end
          end
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

        def batch_edit
          @recipe_ingredients = current_recipe.recipe_ingredients
        end

        def update; end

        private

        def recipe_ingredient_params
          params.expect(recipe_ingredient: %i[title quantity unit])
        end
      end
    end
  end
end
