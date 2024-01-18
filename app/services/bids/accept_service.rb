class Bids::AcceptService < ApplicationService
  attr_reader :user, :task, :bid
  def initialize(user:, task:, bid:)
    @user = user
    @task = task
    @bid = bid
  end

  def call
    return Failure.new(nil) unless allowed?

    ActiveRecord::Base.transaction do
      task.unpaid!
      task.bids
          .where.not(id: bid.id)
          .offered
          .destroy_all
    rescue ActiveRecord::Rollback
      return Failure.new(nil)
    end
    Success.new(nil)
  end

  private

  def allowed?
    task.bided? && task_belongs_to_user? && bid_belongs_to_task? && bid.offered?
  end

  def task_belongs_to_user?
    task.user == user
  end

  def bid_belongs_to_task?
    bid.task == task
  end

  Success = Struct.new(:nil) do
    def success?
      true
    end
  end

  Failure = Struct.new(:nil) do
    def success?
      false
    end
  end
end
