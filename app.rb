#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def init_db
	@db = SQLite3::Database.new 'public/leprosorium.db'
	@db.results_as_hash = true
end

before do

	init_db

end

configure do 

	init_db

	@db.execute "CREATE TABLE IF NOT EXISTS Posts (id INTEGER PRIMARY KEY AUTOINCREMENT, created_date DATE, content TEXT);"

end



get '/main' do
  "Hello World"
end




get '/new' do

	erb :new

end

 

post '/new' do
  	
  @content = params[:content]

  if @content.size < 1
  	
  		@error = "Введите же текст!"
  
else
  @db.execute 'insert into Posts (content, created_date) values (?, datetime())', [@content]
	

end
  erb :new

redirect to '/'

end


get '/' do

	@results = @db.execute 'select * from Posts order by id desc' 

	erb :index

end


get '/details/:post_id' do
	
	@num = params[:post_id]

	@post = @num

	@row  =  @db.execute "select * from Posts where id = ?",[@num] 

	

	erb :details


end