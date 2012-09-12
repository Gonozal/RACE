class CorporationObserver < ActiveRecord::Observer
  def after_create(corporation)
    # Check if Corporation exists
    if corporation.alliance_id != 0 and corporation.alliance.blank?
      Resque.enqueue(CreateAllianceBackgrounder, corporation.alliance_id)
    end
  end
end
