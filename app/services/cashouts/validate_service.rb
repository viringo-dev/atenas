class Cashouts::ValidateService < ApplicationService
  attr_reader :cashout
  def initialize(cashout:)
    @cashout = cashout
  end

  def call
    return Failure.new(nil) unless allowed?

    ActiveRecord::Base.transaction do
      bid.paid!
      cashout.transferred!
      NotificationJob.perform_later(bid.id, Notification.notification_types[:cashout_validated])
    rescue ActiveRecord::Rollback
      return Failure.new(nil)
    end
    Success.new(nil)
  end

  private

  def bid
    @bid ||= cashout.bid
  end

  def task
    @task ||= cashout.task
  end

  def allowed?
    cashout.pending? && bid.finished? && task.finished?
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
