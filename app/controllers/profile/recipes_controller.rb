# frozen_string_literal: true

module Profile
  class RecipesController < Profile::ApplicationController
    def show
      @recipe = current_user.recipes.find_by!(slug: params[:slug])
    end

    def new
      @recipe = Recipe.new
    end

    def edit
      @recipe = current_user.recipes.find_by!(slug: params[:slug])
    end

    def create
      result = ::Recipes::Create.call(user: current_user, recipe_params: recipe_params)

      if result.success?
        redirect_to profile_recipe_ingredient_groups_path(result.recipe)
      else
        @recipe = result.recipe
        render :new
      end
    end

    def edit_details
      @recipe = current_user.recipes.find_by!(slug: params[:slug])
    end

    def update
      @recipe = current_user.recipes.find_by!(slug: params[:slug])
      if @recipe.update(recipe_params)
        @recipe.publish! unless @recipe.published?

        redirect_to profile_recipe_path(@recipe)
      else
        render 'edit'
      end
    end

    def secret
      @recipes = Recipe.published.secret.page(params[:page]).per(16)
    end

    def drafts
      @recipes = Recipe.draft.page(params[:page]).per(16)
    end

    private

    def recipe_params
      params.expect(recipe: %i[title body image description secret])
    end
  end
end
