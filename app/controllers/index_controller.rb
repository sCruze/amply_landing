class IndexController < ApplicationController
  before_action :user_request_init,   only: %i[index]

  def index
    init_meta("home")
  end

  def terms
    init_meta("terms")
  end

  def privacy
    init_meta("privacy")
  end

  private

    def user_request_init
      @user_request = UserRequest.new
    end

end
