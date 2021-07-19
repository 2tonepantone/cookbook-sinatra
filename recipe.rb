class Recipe
  attr_reader :name, :description, :prep_time, :rating, :done

  def initialize(name:, description:, prep_time:, rating:, done: false)
    @name = name
    @description = description
    @rating = rating
    @prep_time = prep_time
    @done = done
  end

  def done?
    @done
  end

  def mark_done!
    @done = true
  end

  def to_s
    "#{name} - #{description} - #{prep_time} prep (#{rating} / 5.0)"
  end
end
