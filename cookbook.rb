require 'csv'

# Recipe repository
class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    read_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    # adds a new recipe to the cookbook
    @recipes << recipe
    write_csv
  end

  def remove_recipe(recipe_index)
    # removes a recipe from the cookbook
    @recipes.delete_at(recipe_index)
    write_csv
  end

  def mark_recipe_done(recipe_index)
    @recipes[recipe_index].mark_done!
    write_csv
  end

  private

  def read_csv
    CSV.foreach(@csv_file_path) do |recipe|
      @recipes << Recipe.new(recipe[0], recipe[1], recipe[2], recipe[3], recipe[4] == 'true')
    end
  end

  def write_csv
    # overwrites the csv after adding and removing recipes
    csv_options = { col_sep: ',', force_quotes: false }
    CSV.open(@csv_file_path, 'wb', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.rating, recipe.done]
      end
    end
  end
end
