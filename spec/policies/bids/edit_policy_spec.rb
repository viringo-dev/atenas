require 'rails_helper'

RSpec.describe Bids::EditPolicy, type: :policy do
  subject { Bids::EditPolicy.new(user: user, bid: bid).allowed? }

  let(:task) { build(:task) }
  let(:user) { build(:confirmed_user) }
  let(:bid) { build(:bid, user: user, task: task) }

  it 'allows the user to edit the bid' do
    expect(subject).to be_truthy
  end

  context 'when the bid is not owned by the user' do
    let(:bid) { build(:bid, task: task) }

    it 'does not allow the user to edit the bid' do
      expect(subject).to be_falsey
    end
  end

  context 'when the bid is not offered' do
    let(:bid) { build(:bid, user: user, task: task, status: :accepted) }

    it 'does not allow the user to edit the bid' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is not bidable' do
    let(:task) { build(:task, user: user, status: :assigned) }

    it 'does not allow the user to edit the bid' do
      expect(subject).to be_falsey
    end
  end
end
