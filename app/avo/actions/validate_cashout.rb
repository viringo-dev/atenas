class Avo::Actions::ValidateCashout < Avo::BaseAction
  self.name = "Validate Cashout"
  # self.visible = -> do
  #   true
  # end

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      result = Cashouts::ValidateService.new(cashout: record).call
      if result.success?
        succeed "Cashout #{record.id} validated"
      else
        error "Cashout #{record.id} not validated"
      end
    end
  end
end
