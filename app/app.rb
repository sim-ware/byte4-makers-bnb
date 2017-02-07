require_relative 'data_mapper_setup'

class MakersBnB < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  get '/' do
     erb :index
  end

  post '/signup' do
    user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    session[:user_id] = user.id
    redirect '/spaces'
   end

  get '/spaces/new' do
    erb :'spaces/new'
  end

  post '/spaces' do
    @space = Space.create(title: params[:title], description: params[:description],price: params[:price], user_id: session[:user_id])
    redirect '/spaces'
  end

  get '/spaces/:id' do
    @space = Space.get(params[:id])
    session[:space_id] = params[:id]
    erb :space_page
  end

  get '/spaces' do
    @spaces = Space.all
    erb :'spaces/index'
  end

  get '/login' do
    erb :login
  end

  get '/signout' do
    session[:user_id] = nil
    flash.keep[:notice] = "See you soon!"
    redirect '/spaces'
  end

  post '/login' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect '/spaces'
    else
      flash[:errors] = 'The email or password is incorrect!'
      redirect '/login'
    end
  end

  post '/requests' do
    @booking = Booking.create(guest_id: session[:user_id], request_text: params[:text], status: 'Not confirmed', space_id: session[:space_id])
    @space = Space.get(@booking.space_id)
    erb :requests
  end

  run! if app_file == $0
end
