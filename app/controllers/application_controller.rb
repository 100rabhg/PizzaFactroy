class ApplicationController < ActionController::Base
  def lock_object
    @object.lock!
  end
end
