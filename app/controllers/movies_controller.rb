class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def allRatings
    @all_ratings = Movie.order(:rating).select(:rating)
    @all_ratings = @all_ratings.map(&:rating).uniq
  end
  
  def index
    allRatings
    if(!params[:ratings].nil?)
      session[:ratings] = params[:ratings]
    end
    if(params[:order].nil?)
      session[:order] = params[:order] 
    end
    if(!session[:ratings].nil? || !session[:order].nil?)
      #session rating not nill -- session order not nill
      if(!session[:ratings].nil? && !session[:order.nil?])
        #param rating nill -- param order nill
        if (params[:ratings].nil? && params[:order].nil?)
          @selected = session[:ratings].keys
          @movies = Movie.where(:rating => @selected)
          @movies = @movies.order(session[:order])
        #param rating not nill -- param order nill  
        elsif (params[:order].nil?)
          @selected = params[:ratings].keys
          @movies = Movie.where(:rating => @selected)
          @movies = @movies.order(session[:order])
        #param rating nill -- param order not nill
        else
          @selected = session[:ratings].keys
          @movies = Movie.where(:rating => @selected)
          @movies = @movies.order(params[:order])
        end
      #session rating not nill -- session order nill
      elsif(!session[:ratings].nil?)
        #param rating nill -- param order nill
        if (params[:ratings].nil? && params[:order].nil?)
          @selected = session[:ratings].keys
          @movies = Movie.where(:rating => @selected)
        #param rating not nill -- param order nill  
        elsif (params[:order].nil?)
          @selected = params[:ratings].keys
          @movies = Movie.where(:rating => @selected)
        #param rating nill -- param order not nill
        else
          @selected = session[:ratings].keys
          @movies = Movie.where(:rating => @selected)
          @movies = @movies.order(params[:order])
        end
      #session rating nill -- session order not nill
      else
        #param rating nill -- param order nill
        if (params[:ratings].nil? && params[:order].nil?)
          @movies = @movies.order(session[:order])
        #param rating not nill -- param order nill
        elsif (params[:order].nil?)
          @selected = params[:ratings].keys
          @movies = Movie.where(:rating => @selected)
          @movies = @movies.order(session[:order])
        #param rating nill -- param order not nill
        else
          @movies = @movies.order(params[:order])
        end
      end
    else
      @movies = Movie.all
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
