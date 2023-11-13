require 'rails_helper'

RSpec.describe Bids::AcceptService, type: :service do
  subject { Bids::AcceptService.new(user: user, task: task, bid: bid).call }

  let(:user) { create(:confirmed_user) }
  let(:task) { create(:task, user: user) }
  let(:bid) { create(:bid, task: task) }

  it 'accepts the bid' do
    expect { subject }.to change { bid.reload.accepted? }.from(false).to(true)
    expect(subject.success?).to be_truthy
  end

  context 'when the task is not bided' do
    let(:task) { create(:task, user: user, status: :unpaid) }

    it 'does not accept the bid' do
      expect { subject }.not_to change { bid.reload.accepted? }
      expect(subject.success?).to be_falsey
    end
  end

  context 'when the task is not owned by the user' do
    let(:task) { create(:task) }

    it 'does not accept the bid' do
      expect { subject }.not_to change { bid.reload.accepted? }
      expect(subject.success?).to be_falsey
    end
  end

  context 'when the bid is not offered' do
    let(:bid) { create(:bid, task: task, status: :accepted) }

    it 'does not accept the bid' do
      expect { subject }.not_to change { bid.reload.accepted? }
      expect(subject.success?).to be_falsey
    end
  end

  context 'when the bid is not for the task' do
    let(:bid) { create(:bid) }

    it 'does not accept the bid' do
      expect { subject }.not_to change { bid.reload.accepted? }
      expect(subject.success?).to be_falsey
    end
  end
end
