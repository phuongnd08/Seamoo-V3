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
      root_path
    when /the show category "([^"]+)" page/
      category_path(Category.find_by_name($1))
    when /the show league "([^"]+)" page/
      league_path(League.find_by_name($1))
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
    case url_name

    when /the home\s? url/
      root_url(:host => TestEnv.host)
    when /the show category "([^"]+)" url/
      category_url(Category.find_by_name($1), :host => TestEnv.host)
    when /the show league "([^"]+)" url/
      league_url(League.find_by_name($1), :host => TestEnv.host)
      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

    else
      begin
        url_name =~ /the (.*) url/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('url').join('_').to_sym, :host => TestEnv.host)
      rescue Object => e
        p e
        raise "Can't find mapping from \"#{url_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end

end

World(NavigationHelpers)
