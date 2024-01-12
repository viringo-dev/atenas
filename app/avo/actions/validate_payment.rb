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
      record.validate!
    end
  end
end
