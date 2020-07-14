module Comments
  class Load < ServiceApplication
    param :options

    attr_reader :comments

    POSSIBLE_ORDERS = %w[order_by_likes order_by_created].freeze

    def call
      normalize_options

      @comments = Comment.includes(:rates, :images, :comments).all
      search_by_user
      search_by_post
      search_by_date
      order
      search_by_rating
      comments
    end

    private

    def normalize_options
      options[:order] = POSSIBLE_ORDERS.include?(options[:order]) ? options[:order] : nil
      options[:rating] = options[:rating].to_i
      normalize_date
    end

    def normalize_date
      options[:date_start] = validate_date(options[:date_start]) if options[:date_start]
      options[:date_end] = validate_date(options[:date_end]) if options[:date_end]
    end

    def order
      @comments = comments.send(options[:order]) if options[:order]
    end

    def search_by_user
      @comments = comments.where(user_id: options[:find_user_id]) if options[:find_user_id]
    end

    def search_by_post
      @comments = comments.where(commentable_id: options[:post_id], commentable_type: 'Post') if options[:post_id]
    end

    def search_by_date
      @comments = comments.where('comments.created_at >= ?', options[:date_start]) if options[:date_start]
      @comments = comments.where('comments.created_at <= ?', options[:date_end]) if options[:date_end]
    end

    def search_by_rating
      @comments = comments.select { |comment| comment if comment.rating >= options[:rating] } if options[:rating]
      @comments = Comment.where(id: comments.map(&:id))
    end

    def validate_date(date)
      Date.parse(date)
    rescue ArgumentError
      nil
    end
  end
end
