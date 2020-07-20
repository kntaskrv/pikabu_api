require 'rails_helper'

describe Posts::Load do
  subject { described_class.call(options) }

  let(:user) { create(:user) }
  let(:options) { {} }

  context 'when options is empty' do
    before do
      create(:post)
      create(:post)
      create(:post)
      Post.reindex
    end

    it 'returns posts id' do
      expect(subject.ids).to eq [18, 19, 20]
    end
  end

  context 'when options not empty' do
    context 'with title' do
      before do
        create(:post, title: 'my post')
        create(:post, title: 'super')
        create(:post, title: 'title')
        options[:title] = 'title'
        Post.reindex
      end

      it 'returns posts id' do
        expect(subject.ids).to eq [23]
      end
    end

    context 'with tags' do
      before do
        post = create(:post)
        create(:post)
        create(:post)
        tag = create(:tag)
        post.tags << tag
        options[:tags] = [tag.tag]
        Post.reindex
      end

      it 'returns posts id' do
        expect(subject.ids).to eq [24]
      end
    end

    context 'with date' do
      let!(:post1) { create(:post) }
      let!(:post2) { create(:post) }
      let!(:post3) { create(:post) }

      before do
        post1.created_at = Time.now - 2.days
        post3.created_at = Time.now + 3.days
        post1.save
        post3.save
        options[:date_start] = Date.current.to_s
        options[:date_end] = (Date.current + 1).to_s
        Post.reindex
      end

      it 'returns posts id' do
        expect(subject.ids).to eq [28]
      end
    end

    context 'with rating' do
      let!(:post1) { create(:post) }
      let!(:post2) { create(:post) }
      let!(:post3) { create(:post) }

      before do
        post1.rates.create(user: user, status: 'like')
        options[:rating] = 0
        Post.reindex
      end

      it 'returns posts id' do
        expect(subject.ids).to eq [30]
      end
    end

    context 'with filter' do
      let!(:post1) { create(:post, hot: true) }
      let!(:post2) { create(:post, hot: false) }

      before do
        options[:filter] = 'hot'
        Post.reindex
      end

      it 'returns posts id' do
        expect(subject.ids).to eq [33]
      end
    end
  end
end
