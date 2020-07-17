module Comments
  class Load < ServiceApplication
    param :options

    attr_reader :comments

    POSSIBLE_ORDERS = %w[order_by_likes order_by_created].freeze

    def call
      normalize_options

      @comments = Comment.includes(:rates, :images, :comments).all
      search = Comment.search do
        all_of do
          with :user_id, options[:find_user_id] if options[:find_user_id]
          with :commentable_type, 'Post' if options[:commentable_id]
          with :commentable_id, options[:commentable_id] if options[:commentable_id]
          with(:created_at).greater_than(options[:date_start]) if options[:date_start]
          with(:created_at).less_than(options[:date_end]) if options[:date_end]
          with(:rating).greater_than(options[:rating]) if options[:rating]
        end
      end

      @comments = search.results
      @comments = Comment.where(id: comments.map(&:id))
      order
      comments
    end

    private

    def normalize_options
      options[:order] = POSSIBLE_ORDERS.include?(options[:order]) ? options[:order] : nil
      options[:rating] = options[:rating].to_i if options[:rating]
      normalize_dates
    end

    def normalize_dates
      options[:date_start] = validate_date(options[:date_start]) if options[:date_start]
      options[:date_end] = validate_date(options[:date_end]) if options[:date_end]
    end

    def order
      @comments = comments.send(options[:order]) if options[:order]
    end

    def validate_date(date)
      Date.parse(date)
    rescue ArgumentError
      nil
    end
  end
end
