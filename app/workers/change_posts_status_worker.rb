class ChangePostsStatusWorker
  include Sidekiq::Worker

  def perform
    Post.where(hot: true).update(hot: false)
    Post.where(best: true).update(best: false)

    post_ids = Comment.where(commentable_type: 'Post').distinct.pluck(:commentable_id)
    Post.where(id: post_ids).update(hot: true)

    post_ids = Rate.where(rateable_type: 'Post').distinct.pluck(:rateable_id)
    Post.where(id: post_ids).update(best: true)
  end
end
