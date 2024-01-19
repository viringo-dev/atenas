require 'rails_helper'

RSpec.describe Cashouts::CreatePolicy, type: :policy do
  subject { Cashouts::CreatePolicy.new(user: user, bid: bid).allowed? }

  let(:user) { create(:confirmed_user) }
  let(:task) { create(:finished_task) }
  let(:bid) { create(:finished_bid, task: task, user: user) }

  it 'allows the user to create a cashout' do
    expect(subject).to be_truthy
  end

  context 'when the bid is not finished' do
    let(:bid) { create(:bid, task: task, status: :accepted) }

    it 'does not allow the user to create a cashout' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is not finished' do
    let(:task) { create(:task, user: user, status: :assigned) }

    it 'does not allow the user to create a cashout' do
      expect(subject).to be_falsey
    end
  end

  context 'when the bid is not owned by the user' do
    let(:bid) { create(:finished_bid, task: task) }

    it 'does not allow the user to create a cashout' do
      expect(subject).to be_falsey
    end
  end

  context 'when the cashout was already transferred' do
    let(:cashout) { create(:cashout, bid: bid) }

    it 'does not allow the user to create a cashout' do
      cashout.reload
      expect(subject).to be_falsey
    end
  end
end
