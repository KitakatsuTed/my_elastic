class ArtistsController < ApplicationController
  before_action :set_artist, only: [:edit, :update, :destroy]

  def index
    @artists = Artist.all
    @mapping = Artist.__elasticsearch__.mapping.to_hash[:_doc][:properties]
    @aliases = Artist.get_aliases
  end

  def search
    @search_form = Elastic::Artists::SearchForm.new(elastic_form_params)
  end

  def new
    @artist = Artist.new
  end

  def edit
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      redirect_to root_path, notice: 'Artist was successfully created.'
    else
      render :new
    end
  end

  def update
    if @artist.update(artist_params)
      redirect_to @artist, notice: 'Artist was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @artist.destroy
    redirect_to artists_url, notice: 'Artist was successfully destroyed.'
  end

  private
  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :age, :gender, :birth)
  end

  def elastic_form_params
    return {} unless params[:elastic_artists_search_form]

    params.require(:elastic_artists_search_form).permit(:name, :age_from, :age_to, :birth_from, :birth_to, :gender)
  end
end
