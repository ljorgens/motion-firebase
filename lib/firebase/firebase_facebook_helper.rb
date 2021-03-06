# see https://www.firebase.com/docs/ios/guide/login/facebook.html for more info
# (that's where this code came from)
class Firebase
  def self.open_facebook_session(options={}, &block)
    self.new.open_facebook_session(options={}, &block)
  end

  def open_facebook_session(options={}, &block)
    ref = self
    permissions = options[:permissions] || ['email']
    fb_login = FBSDKLoginManager.alloc.init
    fb_login.logInWithReadPermissions(permissions, 
      handler: -> (facebookResult, facebookError) do
        if facebookError
          block.call(facebookError, nil)
        elsif facebookResult.isCancelled
          block.call("Facebook login got cancelled.", nil)
        else
          access_token = FBSDKAccessToken.currentAccessToken.tokenString

          ref.authWithOAuthProvider('facebook', token: access_token, withCompletionBlock:block)
        end
      end)
    nil
  end
end
