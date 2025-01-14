class PetsController < ApplicationController
  allow_anonymous_access only: %i[ index ]

  def index
    @user_uid = Current.session.user.uid
  end
end
