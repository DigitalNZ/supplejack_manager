module EnvironmentHelpers
	extend ActiveSupport::Concern

	module ClassMethods
		def change_worker_env!(env)
      env_hash = Figaro.env(env)
      self.site = env_hash["WORKER_HOST"]
      self.user = env_hash["WORKER_API_KEY"]
    end
	end
end