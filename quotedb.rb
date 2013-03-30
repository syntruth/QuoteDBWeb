class QuoteDB < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack

  # First up, the development environment.

  MongoMapper::Document.plugin(MongoMapper::Plugins::IdentityMap)
  MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
  MongoMapper.database = "bogobot"

  # Load the models
  Dir.glob('./models/*.rb').each {|model| require model}
  
  assets do
    js :app, [
      '/js/jquery.js',
      '/js/jquery-ui.js',
      '/js/underscore-min.js',
      '/js/backbone-min.js',
      '/js/backbone-stickit.js',
      '/js/coffee/application.js',
      '/js/coffee/page_options.js',
      '/js/coffee/models/*.js',
      '/js/coffee/collections/*.js',
      '/js/coffee/views/*.js',
      '/js/coffee/setup.js'
    ]

    css :app, [
      '/css/reset.css',
      '/css/ui.css',
      '/css/screen.css'
    ]

    css_compression :sass
  end
  
  # Routes
  get "/" do
    quotes = Quote.order(:id2).limit(20).all

    haml :index, :locals => {:quotes => quotes}
  end

  get '/quotes' do
    if params[:random]
      quotes = Quote.random(params)
    elsif params[:term]
      quotes = Quote.search(params)
    elsif params[:page]
      number = params[:number].to_i
      opts   = {
        :per_page => (number.zero? ? 20 : number),
        :page     => params[:page]
      }
      quotes = Quote.order(:id2).paginate opts
    else
      number = params[:number].to_i
      number = 20 if number.zero?
      quotes = Quote.order(:id2).limit(number).all
    end

    if request.xhr?
      content_type :json
      
      quotes.to_json
    else
      haml :index, :locals => {:quotes => quotes}
    end
  end
end
