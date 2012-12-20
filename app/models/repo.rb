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

  def commit(message, commiter)
    index.commit(message, [head], author(commiter), nil, 'master')
  end

  def author(name_or_user=nil)
    if name_or_user
      if name_or_user.is_a?(User)
        Grit::Actor.new(name_or_user.name, name_or_user.email)
      else
        Grit::Actor.from_string(name)
      end
    else
      Grit::Actor.new("Federico Gonzalez", "fede@example.com")
    end
  end
end