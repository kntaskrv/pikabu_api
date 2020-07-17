class ChangePostsStatusWorker
  include Sidekiq::Worker

  def perform
    Post.where(hot: true).update_all(hot: false)
    Post.where(best: true).update_all(best: false)

    post_ids = Comment.where(commentable_type: 'Post').fresh.distinct.pluck(:commentable_id)
    Post.where(id: post_ids).update_all(hot: true)

    post_ids = Rate.where(rateable_type: 'Post').fresh.distinct.pluck(:rateable_id)
    Post.where(id: post_ids).update_all(best: true)
  end
end
