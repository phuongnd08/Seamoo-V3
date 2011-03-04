module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /"(http\:\/\/.+)"$/
      $1

    when /^the (.+) url$/
      url_to(page_name)

    when /the home\s?page/
      '/'

    when /the home\s?page/
      root_path
    when /the category ([^"]+) page/
      category_path(Category.find_by_name($1))
    when /the league (\w+) page/
      league_path(League.find_by_name($1))
    when /the match result of first match page$/
      match_path(Match.first)

      # the following are examples using path_to_pickle

    when /^#{capture_model}(?:'s)? page$/                           # eg. the forum's page
      path_to_pickle $1

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   # eg. the forum's post's page
      path_to_pickle $1, $2

    when /^#{capture_model}(?:'s)? #{capture_model}'s (.+?) page$/  # eg. the forum's post's comments page
      path_to_pickle $1, $2, :extra => $3                           #  or the forum's post's edit page

    when /^#{capture_model}(?:'s)? (.+?) page$/                     # eg. the forum's posts page
      path_to_pickle $1, :extra => $2                               #  or the forum's edit page

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
          path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end

  def url_to(url_name)
    url = path_to(url_name.replace(/\surl$/, ' page'))
    url = TestEnv.host + url unless  url.start_with?('http://')
    url
  end

end

World(NavigationHelpers)
