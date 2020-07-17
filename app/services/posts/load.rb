module Posts
  class Load < ServiceApplication
    param :options

    attr_reader :posts

    POSSIBLE_ORDERS = %w[order_by_likes order_by_created].freeze
    POSSIBLE_FILTERS = %w[hot best fresh].freeze

    def call
      normalize_options

      search = Post.search do
        all do
          fulltext options[:title] { fields(:title) } if options[:title]
        end

        all_of do
          with :tag_names, options[:tags] if options[:tags]
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
      options[:rating] = options[:rating].to_i if options[:rating]
      options[:tags] = options[:tags].values if options[:tags] && options[:tags].is_a?(Hash)
      normalize_dates
    end

    def normalize_dates
      options[:date_start] = validate_date(options[:date_start]) if options[:date_start]
      options[:date_end] = validate_date(options[:date_end]) if options[:date_end]
    end

    def validate_date(date)
      Date.parse(date)
    rescue ArgumentError
      nil
    end

    def order
      @posts = @posts.send(options[:order]) if options[:order]
    end
  end
end
