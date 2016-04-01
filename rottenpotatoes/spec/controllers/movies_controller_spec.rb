require 'spec_helper'
#require 'factory'

describe MoviesController do
    before :each do
    movies = [{:title => 'Star Wars', :rating => 'PG',
  	           :director => 'George Lucas', :release_date => '1977-05-25'},
    	        {:title => 'Starcraft II', :rating => 'PG-13', 
  	           :director => '', :release_date => '2015-12-12'},
  	 ]

    @movies = movies.map { |movie| Movie.create movie } 
  end
  
   describe "GET #index" do
    subject { get :index }
    
    it "renders the index template" do
      expect(subject).to render_template :movies
      expect(subject).to render_template "movies" 
    end
 
    it "orders the movies by title" do
      get :index, id: @movies, sort: 'title'
      response.status.should be 302 
    end
    
    it "orders the movies by release_date" do
      get :index, id: @movies, sort: 'release_date'
      response.status.should be 302 
    end
    
    it "filters the movies by ratings" do
      get :index, id: @movies, ratings: { :PG => "1" }
      response.status.should be 302 
    end
  end
  
  describe "DELETE #destroy" do
    it "deletes the movie" do 
      expect{ 
        delete :destroy, id: @movies[1]
        }.to change(Movie,:count).by(-1) 
    end 
    
    it "redirects to movies#index" do 
      delete :destroy, id: @movies[1] 
      response.should redirect_to :movies
    end
    
    it "shows a correct message after deleted" do
      delete :destroy, id: @movies[1], movie: @movies[1].attributes
      flash[:notice].should =~ /Movie '#{@movies[1].title}' deleted./i
    end
  end
  
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new movie" do 
        expect{ post :create, id: @movies[0]
              }.to change(Movie,:count).by(1) 
      end
      
      it "redirects to /movies after created" do
        post :create, id: @movies
        response.should redirect_to :movies
      end
      
      it "shows a notification message after created" do
        post :create, id: @movies
        flash[:notice].should =~ /#{assigns(:movie).title} was successfully created./i
      end
    end
  end
  
end