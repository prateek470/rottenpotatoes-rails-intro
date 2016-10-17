class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if params[:sort] == 'title' or params[:sort] == 'release_date' then
      @highlight = params[:sort]# highlight variable to show yellow color
    else
      @highlight = 'none'
    end
    # When param sort is title then sort only movies
    if params[:sort] == 'title' then
      @movies = Movie.order('title')
    # if sort is release_date then sort the dates
    elsif params[:sort] == 'release_date' then
      @movies = Movie.order('release_date')
    # Default behaviour
    else
      @movies = Movie.all
    end
# Do task based on rating
    @sort = params[:sort]
    # if rating is null then select all ratings other wise select the keys
    if(params[:ratings] == nil)
      @selected_ratings = @all_ratings
    else
      @selected_ratings = params[:ratings].keys
    end
    # After selecting ratings sort them again if sort is present
    if(@sort != nil)
      @movies = Movie.where(:rating =>@selected_ratings).order(@sort)
    else
      @movies = Movie.where(:rating =>@selected_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
