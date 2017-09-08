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

require 'rails_helper'

RSpec.describe Video, type: :model do
  context 'is valid when instanciated via' do
    it ':video factory' do
      video = FactoryGirl.build(:video)
      expect(video).to be_valid
    end

    it ':yesterday_video factory' do
      video = FactoryGirl.build(:yesterday_video)
      expect(video).to be_valid
    end

    it ':tomorrow_video factory' do
      video = FactoryGirl.build(:tomorrow_video)
      expect(video).to be_valid
    end
  end

  context 'validation' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :youtube_id }
    it { is_expected.to validate_presence_of :duration }
    it { is_expected.to validate_presence_of :playlist }
    it { is_expected.to validate_presence_of :published_at }

    it { is_expected.to validate_length_of(:title).is_at_most 100 }
    it { is_expected.to validate_length_of(:description).is_at_most 1500 }
    it { is_expected.to validate_length_of(:youtube_id).is_at_most 15 }
    
    it { is_expected.to validate_numericality_of(:duration).is_greater_than 0 }
  end

  context 'relationship' do
    it { is_expected.to belong_to :playlist }
    it { is_expected.to have_many :links }
  end

  context 'slug' do
    it 'generates slug' do
      video = FactoryGirl.create(:video, title: 'Sample')
      expect(video.slug).to eq 'sample'
    end

    it 'does not repeat slug' do
      playlist = FactoryGirl.create(:playlist)
      video1 = FactoryGirl.create(:video, title: 'Sample', playlist: playlist)
      video2 = FactoryGirl.create(:video, title: 'Sample', youtube_id: 'AAAA', playlist: playlist)
      expect(video1.slug).not_to eq video2.slug
    end

    it 'repeats slug on different playlists' do
      video1 = FactoryGirl.create(:video, title: 'Sample', youtube_id: 'AAAA')
      playlist2 = FactoryGirl.create(:playlist, title: 'Hello')
      video2 = FactoryGirl.create(:video, title: 'Sample', playlist: playlist2)
      expect(video1.slug).to eq video2.slug
    end
  end

  context 'natural duration' do
    it 'should convert from duration to natural duration' do
      expect(FactoryGirl.build(:video, duration: 12).natural_duration).
        to eq '00:00:12'
      expect(FactoryGirl.build(:video, duration: 61).natural_duration).
        to eq '00:01:01'
      expect(FactoryGirl.build(:video, duration: 102).natural_duration).
        to eq '00:01:42'
      expect(FactoryGirl.build(:video, duration: 3600).natural_duration).
        to eq '01:00:00'
    end

    it 'should convert from natural duration to duration' do
      video = FactoryGirl.build(:video)
      video.natural_duration = '0:12'
      expect(video.duration).to eq 12
      video.natural_duration = '1:01'
      expect(video.duration).to eq 61
      video.natural_duration = '1:42'
      expect(video.duration).to eq 102
      video.natural_duration = '59:59'
      expect(video.duration).to eq 3599
      video.natural_duration = '1:00:00'
      expect(video.duration).to eq 3600
      video.natural_duration = '9:59:59'
      expect(video.duration).to eq 35999
      video.natural_duration = '10:00:00'
      expect(video.duration).to eq 36000
    end
  end

  describe '.visible?' do
    let(:published) { FactoryGirl.build(:video, published_at: 2.days.ago) }
    let(:scheduled) { FactoryGirl.build(:video, published_at: 6.weeks.from_now) }

    context 'when publishing date has been reached' do
      subject { published.visible? }
      it { is_expected.to eq true }
    end

    context 'when publishing date has not been reached' do
      subject { scheduled.visible? }
      it { is_expected.to eq false }
    end
  end

  describe '.scheduled?' do
    let(:published) { FactoryGirl.build(:video, published_at: 2.days.ago) }
    let(:scheduled) { FactoryGirl.build(:video, published_at: 6.weeks.from_now) }

    context 'when publishing date has been reached' do
      subject { published.scheduled? }
      it { is_expected.to eq false }
    end

    context 'when publishing date has not been reached' do
      subject { scheduled.scheduled? }
      it { is_expected.to eq true }
    end
  end

  describe '.visible' do
    before(:each) do
      @published = FactoryGirl.create(:video, youtube_id: 'ASDF', published_at: 2.days.ago)
      @scheduled = FactoryGirl.create(:video, youtube_id: 'ASDQ', published_at: 2.days.from_now)
    end

    it 'should contain a video published yesterday' do
      videos = Video.visible.collect
      expect(videos).to include @published
    end

    it 'should not contain a video published tomorrow' do
      videos = Video.visible.collect
      expect(videos).not_to include @scheduled
    end
  end
end
