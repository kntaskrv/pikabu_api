module Posts
  class Load < ServiceApplication
    param :options

    attr_reader :posts

    def call
      @posts = Post.all
      search_by_tags
      search_by_date
      search_by_rating
      posts
    end

    private

    def search_by_tags
      @posts = posts.left_joins(:tags).where(tags: { tag: options[:tags] }).distinct if options[:tags]
    end

    def search_by_date
      @posts = posts.where('posts.created_at >= ?', options[:date_start]) if options[:date_start]
      @posts = posts.where('posts.created_at <= ?', options[:date_end]) if options[:date_end]
    end

    def search_by_rating
      @posts = posts.map { |post| post if post.rating >= options[:rating].to_i }.compact if options[:rating]
      @posts = Post.where(id: posts.map(&:id)) if options[:rating]
    end
  end
end
