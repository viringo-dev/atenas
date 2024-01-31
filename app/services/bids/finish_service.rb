class Bids::FinishService < ApplicationService
  attr_reader :user, :bid
  def initialize(user:, bid:)
    @user = user
    @bid = bid
  end

  def call
    return Failure.new(nil) unless allowed?

    ActiveRecord::Base.transaction do
      task.finished! if task_belongs_to_user?
      bid.finished! if bid_belongs_to_user?
      NotificationJob.perform_later(bid.id, Notification.notification_types[:finished_task_and_bid]) if task.finished? && bid.finished?
    rescue ActiveRecord::Rollback
      return Failure.new(nil)
    end
    Success.new(nil)
  end

  private

  def allowed?
    (task.assigned? || task.finished?) && (bid.accepted? || bid.finished?) && (task_belongs_to_user? || bid_belongs_to_user?)
  end

  def task
    @task ||= bid.task
  end

  def task_belongs_to_user?
    task.user == user
  end

  def bid_belongs_to_user?
    bid.user == user
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
