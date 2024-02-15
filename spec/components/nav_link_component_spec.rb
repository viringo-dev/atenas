# frozen_string_literal: true

require "rails_helper"
include ViewComponent::TestHelpers

RSpec.describe NavLinkComponent, type: :component do
  it "renders nav-links" do
    expect(
      render_inline(described_class.new(name: "About", path: "/tasks/1")).to_html
    ).to include(
      "About",
      "href=\"/tasks/1\""
    )
  end
end
