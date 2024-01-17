require 'rails_helper'

RSpec.describe Bids::FinishService, type: :service do
  subject { Bids::FinishService.new(user: user, bid: bid).call }

  let(:user) { create(:confirmed_user) }
  let(:task) { create(:assigned_task) }
  let(:bid) { create(:accepted_bid, task: task, user: user) }

  it 'accepts the bid' do
    expect { subject }.to change { bid.reload.finished? }.from(false).to(true)
    expect(subject.success?).to be_truthy
  end

  context 'when user is not the bid owner' do
    let(:bid) { create(:accepted_bid, task: task) }

    it 'does not finish the bid' do
      expect { subject }.not_to change { bid.reload.finished? }
      expect(subject.success?).to be_falsey
    end
  end

  context 'when user is not the task owner' do
    let(:task) { create(:assigned_task, user: create(:confirmed_user)) }
    let(:bid) { create(:accepted_bid, task: task) }

    it 'does not finish the task' do
      expect { subject }.not_to change { task.reload.finished? }
      expect(subject.success?).to be_falsey
    end
  end

  context "when user is task's owner" do
    let(:bid) { create(:accepted_bid, task: task) }

    context "when task is not assigned" do
      let(:task) { create(:unpaid_task, user: user) }

      it 'does not finish the task' do
        expect { subject }.not_to change { task.reload.finished? }
        expect(subject.success?).to be_falsey
      end
    end

    context "when task is assigned" do
      let(:task) { create(:assigned_task, user: user) }

      it 'finishes the task' do
        expect { subject }.to change { task.reload.finished? }
        expect(subject.success?).to be_truthy
      end
    end
  end

  context "when user is bid's owner" do
    let(:task) { create(:assigned_task) }

    context "when bid is not accepted" do
      let(:bid) { create(:bid, task: task, user: user) }

      it 'does not finish the bid' do
        expect { subject }.not_to change { bid.reload.finished? }
        expect(subject.success?).to be_falsey
      end
    end

    context "when bid is accepted" do
      let(:bid) { create(:accepted_bid, task: task, user: user) }

      it 'finishes the bid' do
        expect { subject }.to change { bid.reload.finished? }
        expect(subject.success?).to be_truthy
      end
    end
  end
end
