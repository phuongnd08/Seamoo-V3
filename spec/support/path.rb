def path_of url
  URI.parse(url).path
end

def current_path
  path_of(current_url)
end
