class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, :all

      can :update, User, id: user.id

      if user.manage_data_sources?
        can :create, Source
        can :update, Source do |source|
          user.manage_partners.include?(source.partner.id.to_s)
        end
      end

      if user.manage_parsers?
        can :create, Parser
        can [:update, :preview], Parser do |parser|
          user.manage_partners.include?(parser.partner.id.to_s)
        end

        can [:create, :update], ParserTemplate
        can [:create, :update], Snippet
      end

      can :run_harvest, Parser do |parser|
        user.run_harvest_partners.include?(parser.partner.id.to_s)
      end

      if user.manage_harvest_schedules?
        can :create, HarvestSchedule
        can :update, HarvestSchedule do |schedule|
          user.manage_partners.include?(schedule.parser.partner.id.to_s)
        end
      end

      if user.manage_link_check_rules?
        can :create, LinkCheckRule
        can :update, LinkCheckRule do |rule|
          rule.source && user.manage_partners.include?(rule.source.partner.id.to_s)
        end
      end

      cannot :read, :collection_record
    end
  end
end
