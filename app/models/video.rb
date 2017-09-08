# == Schema Information
#
# Table name: videos
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text             not null
#  youtube_id   :string           not null
#  duration     :integer          not null
#  slug         :string           not null
#  playlist_id  :integer          not null
#  position     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  unfeatured   :boolean          default(FALSE), not null
#  published_at :datetime         not null
#  private      :boolean          default(FALSE), not null
#
# Indexes
#
#  index_videos_on_slug        (slug)
#  index_videos_on_youtube_id  (youtube_id) UNIQUE
#

class Video < ApplicationRecord
  extend FriendlyId

  # Videos are sorted in a playlist.
  belongs_to :playlist
  acts_as_list scope: :playlist

  # Videos can have links
  has_many :links

  # Slug. Can be repeated as long as it's on different playlists.
  friendly_id :title, use: [:slugged, :scoped], scope: :playlist

  # Scope for limiting the amount of videos to those actually published.
  scope :visible, -> { where('published_at <= ?', DateTime.now) }

  # Validations.
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 15 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :playlist, presence: true
  validates :published_at, presence: true

  # Natural duration
  def natural_duration= dur
    self.duration = ApplicationController.helpers.extract_time dur
  end

  def natural_duration
    if duration
      "%02d:%02d:%02d" % [duration / 3600, (duration % 3600) / 60, duration % 60]
    end
  end

  # Visible videos are those whose publication date has been already reached.
  # Therefore this videos are visible on lists, playlists, searches...
  def visible?
    self.published_at <= DateTime.now
  end

  # Scheduled videos are those whose publication date has not been reached yet.
  # Showing content for this video would spoil the experience and therefore
  # they should be excluded from searches, lists, playlists...
  def scheduled?
    self.published_at > DateTime.now
  end

  def to_s
    title
  end


end
