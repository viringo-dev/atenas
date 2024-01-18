class Payments::ValidateService < ApplicationService
  attr_reader :payment
  def initialize(payment:)
    @payment = payment
  end

  def call
    return Failure.new(nil) unless allowed?

    ActiveRecord::Base.transaction do
      payment.validated!
      task.assigned!
      bid.accepted!
      channel = Channel.create(task: task, name: task.name)
      channel.channel_users.create(user: task.user)
      channel.channel_users.create(user: bid.user)
      NotificationJob.perform_later(bid.id, Notification.notification_types[:accepted_bid])
    rescue ActiveRecord::Rollback
      return Failure.new(nil)
    end
    Success.new(nil)
  end

  private

  def bid
    @bid ||= payment.bid
  end

  def task
    @task ||= bid.task
  end

  def allowed?
    task.unpaid? && bid.offered?
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
