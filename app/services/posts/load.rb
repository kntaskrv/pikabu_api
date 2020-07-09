module Posts
  class Load < ServiceApplication
    param :options

    attr_reader :posts

    POSIBLE_ORDERS = %w[order_by_likes order_by_created].freeze
    POSIBLE_FILTERS = %w[hot best fresh].freeze

    def call
      normalize_options

      @posts = Post.includes(:rates, :images, :tags, :comments).all
      search_by_tags
      search_by_date
      filter
      order
      search_by_rating
      posts
    end

    private

    def normalize_options
      options[:order] = POSIBLE_ORDERS.include?(options[:order]) ? options[:order] : nil
      options[:filter] = POSIBLE_FILTERS.includes?(options[:filter]) ? options[:filter] : nil
      options[:rating] = options[:rating].to_i
      normalize_date
    end

    def normalize_date
      options[:date_start] = validate_date(options[:date_start]) if options[:date_start]
      options[:date_start] = validate_date(options[:date_end]) if options[:date_end]
    end

    def validate_date(date)
      Date.parse(date)
    rescue ArgumentError
      nil
    end

    def filter
      @posts = posts.send(params[:filter]) if options[:filter]
    end

    def order
      @posts = @posts.send(params[:order]) if options[:order]
    end

    def search_by_tags
      @posts = posts.left_joins(:tags).where(tags: { tag: options[:tags] }).distinct if options[:tags]
    end

    def search_by_date
      @posts = posts.where('posts.created_at >= ?', options[:date_start]) if options[:date_start]
      @posts = posts.where('posts.created_at <= ?', options[:date_end]) if options[:date_end]
    end

    def search_by_rating
      @posts = posts.select { |post| post if post.rating >= options[:rating].to_i } if options[:rating]
    end
  end
end
