require 'sinatra'
require 'omniauth-twitter'
require 'yaml'
require 'byebug'

keys = YAML.load(File.open('app/controllers/secret.yml'))

use OmniAuth::Builder do
  provider :twitter, keys["API_key"], keys["API_secret"]
end
 
configure do
  enable :sessions
end
 
helpers do
  def admin?
    session[:admin]
  end
end
 
get '/public' do
  erb :index
end
 
get '/private' do
  halt(401,'Not Authorized') unless admin?
  "This is the private page - members only"
end
 
get '/login' do
  redirect to("/auth/twitter")
end

get '/auth/twitter/callback' do
  session[:admin] = true
  session[:username] = env['omniauth.auth']['info']['name']
  env['omniauth.auth']['info']['name']
end
 
get '/auth/failure' do
  params[:message]
end

get '/logout' do
  session.clear
  erb :index
end