# frozen_string_literal: true

require "rails_helper"
include ViewComponent::TestHelpers

RSpec.describe TaskComponent, type: :component do
  let!(:task) { create(:task) }
  let!(:current_user) { create(:confirmed_user) }

  it "renders the task title, description, deadline, reward, and owner username" do
    expect(
      render_inline(described_class.new(task: task, current_user: current_user)).to_html
    ).to include(
      task.name,
      task.description,
      I18n.l(task.deadline, locale: :es, format: :long),
      task.reward.to_s,
      task.user.username
    )
  end

  context "when current page is not 'task/:id'" do
    it "renders the task title as a link" do
      expect(
        render_inline(described_class.new(task: task, current_user: current_user)).css("a").to_html
      ).to include(
        task.name
      )
    end
  end

  context "when current page is 'task/:id'" do
    before { allow_any_instance_of(ActionView::Helpers::UrlHelper).to receive(:current_page?) { true } }

    it "doesn't render the task title as a link" do
      expect(
        render_inline(described_class.new(task: task, current_user: current_user)).css("a").to_html
      ).to_not include(
        task.name
      )
    end
  end

  context "when task hasn't got files" do
    it "doesn't render the files dropdown" do
      expect(
        render_inline(described_class.new(task: task, current_user: current_user)).css("button[data-dropdown-toggle='files-dropdown-#{task.id}'].hidden").to_html
      ).to include(
        I18n.t("activerecord.attributes.task.files")
      )
    end
  end

  context "when task has got files" do
    let!(:task) { create(:task, :task_with_file) }

    it "renders the files dropdown" do
      expect(
        render_inline(described_class.new(task: task, current_user: current_user)).css("button[data-dropdown-toggle='files-dropdown-#{task.id}'].hidden").to_html
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

    it "renders the edit and delete buttons" do
      expect(
        render_inline(described_class.new(task: task, current_user: task.user)).css("button").to_html
      ).to include(
        I18n.t("pages.common.edit")
      )

      expect(
        render_inline(described_class.new(task: task, current_user: task.user)).css("button").to_html
      ).to include(
        I18n.t("pages.common.delete")
      )
    end

    context "when task has a payment" do
      let!(:task) { create(:assigned_task) }

      it "doesn't render the edit and delete buttons" do
        expect(
          render_inline(described_class.new(task: task, current_user: task.user)).css("button").to_html
        ).to_not include(
          I18n.t("pages.common.edit")
        )

        expect(
          render_inline(described_class.new(task: task, current_user: task.user)).css("button").to_html
        ).to_not include(
          I18n.t("pages.common.delete")
        )
      end
    end
  end

  context "when current_user is not the task owner" do
    it "doesn't render the bids button" do
      expect(
        render_inline(described_class.new(task: task, current_user: current_user)).css("a[href='/tasks/#{task.id}']").to_html
      ).to_not include(
        I18n.t("activerecord.models.bid.other")
      )
    end

    it "doesn't render the edit and delete buttons" do
      expect(
        render_inline(described_class.new(task: task, current_user: current_user)).css("button").to_html
      ).to_not include(
        I18n.t("pages.common.edit")
      )

      expect(
        render_inline(described_class.new(task: task, current_user: current_user)).css("button").to_html
      ).to_not include(
        I18n.t("pages.common.delete")
      )
    end

    context "when current page is 'tasks/:id'" do
      before { allow_any_instance_of(ActionView::Helpers::UrlHelper).to receive(:current_page?) { true } }

      it "doesn't render the bid button" do
        expect(
          render_inline(described_class.new(task: task, current_user: current_user)).css("a[href='/tasks/#{task.id}']").to_html
        ).to_not include(
          I18n.t("pages.task.bid")
        )
      end
    end

    context "when current page is not 'tasks/:id'" do
      it "renders the bid button" do
        expect(
          render_inline(described_class.new(task: task, current_user: current_user)).css("a[href='/tasks/#{task.id}']").to_html
        ).to include(
          I18n.t("pages.task.bid")
        )
      end

      context "when current_user has already bided the task" do
        let!(:bid) { create(:bid, task: task, user: current_user) }

        it "renders a button (link) with the bid amount" do
          expect(
            render_inline(described_class.new(task: task, current_user: current_user)).css("a[href='/tasks/#{task.id}']").to_html
          ).to include(
            bid.amount.to_s
          )
        end
      end 
    end
  end
end
