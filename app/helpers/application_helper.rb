module ApplicationHelper
  # Get standard states array.
  def get_states
    [['Alabama', 'AL'], ['Alaska', 'AK'], ['American Samoa', 'AS'], ['Arizona', 'AZ'], ['Arkansas', 'AR'], ['California', 'CA'], ['Colorado', 'CO'], ['Connecticut', 'CT'], ['Delaware', 'DE'], ['District of Columbia', 'DC'], ['Florida', 'FL'], ['Georgia', 'GA'], ['Guam', 'GU'], ['Hawaii', 'HI'], ['Idaho', 'ID'], ['Illinois', 'IL'], ['Indiana', 'IN'], ['Iowa', 'IA'], ['Kansas', 'KS'], ['Kentucky', 'KY'], ['Louisiana', 'LA'], ['Maine', 'ME'], ['Marshall Islands', 'MH'], ['Maryland', 'MD'], ['Massachusetts', 'MA'], ['Michigan', 'MI'], ['Minnesota', 'MN'], ['Mississippi', 'MS'], ['Missouri', 'MO'], ['Montana', 'MT'], ['Nebraska', 'NE'], ['Nevada', 'NV'], ['New Hampshire', 'NH'], ['New Jersey', 'NJ'], ['New Mexico', 'NM'], ['New York', 'NY'], ['North Carolina', 'NC'], ['North Dakota', 'ND'], ['Northern Marianas Islands', 'MP'], ['Ohio', 'OH'], ['Oklahoma', 'OK'], ['Oregon', 'OR'], ['Palau', 'PW'], ['Pennsylvania', 'PA'], ['Puerto Rico', 'PR'], ['Rhode Island', 'RI'], ['South Carolina', 'SC'], ['South Dakota', 'SD'], ['Tennessee', 'TN'], ['Texas', 'TX'], ['Utah', 'UT'], ['Vermont', 'VT'], ['Virgin Islands', 'VI'], ['Virginia', 'VA'], ['Washington', 'WA'], ['West Virginia', 'WV'], ['Wisconsin', 'WI'], ['Wyoming', 'WY']]
  end

  # Is the user authenticated?
  def authenticated?
    (session[:drupal_user_role] && session[:drupal_user_role].values.include?('authenticated user')) ? true : false
  end

  # Is the user an administrator?
  def admin?
    (session[:drupal_user_role] && session[:drupal_user_role].values.include?('administrator')) ? true : false
  end

  def fb_app_id
    ENV['facebook_app_id']
  end

  # Did the user already submit something?
  def already_submitted?
    user_id = session[:drupal_user_id]
    Rails.cache.fetch 'already-submitted-' + user_id.to_s do
      posts = Post.where(:uid => user_id)
      shares = Share.where(:uid => user_id)

      (user_id && (!shares.nil? && shares.count > 0 || !posts.nil? && posts.count > 0))
    end
  end
end
