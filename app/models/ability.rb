class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, JobPost
    can :create, JobPost do
      user_profile_type = user.profile['type']
      user_profile_type == 'Recruiter' || user_profile_type == 'EmployerUser'
    end
    can [:update, :delete], JobPost do |job|
      user == User.find(job&.created_by)
    end
  end
end
