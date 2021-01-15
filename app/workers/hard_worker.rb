module HardWorker
  require "colorize"
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(name, count)
    puts "HardWorker is performing".red
    count.times do
    puts "...Hello #{name}".green
    end
  end
  
end