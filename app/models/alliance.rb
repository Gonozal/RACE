class Alliance < ActiveRecord::Base

  has_one :executor_corp, class_name: "Corporation", foreign_key: "id"
  has_many :corporations
  has_many :eve_mails

  # Update Attributes of current object from an API row
  def attributes_from_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
    send(:id=, params['allianceID'])
  end

  def self.api_update
    api = EVEAPI::API.new
    api.version = 1
    db_alliances = hashify_db_alliances

    updated_alliances = []
    begin
      xml = api.get("/eve/AllianceList")
      # after the api request succeeded, mark ALL alliances as "disbanded"
    rescue Exception => e
      puts e.inspect
    else
      Alliance.update_all(disbanded: true)
      xml.xpath("/eveapi/result/rowset[@name='alliances']/row").each do |row|
        if db_alliances.has_key?(row['allianceID'])
          # if alliance is already in DB, load it
          alliance = db_alliances[row['allianceID']]
        else
          # if it's not in the DB, create a new alliance
          alliance = Alliance.new
        end
        # Update alliance and "un-disband" all Alliances still in the API
        alliance.attributes_from_row(row)
        alliance.disbanded = false
        # Add alliance to array for later updating
        updated_alliances << alliance
      end
    end

    # Update all alliances in a single transaction
    Alliance.transaction do
      updated_alliances.each do |a|
        a.save
      end
    end
  end

  private
  def self.hashify_db_alliances
    alliance_hash = {}
    alliances = Alliance.all
    alliances.each do |a|
      alliance_hash[a.id.to_s] = a
    end
    alliance_hash
  end
end
