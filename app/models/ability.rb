class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.admin?
      can [:crud,:edit_users], User
    else
      can [:read, :update], User, id: user.id
    end

  end
end
