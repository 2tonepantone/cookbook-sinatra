require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require_relative 'cookbook'
require_relative 'recipe'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

cookbook = Cookbook.new('./recipes.csv')

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/recipes/new' do
  erb :new
end

post '/recipes/create' do
  args = params.to_h.transform_keys(&:to_sym)
  recipe = Recipe.new(**args)
  cookbook.add_recipe(recipe)
  redirect to('/')
end
