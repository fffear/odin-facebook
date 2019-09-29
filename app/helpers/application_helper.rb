module ApplicationHelper
  def require_login
    if !user_signed_in?
      flash[:alert] = "Please sign in."
      redirect_to new_user_session_url
    end
  end

  def require_poster_to_be_current_user
    if params[:user_id].to_i != current_user.id
      flash[:alert] = "Can't create post as another person"
      redirect_back fallback_location: new_user_session_url
    end
  end
end
