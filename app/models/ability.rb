class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, JobPost
  end
end
