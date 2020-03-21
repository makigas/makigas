module Dashboard
  class PlaylistsController < Dashboard::DashboardController
    before_action :playlist_set, only: %i[show edit update destroy videos]

    def index
      @playlists = Playlist.order(updated_at: :desc).page(params[:page])
    end

    def show; end

    def new
      @playlist = Playlist.new
    end

    def create
      @playlist = Playlist.new(playlist_params)
      if @playlist.save
        redirect_to [:dashboard, @playlist], notice: t('.created')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @playlist.update(playlist_params)
        redirect_to [:dashboard, @playlist], notice: t('.updated')
      else
        render :edit
      end
    end

    def destroy
      @playlist.destroy!
      redirect_to %i[dashboard playlists], notice: t('.destroyed')
    end

    def videos
      @videos = @playlist.videos
    end

    private

    def playlist_params
      params.require(:playlist).permit(:title, :description, :youtube_id, :topic_id, :card, :thumbnail)
    end

    def playlist_set
      @playlist = Playlist.friendly.find(params[:id])
    end
  end
end
