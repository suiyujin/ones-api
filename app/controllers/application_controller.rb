class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  def make_articles_hash(articles, voter)
    articles_hash = articles.map do |article|
      article_hash = article.attributes
      article_hash['published_at'] = article_hash['published_at'].strftime("%Y/%m/%d")
      vote_type = voter.voted_as_when_voted_for(article)
      if vote_type.nil?
        article_hash['vote_type'] = 2
      elsif vote_type
        article_hash['vote_type'] = 0
      else
        article_hash['vote_type'] = 1
      end

      article_hash['good_count'] = article.get_likes.size
      article_hash['bad_count'] = article.get_dislikes.size

      article_hash['comments'] = article.comments.map do |comment|
        {
          name: comment.user.name,
          text: comment.comment
        }
      end

      article_hash['user_name'] = article.user.name
      article_hash['hobby_name'] = article.hobby.name

      article_hash
    end
    articles_hash
  end
end
