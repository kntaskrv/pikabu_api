module Comments
  class Load < ServiceApplication
    param :options

    def call
      comments = Comment.all
      comments = comments.where(user_id: options[:find_user_id]) if options[:find_user_id]
      comments = comments.where(commentable_id: options[:post_id], commentable_type: 'Post') if options[:post_id]
      comments = comments.where('comments.created_at >= ?', options[:date_start]) if options[:date_start]
      comments = comments.where('comments.created_at <= ?', options[:date_end]) if options[:date_end]
      comments = comments.map { |comment| comment if comment.rating >= options[:rating].to_i } if options[:rating]
      comments = Comment.where(id: comments.map(&:id)) if options[:rating]
      comments
    end
  end
end
