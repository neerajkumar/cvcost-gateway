class User < Base
  establish_connection :users

  def recruiter?
    profile['type'] == 'Recruiter'
  end

  def job_seeker?
    profile['type'] == 'JobSeeker'
  end

  def employee_user?
    profile['type'] == 'EmployerUser'
  end
end
