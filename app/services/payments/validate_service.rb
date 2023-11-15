class Payments::ValidateService < ApplicationService
  attr_reader :payment
  def initialize(payment:)
    @payment = payment
  end

  def call
    return Failure.new(nil) unless allowed?

    payment.validated!
    task.assigned!
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
    !task.bided? && !task.paused? && !bid.offered?
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
