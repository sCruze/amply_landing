class UserRequestsController < ApplicationController
  def create
    @user_request = UserRequest.new(user_request_params)

    respond_to do |format|
      if @user_request.save
        UserRequestMailer.confirmation(@user_request.id).deliver_later
        UserRequestMailer.team_digest(@user_request.id).deliver_later

        @name = @user_request.name
        @user_request = UserRequest.new

        format.turbo_stream
        format.html { redirect_to root_path(anchor: "waitlist"), notice: t("waitlist.created") }
      else
        format.turbo_stream { render :create, status: :unprocessable_entity }
        format.html { render "index/index", status: :unprocessable_entity }
      end
    end
  end

  private

    def user_request_params
      params.require(:user_request).permit(:name, :email)
    end
end
