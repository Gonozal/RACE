class CharacterObserver < ActiveRecord::Observer
  def after_create(character)
    # Check if character corporation exists
    unless character.corporation.present?
      Resque.enqueue(CreateCorporationBackgrounder, [character.corporation_id])
    end

    # Create dependant models
    character.create_implant

    # Update character information and set base roles
    character.update_roles
    character.save_portrait
  end
end
