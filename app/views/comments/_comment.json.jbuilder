json.extract! comment, :id, :content, :user_id, :is_published, :article_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
