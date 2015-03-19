CongressForms::App.helpers do
  def requires_bio_id params, retrieval_string
    return {status: "error", message: "You must provide a bio_id to retrieve the " + retrieval_string + "."}.to_json unless params.include? "bio_id"

    bio_id = params["bio_id"]

    @c = CongressMember.bioguide(bio_id)
    halt 200, {status: "error", message: "Congress member with provided bio id not found"}.to_json if @c.nil?
  end

  def requires_job_id params, error_string
    return {status: "error", message: "You must provide a delayed job id to " + error_string + "."}.to_json unless params.include? "job_id"

    job_id = params["job_id"]

    begin
      @job = Delayed::Job.find job_id
    rescue ActiveRecord::RecordNotFound
      halt 200, {status: "error", message: "Job with provided id not found."}.to_json if @job.nil?
    end
  end
end