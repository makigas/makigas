# frozen_string_literal: true

namespace :makigas do
  desc 'Feeds data coming from a legacy schema into the system'

  task :data_migrate, %i[schema thumbs] => :environment do |_, args|
    raise 'Must provide arguments' if args[:schema].nil? || args[:thumbs].nil?

    Makigas::DataMigrator.new(args[:schema], args[:thumbs]).load!
  end
end
