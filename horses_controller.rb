get '/horses' do          # The "home" for the horses resource, index
  @horses = Horse.all     # Pass the horse model into the horse view
  erb :"/horses/index"    # The horses index view, renders all the information
end

get '/horses/new' do      # Retrieve the form for a new horse
  @horse = Horse.new      # Creates a new instance of horse, doesn't save it - hence I don't mind how many times I make a GET
  if request.xhr?         # Is it an AJAX request? If so, render the new form without refreshing the page
    erb :"horses/new", layout: false    # Render just the new form without the layout ERB (title, bar, etc.)
  else                    # Non-Ajax request
    erb :"/horses/new"    # Render the entire page
  end
end

post '/horses' do         # Make a POST request to the horses resource, this obviously you wouldn't want to click multiple times
  if request.xhr?         # AJAX request
    @horse = Horse.new(params[:horse])  # Create a new horse with the params given from the form
    if @horse.save        # If it's a valid horse, go ahead and save it to the database
      erb :_horse_link, layout: false, locals: {horse: @horse}  # Render the information for the horse
    else                  # Horse isn't valid
      erb :"/horses/new", layout: false   # Re-render the new horse form
    end
  else                    # Non-AJAX request
    @horse = Horse.new(params[:horse])  # Create a new horse with the params given from the form
    if @horse.save        # If it is a valid horse
      redirect '/horses'  # Redirect to the horses index
    else
      erb :"/horses/new"  # If not, reload the new horse page
    end
  end
end

get '/horses/:id' do      # Access horses resource and show individual horse with that ID
  @horse = Horse.find(params[:id])  # Pass the horse to the view from the model
  if request.xhr?         # AJAX Request
    erb :_show_attributes, locals: {horse: @horse}, layout: false # Render just the horse's details
  else
    erb :"/horses/show"   # Render the horse's details along with layout
  end
end
