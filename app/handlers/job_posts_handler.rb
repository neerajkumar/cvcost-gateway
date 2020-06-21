Api::Routes.route('job_posts') do |r|
  @model = JobPost
  r.route 'basic_crud'
end
