json.array!(@articles) do |article|
  json.extract! article, :id, :title, :image_path, :contents, :view_count, :point, :published_at, :user_id, :hobby_id
  json.url article_url(article, format: :json)
end
