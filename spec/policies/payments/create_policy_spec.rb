require 'rails_helper'

RSpec.describe Payments::CreatePolicy, type: :policy do
  subject { Payments::CreatePolicy.new(user: user, bid: bid).allowed? }

  let(:user) { create(:confirmed_user) }
  let(:task) { create(:task, user: user, status: :unpaid) }
  let(:bid) { create(:bid, task: task, status: :accepted) }

  it 'allows the user to create a payment' do
    expect(subject).to be_truthy
  end

  context 'when the bid is not accepted' do
    let(:bid) { create(:bid, task: task, status: :offered) }

    it 'does not allow the user to create a payment' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is not unpaid' do
    let(:task) { create(:task, user: user, status: :assigned) }

    it 'does not allow the user to create a payment' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is not owned by the user' do
    let(:task) { create(:task, status: :unpaid) }

    it 'does not allow the user to create a payment' do
      expect(subject).to be_falsey
    end
  end

  context 'when the bid is not for the task' do
    let(:bid) { create(:bid) }

    it 'does not allow the user to create a payment' do
      expect(subject).to be_falsey
    end
  end

  context 'when the bid was already paid' do
    let(:payment) { create(:payment, bid: bid) }

    it 'does not allow the user to create a payment' do
      payment.reload
      expect(subject).to be_falsey
    end
  end
end
