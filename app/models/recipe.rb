# frozen_string_literal: true

class Recipe < ApplicationRecord
  include ImageUploader::Attachment(:image)
  include AASM

  belongs_to :user
  has_many :ingredient_groups, dependent: :destroy
  has_many :recipe_ingredients, through: :ingredient_groups
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true
  validates :body, presence: true

  before_create :generate_slug
  after_commit :generate_image_derivatives

  aasm column: :state do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: :draft, to: :published
    end

    event :to_draft do
      transitions from: :published, to: :draft
    end
  end

  scope :for_public, -> { where(secret: false).published.order(created_at: :desc) }
  scope :secret, -> { where(secret: true) }

  def nutrition_fact
    return if recipe_ingredients.blank?
    return unless can_calculate_nutrition_fact?

    @nutrition_fact ||= begin
      total_weight_g = recipe_ingredients.sum(&:weight_g)

      return if total_weight_g.zero?

      recipe_ingredients.map(&:nutrition_fact).inject(&:+).scale(BigDecimal('100') / total_weight_g)
    end
  end

  def to_param
    slug
  end

  private

  def can_calculate_nutrition_fact?
    recipe_ingredients.detect { |recipe_ingredient| recipe_ingredient.nutrition_fact.blank? }.nil?
  end

  def generate_image_derivatives
    return if image.blank?

    image_derivatives!
  end

  def generate_slug
    next_id = Recipe.connection.select_value("SELECT NEXTVAL('recipes_id_seq')")

    self.slug ||= [next_id, I18n.transliterate(title.strip).downcase.tr(' ', '-')].join('-')
  end
end
