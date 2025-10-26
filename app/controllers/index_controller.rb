class IndexController < ApplicationController
  before_action :user_request_init,   only: %i[index]

  def index

  end

  private

    def user_request_init
      @user_request = UserRequest.new
    end

end
