require 'rails_helper'

describe Comments::Load do
  subject { described_class.call(options) }

  let(:user) { create(:user) }
  let(:options) { {} }

  context 'when options is empty' do
    let!(:comment1) { create(:post_comment) }
    let!(:comment2) { create(:post_comment) }
    let!(:comment3) { create(:post_comment) }

    it 'returns comments id' do
      Comment.reindex
      expect(subject.ids).to eq [comment1.id, comment2.id, comment3.id]
    end
  end

  context 'when options not empty' do
    context 'with user' do
      let!(:comment1) { create(:post_comment) }
      let!(:comment2) { create(:post_comment) }
      let!(:comment3) { create(:post_comment) }

      before do
        options[:find_user_id] = comment1.user_id
        Comment.reindex
      end

      it 'returns comments id' do
        expect(subject.ids).to eq [comment1.id]
      end
    end

    context 'with post' do
      let!(:comment1) { create(:post_comment) }
      let!(:comment2) { create(:post_comment) }
      let!(:comment3) { create(:post_comment) }

      before do
        options[:commentable_id] = comment1.commentable_id
        Comment.reindex
      end

      it 'returns comments id' do
        expect(subject.ids).to eq [comment1.id]
      end
    end

    context 'with date' do
      let!(:comment1) { create(:post_comment, created_at: Time.now - 2.days) }
      let!(:comment2) { create(:post_comment) }
      let!(:comment3) { create(:post_comment, created_at: Time.now + 3.days) }

      before do
        options[:date_start] = Date.current.to_s
        options[:date_end] = (Date.current + 1).to_s
        Comment.reindex
      end

      it 'returns comments id' do
        expect(subject.ids).to eq [comment2.id]
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
        expect(subject.ids).to eq [comment1.id]
      end
    end
  end
end
