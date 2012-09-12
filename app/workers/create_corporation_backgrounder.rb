class CreateCorporationBackgrounder
  @queue = :create_corporation_backgrounder

  def self.perform(corporation_ids)
    corporation_ids.each do |corporation_id|
      if Corporation.find_by_id(corporation_id).blank?
        corporation = Corporation.new
        corporation.id = corporation_id

        corporation.attributes_from_api
        corporation.save
      end
    end
  end
end
