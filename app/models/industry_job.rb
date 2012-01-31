class IndustryJob < ActiveRecord::Base
	belongs_to :character, primary_key: :installer_id
  belongs_to :corporation

  # Update Attributes of current object from row
  def attributes_from_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
  end

  # Updates Industry Jobs from the EVE API
  def self.api_update(owner)
    # First, delete all old implants
    path = api_path(owner)
    api = set_api(owner)
    db_jobs = get_db_industry_jobs(owner)
    begin
      xml = api.get("#{path}/IndustryJobs")
    rescue Exception => e
      logger.error "EVE API Exception cought!"
    else 
      # First, set all industry jobs to "completed"
      industry_jobs = []
      # Go through all Industry Jobs and add them to array
      xml.xpath("/eveapi/result/rowset[@name='jobs']/row").each do |row|
        if(db_jobs.has_key? row.job_id.to_s)
          job = db_jobs[row.job_id.to_s]
        else
          job = IndustryJob.new
        end
        job.attributes_from_row(row)
        job.corporation_id = owner.instance_of?(Corporation)? owner.id : 0
        industry_jobs << job
      end
    end

    # Save implants
    IndustryJob.transaction do
      industry_jobs.each do |job|
        job.save
      end
    end
  end

  private
  def self.get_db_industry_jobs(owner)
    jobs = {}
    owner.industry_jobs.all.each do |job|
      jobs[job.job_id.to_s] = job
    end
    jobs
  end

  # Sets API data from owner object
  def self.set_api(character)
    api = EVEAPI::API.new
    api.api_id = character.api_key.api_id
    api.v_code = character.api_key.v_code
    api.character_id = character.id
    api
  end

  def self.api_path (owner)
    if owner.instance_of?(Corporation)
      "corp"
    elsif owner.instance_of?(Character)
      "char"
    else 
      false
    end
  end
end
