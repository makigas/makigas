# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Topic page', type: :feature do
  let(:topic) { FactoryBot.create(:topic) }

  it 'shows information about a topic' do
    visit topic_path(topic)
    expect(page).to have_text topic.title
    expect(page).to have_text topic.description
    expect(page).to have_css "img[src*='#{topic.thumbnail.url(:small)}']"
  end

  it 'shows playlists in a topic' do
    playlist = FactoryBot.create(:playlist, topic: topic)

    visit topic_path(topic)

    expect(page).to have_text playlist.title
    expect(page).to have_css "img[src*='#{playlist.thumbnail.url(:default)}']"
    expect(page).to have_css "a[href*='#{playlist_path(playlist)}']"
  end

  context 'when the playlist is empty' do
    let(:playlist) { FactoryBot.create(:playlist, videos: []) }
    let(:topic) { FactoryBot.create(:topic, playlists: [playlist]) }

    it 'shows the playlist length' do
      visit topic_path(topic)
      expect(page).to have_text '0 episodios'
    end
  end

  context 'when the playlist has a video' do
    let(:video) { FactoryBot.create(:video) }
    let(:playlist) { FactoryBot.create(:playlist, videos: [video]) }
    let(:topic) { FactoryBot.create(:topic, playlists: [playlist]) }

    it 'shows the playlist length' do
      visit topic_path(topic)
      expect(page).to have_text '1 episodio'
    end
  end

  context 'when the playlist has multiple videos' do
    let(:first) { FactoryBot.create(:video, youtube_id: '1234') }
    let(:second) { FactoryBot.create(:video, youtube_id: '1235') }
    let(:playlist) { FactoryBot.create(:playlist, videos: [first, second]) }
    let(:topic) { FactoryBot.create(:topic, playlists: [playlist]) }

    it 'shows the playlist length' do
      visit topic_path(topic)
      expect(page).to have_text '2 episodios'
    end
  end

  context 'when the playlist has scheduled videos' do
    let(:first) { FactoryBot.create(:video, youtube_id: '1234') }
    let(:second) { FactoryBot.create(:video, youtube_id: '1235', published_at: 2.days.from_now) }
    let(:playlist) { FactoryBot.create(:playlist, videos: [first, second]) }
    let(:topic) { FactoryBot.create(:topic, playlists: [playlist]) }

    it 'scheduled videos are not counted' do
      visit topic_path(topic)
      expect(page).to have_text '1 episodio'
    end
  end
end
