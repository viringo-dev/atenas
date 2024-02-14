# frozen_string_literal: true

require "rails_helper"
include ViewComponent::TestHelpers

RSpec.describe TaskComponent, type: :component do
  let!(:task) { create(:task) }

  context "when current page is not 'task/:id'" do
    it "renders the task title as a link" do
      expect(
        render_inline(described_class.new(task: task)).css("a").to_html
      ).to include(
        task.name
      )
    end
  end

  context "when current page is 'task/:id'" do
    before { allow_any_instance_of(ActionView::Helpers::UrlHelper).to receive(:current_page?) { true } }

    it "doesn't render the task title as a link" do
      expect(
        render_inline(described_class.new(task: task)).css("a").to_html
      ).to_not include(
        task.name
      )
    end
  end

  context "when task hasn't got files" do
    it "doesn't render the files dropdown" do
      expect(
        render_inline(described_class.new(task: task)).css("button[data-dropdown-toggle='files-dropdown-#{task.id}'].hidden").to_html
      ).to include(
        I18n.t("activerecord.attributes.task.files")
      )
    end
  end

  context "when task has got files" do
    let!(:task) { create(:task, :task_with_file) }

    it "renders the files dropdown" do
      expect(
        render_inline(described_class.new(task: task)).css("button[data-dropdown-toggle='files-dropdown-#{task.id}'].hidden").to_html
      ).to_not include(
        I18n.t("activerecord.attributes.task.files")
      )
    end
  end

  context "when current_user is the task owner" do
    it "renders the bids button" do
      expect(
        render_inline(described_class.new(task: task, current_user: task.user)).css("a[href='/tasks/#{task.id}']").to_html
      ).to include(
        I18n.t("activerecord.models.bid.other")
      )
    end
  end

  context "when current_user is not the task owner" do
    it "doesn't render the bids button" do
      expect(
        render_inline(described_class.new(task: task)).css("a[href='/tasks/#{task.id}']").to_html
      ).to_not include(
        I18n.t("activerecord.models.bid.other")
      )
    end
  end
end
