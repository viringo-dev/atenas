# frozen_string_literal: true

require "rails_helper"
include ViewComponent::TestHelpers

RSpec.describe HeaderComponent, type: :component do
  context "when there is no logged user" do
    it "renders sign-in and sign-up links" do
      expect(
        render_inline(described_class.new(channels: nil)).css("a").to_html
      ).to include(
        I18n.t("pages.header.sign_in"),
        I18n.t("pages.header.sign_up")
      )

      expect(
        render_inline(described_class.new(channels: nil)).to_html
      ).to_not include(
        I18n.t("pages.account.sign_out")
      )
    end

    it "doesn't render my-tasks, my-bids, notifications, channels, and avatar links/button" do
      expect(
        render_inline(described_class.new(channels: nil)).to_html
      ).not_to include(
        I18n.t("pages.header.my_tasks"),
        I18n.t("pages.header.my_bids")
      )

      expect(
        render_inline(described_class.new(channels: nil)).css("#new-notification, #message-notification, #user-menu-button").to_html
      ).not_to be_present
    end
  end

  context "when there is a logged user" do
    let(:user) { create(:user) }
    let(:channels) { user.channels }

    it "doesn't render sign-in and sign-up links" do
      expect(
        render_inline(described_class.new(channels: channels, current_user: user)).css("a").to_html
      ).to_not include(
        I18n.t("pages.header.sign_in"),
        I18n.t("pages.header.sign_up")
      )

      expect(
        render_inline(described_class.new(channels: channels, current_user: user)).to_html
      ).to include(
        I18n.t("pages.account.sign_out")
      )
    end

    it "renders my-tasks and my-bids" do
      expect(
        render_inline(described_class.new(channels: channels, current_user: user)).to_html
      ).to include(
        I18n.t("pages.header.my_tasks"),
        I18n.t("pages.header.my_bids")
      )
    end
  end
end
