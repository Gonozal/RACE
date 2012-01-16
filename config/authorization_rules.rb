authorization do
  
  # Bundled Roles
  role :admin do
    has_omnipotence
  end
  
  role :member do
    includes :goon
    includes :own_account_character_info
    includes :own_corporation_index
  end
  
  role :goon do
    includes :own_account_basics
  end
  
  role :guest do
    has_permission_on :accounts, :to => [:new, :create]
    has_permission_on :characters, :to => [:new, :create]
    has_permission_on :sessions, :to => [:new, :create]
  end
  
  
  #Navigation and Sub-Navigation Roles
  
  # Roles that allow access to basic character information of owned characters
  

  # Allow adding 
  
  # Allow editing of own account
  role :own_account_basics do
    has_permission_on :accounts do
      to :show, :edit, :update, :change_main_character
      if_attribute :account_id => is { current_account.id }
    end
    has_permission_on :characters do
      to :index, :show, :edit, :create, :update, :delete
      if_attribute :account_id => is { current_account.id }
    end
    has_permission_on :sessions do
      to :destroy
    end
  end
  
  # Allow Deletion of own account
  role :own_account_delete do
    has_permission_on :accounts do
      to :destroy
      if_attribute :account_id => is { current_account.id }
    end
  end
  
  # Allow access to basic character info
  role :own_account_character_info do
    has_permission_on :character_info do
      to :skills, :mails, :assets, :orders, :tranasctions, :jorunal
      if_attribute :account_id => is { current_account.id }
    end
  end 
  
  
  # TEST ROLE FOR NAVIGATION TESTING
  # Allow access to corporation index option
  role :own_corporation_index do
    has_permission_on :corporations do
      to :index
    end
  end 
  
end