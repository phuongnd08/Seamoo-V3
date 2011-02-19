module LeaguesHelper
  def javascript_templates(arr)
    arr.inject({}) do |hash, template|
      hash[template] = render("matches/#{template}")
      hash
    end.to_json
  end
end
