class ContractItem < ActiveRecord::Base
  belongs_to :contract, autosave: true
  def update_fom_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
    send(:id=, params['recordID'])
  end
end
