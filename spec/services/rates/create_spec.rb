require 'rails_helper'

describe Rates::Create do
  subject { described_class.call(user, params) }

  let(:user) { create(:user) }
  let(:params) { {} }

  context 'when valid data' do
    context 'when rate not exist' do
      before do
        post = create(:post)
        params[:rateable_id] = post.id
        params[:rateable_type] = post.class.name
        params[:status] = 'like'
      end

      it 'changes rates count' do
        expect { subject }.to change { Rate.count }.by(1)
      end

      it 'returns empty errors' do
        expect(subject[:errors]).to eq({})
      end

      it 'returns message' do
        expect(subject[:message]).to eq 'Rate created'
      end
    end

    context 'when rate exist' do
      context 'with same rate' do
        before do
          rate = create(:post_rate, user: user)
          params[:rateable_id] = rate.rateable.id
          params[:rateable_type] = rate.rateable.class.name
          params[:status] = rate.status
        end

        it 'changes rates count' do
          expect { subject }.not_to change { Rate.count }
        end

        it 'returns empty errors' do
          expect(subject[:errors]).to eq({})
        end

        it 'returns message' do
          expect(subject[:message]).to eq 'The same rate already exist'
        end
      end

      context 'with diff rate' do
        before do
          rate = create(:post_rate, user: user)
          params[:rateable_id] = rate.rateable.id
          params[:rateable_type] = rate.rateable.class.name
          params[:status] = 'dislike'
        end

        it 'changes rates count' do
          expect { subject }.to change { Rate.count }.by(-1)
        end

        it 'returns empty errors' do
          expect(subject[:errors]).to eq({})
        end

        it 'returns message' do
          expect(subject[:message]).to eq 'Rate deleted'
        end
      end
    end
  end

  context 'when invalid data' do
    before do
      post = create(:post)
      params[:rateable_id] = post.id
      params[:rateable_type] = 'sfa'
      params[:status] = 'gsdges'
    end

    it 'changes rates count' do
      expect { subject }.not_to change { Rate.count }
    end

    it 'returns empty errors' do
      expect(subject[:errors]).to eq({ status: "Wrong status", type: "Wrong type" })
    end

    it 'returns empty message' do
      expect(subject[:message]).to eq({})
    end
  end
end
