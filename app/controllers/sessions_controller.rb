class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create create_anonymous ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def create
    resume_session
    puts "😅 Current session #{Current.session.inspect}"
    if Current.session&.user&.anonymous?
      user = Current.session.user
      user.password = params[:password]
      user.email_address = params[:email_address]
      user.save
      user = User.authenticate_by(
        uid: Current.session.user.uid,
        password: params[:password],
        email_address: params[:email_address]
      )
      puts "😅 User: #{user.inspect}"
      if user
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream:
            [
              turbo_stream.update("user_content",
                template: "pets/_user_content",
                locals: { user: user }
              )
              # turbo_stream.append_all("body", "<script>document.getElementById('my-popover').hidePopover();</script>")
            ]
          end
        end
      else
        flash.now[:alert] = "Try another email address or password."
        render partial: "shared/create_account", status: :unprocessable_entity
      end
    else
      if user = User.authenticate_by(params.permit(:email_address, :password))
        start_new_session_for user
        redirect_to after_authentication_url
      else
        redirect_to new_session_path, alert: "Try another email address or password."
      end
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  def create_anonymous
    user = User.create_anonymous!
    start_new_session_for user
    redirect_to after_authentication_url
  end
end
