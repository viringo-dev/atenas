# frozen_string_literal: true

class NavLinkComponent < ApplicationComponent
  attr_reader :name, :path
  def initialize(name:, path:)
    @name = name
    @path = path
  end

  erb_template <<-ERB
    <%= active_link_to name,
                       path,
                       class: "block py-2 pl-3 pr-4 text-white md:p-0 border-primary border-l-2 md:border-l-0 md:border-b-2 hover:border-white" %>
  ERB
end
