require 'rails_helper'

RSpec.describe Tasks::EditPolicy, type: :policy do
  subject { Tasks::EditPolicy.new(user: user, task: task).allowed? }

  let(:user) { build(:confirmed_user) }
  let(:task) { build(:task, user: user) }

  it 'allows the user to edit the task' do
    expect(subject).to be_truthy
  end

  context 'when the task is not owned by the user' do
    let(:task) { build(:task) }

    it 'does not allow the user to edit the task' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is bided' do
    let(:task) { build(:task, user: user, status: :bided) }

    it 'allows the user to edit the task' do
      expect(subject).to be_truthy
    end
  end

  context 'when the task is paused' do
    let(:task) { build(:task, user: user, status: :paused) }

    it 'allows the user to edit the task' do
      expect(subject).to be_truthy
    end
  end

  context 'when the task is unpaid' do
    let(:task) { build(:task, user: user, status: :unpaid) }

    it 'allows the user to edit the task' do
      expect(subject).to be_truthy
    end
  end

  context 'when the task is paid' do
    let(:task) { build(:task, user: user, status: :assigned) }

    it 'does not allow the user to edit the task' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is finished' do
    let(:task) { build(:task, user: user, status: :finished) }

    it 'does not allow the user to edit the task' do
      expect(subject).to be_falsey
    end
  end

  context 'when the task is unfinished' do
    let(:task) { build(:task, user: user, status: :unfinished) }

    it 'does not allow the user to edit the task' do
      expect(subject).to be_falsey
    end
  end
end
