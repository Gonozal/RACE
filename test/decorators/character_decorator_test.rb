require 'test_helper'

class CharacterDecoratorTest < ActiveSupport::TestCase
  def setup
    ApplicationController.new.set_current_view_context
  end

  # test "the truth" do
  #   assert true
  # end
end

