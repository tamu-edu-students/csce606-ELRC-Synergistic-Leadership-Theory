# frozen_string_literal: true

# ./app/controllers/auth0_controller.rb
class Auth0Controller < ApplicationController
  def callback
    # OmniAuth stores the information returned from Auth0 and the IdP in request.env['omniauth.auth'].
    # In this code, you will pull the raw_info supplied from the id_token and assign it to the session.
    # Refer to https://github.com/auth0/omniauth-auth0/blob/master/EXAMPLES.md#example-of-the-resulting-authentication-hash for complete information on 'omniauth.auth' contents.

    auth_info = request.env['omniauth.auth']
    # puts JSON.pretty_generate(auth_info)
    session[:userinfo] = auth_info['extra']['raw_info']

    # print session info in pretty JSON format
    # puts JSON.pretty_generate(session[:userinfo])

    # create new survey profile if the user is 'new'
    # if no survey profile contains unique user_id, create a new survey profile
    # puts 'trying to find survey profile'
    # puts SurveyProfile.find_by(user_id: session[:userinfo]['sub'])

    if SurveyProfile.find_by(user_id: session[:userinfo]['sub']).nil?
      redirect_to new_survey_profile_path
    elsif session[:invitation] && claim_invitation
      # Nothing to do here, claim_invitation already did the redirect
    else
      # Redirect to the URL you want after successful auth
      redirect_to root_url
    end
  end

  def failure
    # Handles failed authentication -- Show a failure page (you can also handle with a redirect)
    @error_msg = request.params['message']
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: AUTH0_CONFIG['auth0_client_id']
    }

    URI::HTTPS.build(host: AUTH0_CONFIG['auth0_domain'], path: '/v2/logout', query: request_params.to_query).to_s
  end

  def claim_invitation
    temporary_invitation_session_var = session[:invitation]

    if temporary_invitation_session_var && temporary_invitation_session_var['expiration'] > Time.now
      invitation = Invitation.find_by(id: temporary_invitation_session_var['from'])
      if invitation
        sharecode_from_invitation = invitation.parent_response.share_code
        survey_profile = SurveyProfile.find_by(user_id: session[:userinfo]['sub'])
        new_response_to_fill = SurveyResponse.create(profile: survey_profile, share_code: sharecode_from_invitation)
        invitation.update(claimed_by_id: survey_profile.id, response_id: new_response_to_fill.id)
        redirect_to edit_survey_response_path(new_response_to_fill)
        return true
      end
    end

    session.delete(:invitation)
    false
  end
end
