module Posts
  class Load < ServiceApplication
    param :options

    attr_reader :posts

    POSSIBLE_ORDERS = %w[order_by_likes order_by_created].freeze
    POSSIBLE_FILTERS = %w[hot best fresh].freeze

    def call
      normalize_options

      search = Post.search do
        fulltext options[:tags].values.join(' ') if options[:tags]
        all_of do
          with(:created_at).greater_than(options[:date_start]) if options[:date_start]
          with(:created_at).less_than(options[:date_end]) if options[:date_end]
          with(:rating).greater_than(options[:rating]) if options[:rating]
          with :hot, true if options[:filter] == 'hot'
          with :best, true if options[:filter] == 'best'
          with(:created_at).greater_than(Post.now - 1.day) if options[:filter] == 'fresh'
        end
      end

      @posts = search.results
      @posts = Post.where(id: posts.map(&:id))
      order
      posts
    end

    private

    def normalize_options
      options[:order] = POSSIBLE_ORDERS.include?(options[:order]) ? options[:order] : nil
      options[:filter] = POSSIBLE_FILTERS.include?(options[:filter]) ? options[:filter] : nil
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
      @posts = posts.send(options[:filter]) if options[:filter]
    end

    def order
      @posts = @posts.send(options[:order]) if options[:order]
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
      @posts = Post.where(id: posts.map(&:id))
    end
  end
end
