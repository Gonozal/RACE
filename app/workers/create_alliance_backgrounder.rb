class CreateAllianceBackgrounder
  @queue = :create_alliance_backgrounder

  def self.perform(alliance_id)
    if Alliance.find_by_id(alliance_id).blank?
      alliance = Alliance.new
      alliance.id = alliance_id

      alliance.attributes_from_api
      alliance.save
    end
  end
end
