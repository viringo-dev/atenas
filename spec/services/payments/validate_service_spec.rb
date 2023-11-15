require 'rails_helper'

RSpec.describe Payments::ValidateService, type: :service do
  subject { Payments::ValidateService.new(payment: payment).call }

  let(:payment) { create(:payment) }

  it 'validates the payment' do
    expect { subject }.to change { payment.reload.validated? }.from(false).to(true)
    expect(subject.success?).to be_truthy
  end

  context 'when the task is bided' do
    let(:task) { create(:task, status: :bided) }
    let(:payment) { create(:payment, bid: create(:bid, task: task)) }

    it 'does not validate the payment' do
      expect { subject }.not_to change { payment.reload.validated? }
      expect(subject.success?).to be_falsey
    end
  end

  context 'when the task is paused' do
    let(:task) { create(:task, status: :paused) }
    let(:payment) { create(:payment, bid: create(:bid, task: task)) }

    it 'does not validate the payment' do
      expect { subject }.not_to change { payment.reload.validated? }
      expect(subject.success?).to be_falsey
    end
  end

  context 'when the bid is offered' do
    let(:bid) { create(:bid, status: :offered) }
    let(:payment) { create(:payment, bid: bid) }

    it 'does not validate the payment' do
      expect { subject }.not_to change { payment.reload.validated? }
      expect(subject.success?).to be_falsey
    end
  end
end
