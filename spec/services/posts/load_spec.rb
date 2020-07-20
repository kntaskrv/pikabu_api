require 'rails_helper'

describe Posts::Load do
  subject { described_class.call(options) }

  let(:user) { create(:user) }
  let(:options) { {} }

  context 'when options is empty' do
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }
    let!(:post3) { create(:post) }

    it 'returns posts id' do
      Post.reindex
      expect(subject.ids).to eq [post1.id, post2.id, post3.id]
    end
  end

  context 'when options not empty' do
    context 'with title' do
      let!(:post1) { create(:post, title: 'my post') }
      let!(:post2) { create(:post, title: 'super') }
      let!(:post3) { create(:post, title: 'title') }

      before do
        options[:title] = 'title'
        Post.reindex
      end

      it 'returns posts id' do
        expect(subject.ids).to eq [post3.id]
      end
    end

    context 'with tags' do
      let!(:post1) { create(:post) }
      let!(:post2) { create(:post) }
      let!(:post3) { create(:post) }

      before do
        tag = create(:tag)
        post1.tags << tag
        options[:tags] = [tag.tag]
        Post.reindex
      end

      it 'returns posts id' do
        expect(subject.ids).to eq [post1.id]
      end
    end

    context 'with date' do
      let!(:post1) { create(:post, created_at: Time.now - 2.days) }
      let!(:post2) { create(:post) }
      let!(:post3) { create(:post, created_at: Time.now + 3.days) }

      before do
        options[:date_start] = Date.current.to_s
        options[:date_end] = (Date.current + 1).to_s
        Post.reindex
      end

      it 'returns posts id' do
        expect(subject.ids).to eq [post2.id]
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
        expect(subject.ids).to eq [post1.id]
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
        expect(subject.ids).to eq [post1.id]
      end
    end
  end
end
