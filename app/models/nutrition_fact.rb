# frozen_string_literal: true

class NutritionFact
  ENERGY_BY_MACROS = {
    protein: 4,
    fat: 9,
    carbohydrates: 4
  }.freeze

  attr_reader :protein_g, :fat_g, :carbohydrates_g

  def initialize(protein_g, fat_g, carbohydrates_g)
    @protein_g = protein_g
    @fat_g = fat_g
    @carbohydrates_g = carbohydrates_g
  end

  def calories
    @calories ||= (protein_g * ENERGY_BY_MACROS[:protein]) +
                  (fat_g * ENERGY_BY_MACROS[:fat]) +
                  (carbohydrates_g * ENERGY_BY_MACROS[:carbohydrates])
  end

  def +(other)
    self.class.new(
      protein_g + other.protein_g,
      fat_g + other.fat_g,
      carbohydrates_g + other.carbohydrates_g
    )
  end

  def scale(scale_factor)
    self.class.new(
      protein_g * scale_factor,
      fat_g * scale_factor,
      carbohydrates_g * scale_factor
    )
  end
end
