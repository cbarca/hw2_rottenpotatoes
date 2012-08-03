class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  @movies = []
  @sel_order = params[:order]
  @sel_ratings_hash = params[:ratings]
  @all_ratings = Movie.all_ratings

  if params[:commit] == 'Refresh'
    session[:ratings] = @sel_ratings_hash
  end

  if @sel_ratings_hash != nil
    @sel_ratings_keys = @sel_ratings_hash.keys
    #restrict database query to selected filters
    @movies = Movie.where(:rating => @sel_ratings_keys)
    if (@sel_order == nil) 
      @sel_order = session[:order]
    end
    if @sel_order == "title"
      session[:order] = @sel_order
      @movies.sort_by! { |a| a.title }
    elsif @sel_order == "release_date"
      session[:order] = @sel_order
      @movies.sort_by! { |a| a.release_date }
    end
  elsif session[:ratings] != nil
    redirect_to movies_path(:order => session[:order], :ratings => session[:ratings])
  end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
