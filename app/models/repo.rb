class Repo

  attr_reader :grit_repo
  
  def initialize(path=nil)
    @grit_repo = Grit::Repo.init_bare(path || ENV["PARSER_GIT_REPO_PATH"])
  end

  def index
    @index ||= begin
      index = grit_repo.index
      index.read_tree(head.tree.id)
      index
    end
  end

  def head
    grit_repo.commits.first
  end

  def tree
    head.tree
  end

  def add(path, contents)
    index.add(path, contents)
  end

  def commit(message)
    user = Grit::Actor.new("Federico Gonzalez", "fede@example.com")
    index.commit(message, [head], user, nil, 'master')
  end
end