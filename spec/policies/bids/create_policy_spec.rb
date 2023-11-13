require 'rails_helper'

RSpec.describe Bids::CreatePolicy, type: :policy do
  subject { Bids::CreatePolicy.new(user: user, task: task).allowed? }

  let(:task) { build(:task) }
  let(:user) { build(:confirmed_user) }

  it 'allows the user to create a bid' do
    expect(subject).to be_truthy
  end

  context 'when the task is not bided' do
    let(:task) { build(:task, status: :unpaid) }

    it 'does not allow the user to create a bid' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is owned by the user' do
    let(:task) { build(:task, user: user) }

    it 'does not allow the user to create a bid' do
      expect(subject).to be_falsey
    end
  end

  context 'when the user already bided the task' do
    let(:bid) { build(:bid, user: user, task: task) }
    before { user.save; bid.save } 

    it 'does not allow the user to create a bid' do
      expect(subject).to be_falsey
    end
  end
end
