module Comments
  class Load < ServiceApplication
    param :options

    attr_reader :comments

    def call
      @comments = Comment.includes(:rates, :images, :comments).all
      search_by_user
      search_by_post
      seacrh_by_date
      order
      search_by_rating
      comments
    end

    private

    def order
      @comments = comments.send(params[:order]) if options[:order]
    end

    def search_by_user
      @comments = comments.where(user_id: options[:find_user_id]) if options[:find_user_id]
    end

    def search_by_post
      @comments = comments.where(commentable_id: options[:post_id], commentable_type: 'Post') if options[:post_id]
    end

    def seacrh_by_date
      @comments = comments.where('comments.created_at >= ?', options[:date_start]) if options[:date_start]
      @comments = comments.where('comments.created_at <= ?', options[:date_end]) if options[:date_end]
    end

    def search_by_rating
      @comments = comments.select { |comment| comment if comment.rating >= options[:rating].to_i } if options[:rating]
    end
  end
end
