require 'rails_helper'

RSpec.describe Ratings::CreatePolicy, type: :policy do
  subject { described_class.new(user: user, bid: bid).allowed? }

  let!(:user) { create(:confirmed_user) }
  let!(:bid) { create(:paid_bid, user: user) }

  it 'allows the user to create a rating' do
    expect(subject).to be_truthy
  end

  context 'when the bid is not paid' do
    let!(:bid) { create(:finished_bid) }

    it 'does not allow the user to create a rating' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is not finished' do
    let!(:bid) { create(:paid_bid, task: create(:assigned_task), user: user) }

    it 'does not allow the user to create a rating' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is not owned by the user nor assigned to the user' do
    let!(:bid) { create(:paid_bid) }

    it 'does not allow the user to create a rating' do
      expect(subject).to be_falsey
    end
  end

  context "when asignee already rated the task" do
    let!(:rating) { create(:rating, :task_assignee, bid: bid, user: bid.user) }

    it 'does not allow the user to create a rating' do
      expect(subject).to be_falsey
    end
  end

  context "when owner already rated the task" do
    let!(:task) { create(:finished_task, user: user) }
    let!(:bid) { create(:paid_bid, task: task) }
    let!(:rating) { create(:rating, :task_owner, bid: bid, user: task.user) }

    it 'does not allow the user to create a rating' do
      expect(subject).to be_falsey
    end
  end
end
