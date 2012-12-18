if Rails.env.test?
  `git init #{ENV["PARSER_GIT_REPO_PATH"]}`
end

THE_REPO = Repo.new