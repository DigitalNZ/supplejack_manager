class TestWorker
  include Sidekiq::Worker

  def perform(name, count)
    puts "Doing hard work [#{name}, #{count}]"
  end
end
