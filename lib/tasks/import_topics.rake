# frozen_string_literal: true

namespace :makigas do
  namespace :import do
    desc 'Imports topics as a YAML document.'
    task :topics, [:schema] => :environment do |_, args|
      raise 'Must provide arguments' if args[:schema].nil?

      Makigas::TopicImport.new(args[:schema])
    end
  end
end
