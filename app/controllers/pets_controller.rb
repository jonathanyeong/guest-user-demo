class PetsController < ApplicationController
  allow_anonymous_access only: %i[ index ]

  def index
    @user = Current.session.user
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("user_content", partial: "user_content") }
    end
  end
end
