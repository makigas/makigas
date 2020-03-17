namespace :makigas do
  namespace :import do
    desc 'Imports videos as a YAML document.'
    task :videos, [:schema] => :environment do |t, args|
      raise 'Must provide arguments' if args[:schema].nil?

      Makigas::VideoImport.new(args[:schema])
    end
  end
end
