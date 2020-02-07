module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def selected(rating)
    if(!session[:ratings].nil?)
      selected = session[:ratings].include? rating
    else
      return true
    end
  end
  
end
