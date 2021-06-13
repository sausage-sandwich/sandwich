class Recipe < ApplicationRecord
  include ImageUploader::Attachment(:image)

  has_many :ingredient_groups
  has_many :recipe_ingredients, through: :ingredient_groups
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true
  validates :body, presence: true

  after_create :generate_image_derivatives

  private

  def generate_image_derivatives
    return if image_data.blank?

    image_derivatives!
  end
end
