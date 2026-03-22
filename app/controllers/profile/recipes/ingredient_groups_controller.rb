# frozen_string_literal: true

module Profile
  module Recipes
    class IngredientGroupsController < Profile::Recipes::ApplicationController
      def index
        @recipe_ingredient = RecipeIngredient.new
        @ingredient_group = IngredientGroup.new
      end

      def new
        @ingredient_group = current_recipe.ingredient_groups.new
      end

      def edit
        @ingredient_group = current_recipe.ingredient_groups.find(params[:id])
      end

      # rubocop:disable Metrics/MethodLength
      def create
        @ingredient_group = current_recipe.ingredient_groups.new(ingredient_group_params)
        @ingredient_group.save

        respond_to do |format|
          format.turbo_stream do
            render(
              turbo_stream: turbo_stream.append(
                "recipe_#{current_recipe.id}",
                partial: 'profile/recipes/ingredient_groups/ingredient_group',
                locals: { ingredient_group: @ingredient_group }
              )
            )
          end
        end
      end

      def update
        @ingredient_group = current_recipe.ingredient_groups.find(params[:id])
        @ingredient_group.update(ingredient_group_params)

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "edit_ingredient_group_#{@ingredient_group.id}",
              partial: 'profile/recipes/ingredient_groups/update_title',
              locals: { ingredient_group: @ingredient_group }
            )
          end
        end
      end
      # rubocop:enable Metrics/MethodLength

      private

      def ingredient_group_params
        params.expect(ingredient_group: [:title])
      end
    end
  end
end
