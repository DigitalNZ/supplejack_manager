module WorkerEnvironmentHelpers
  
  ["harvest_job", "harvest_schedule"].each do |model|
    define_method("#{model.pluralize}_path") do |*args|
      env = params[:environment] || "staging"
      send("environment_#{model.pluralize}_path", env, args[0])
    end

    define_method("#{model}_path") do |*args|
      env = params[:environment] || "staging"
      send("environment_#{model}_path", env, args[0])
    end
  end
end