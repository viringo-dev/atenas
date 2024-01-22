require 'rails_helper'

RSpec.describe Cashouts::ValidateService, type: :service do
  subject { Cashouts::ValidateService.new(cashout: cashout).call }

  let(:cashout) { create(:cashout) }

  it 'validates the cashout' do
    expect { subject }.to change { cashout.transferred? }.from(false).to(true)
                      .and change { cashout.bid.status }.from('finished').to('paid')
    expect(subject.success?).to be_truthy
  end

  context 'when the bid or task are not finished' do
    let(:bid) { create(:accepted_bid) }
    let(:cashout) { create(:cashout, bid: bid, task: bid.task) }

    it 'does not validate the cashout' do
      expect { subject }.not_to change { cashout.reload.transferred? }
      expect(subject.success?).to be_falsey
    end
  end

  context 'when transaction fails' do
    before { allow_any_instance_of(Cashout).to receive(:transferred!).and_raise(ActiveRecord::Rollback) }

    it 'does not validate the cashout' do
      expect { subject }.not_to change { cashout.reload.transferred? }
      expect(subject.success?).to be_falsey
    end
  end
end
