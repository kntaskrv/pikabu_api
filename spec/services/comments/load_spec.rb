require 'rails_helper'

describe Comments::Load do
  subject { described_class.call(options) }

  let(:user) { create(:user) }
  let(:options) { {} }

  context 'when options is empty' do
    before do
      create(:post_comment)
      create(:post_comment)
      create(:post_comment)
      Comment.reindex
    end

    it 'returns comments id' do
      expect(subject.ids).to eq [1, 2, 3]
    end
  end

  context 'when options not empty' do
    context 'with user' do
      before do
        comment = create(:post_comment)
        create(:post_comment)
        create(:post_comment)
        options[:find_user_id] = comment.user_id
        Comment.reindex
      end

      it 'returns comments id' do
        expect(subject.ids).to eq [4]
      end
    end

    context 'with post' do
      before do
        comment = create(:post_comment)
        create(:post_comment)
        create(:post_comment)
        options[:commentable_id] = comment.commentable_id
        Comment.reindex
      end

      it 'returns comments id' do
        expect(subject.ids).to eq [7]
      end
    end

    context 'with date' do
      let!(:comment1) { create(:post_comment) }
      let!(:comment2) { create(:post_comment) }
      let!(:comment3) { create(:post_comment) }

      before do
        comment1.created_at = Time.now - 2.days
        comment3.created_at = Time.now + 3.days
        comment1.save
        comment3.save
        options[:date_start] = Date.current.to_s
        options[:date_end] = (Date.current + 1).to_s
        Comment.reindex
      end

      it 'returns comments id' do
        expect(subject.ids).to eq [11]
      end
    end

    context 'with rating' do
      let!(:comment1) { create(:post_comment) }
      let!(:comment2) { create(:post_comment) }
      let!(:comment3) { create(:post_comment) }

      before do
        comment1.rates.create(user: user, status: 'like')
        options[:rating] = 0
        Comment.reindex
      end

      it 'returns comments id' do
        expect(subject.ids).to eq [13]
      end
    end
  end
end
