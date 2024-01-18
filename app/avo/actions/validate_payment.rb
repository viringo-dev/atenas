class Avo::Actions::ValidatePayment < Avo::BaseAction
  self.name = "Validate Payment"
  # self.visible = -> do
  #   true
  # end

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      result = Payments::ValidateService.new(payment: record).call
      if result.success?
        succeed "Payment #{record.id} validated"
      else
        error "Payment #{record.id} not validated"
      end
    end
  end
end
