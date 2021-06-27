class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, JobPost, public: true

    if user.present?
      can :create, JobPost if user.employee_user? || user.recruiter?
      can [:update, :delete], JobPost do |job|
        user == User.find(job&.created_by)
      end
    end
  end
end
