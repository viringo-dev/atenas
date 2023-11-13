require 'rails_helper'

RSpec.describe 'Tasks index', type: :feature do
  let!(:task_1) { create(:task, name: "Task 1") }
  let!(:task_2) { create(:task, name: "Task 2") }
  let!(:task_3) { create(:task, name: "Task 3") }
  let!(:task_4) { create(:task, name: "Task 4") }
  let!(:task_5) { create(:task, name: "Task 5") }
  let!(:task_6) { create(:task, name: "Task 6") }
  let!(:task_7) { create(:task, name: "Task 7", status: Task.statuses[:unpaid]) }

  it 'shows all bided tasks' do
    visit root_path
    expect(page).to have_content('Task 2')
    expect(page).to have_content('Task 3')
    expect(page).to have_content('Task 4')
    expect(page).to have_content('Task 5')
    expect(page).to have_content('Task 6')
    expect(page).not_to have_content('Task 1')
    expect(page).not_to have_content('Task 7')
  end

  it 'paginates bided tasks' do
    visit root_path
    
    click_link I18n.t("pages.common.see_more")
    expect(page).to have_content('Task 1')
  end

  it 'shows sign in and sign up links' do
    visit root_path
    expect(page).to have_content(I18n.t("pages.header.sign_in"))
    expect(page).to have_content(I18n.t("pages.header.sign_up"))
  end

  it 'shows the new task button' do
    visit root_path
    expect(page).to have_content(I18n.t("pages.tasks.create_task"))
  end

  context 'when user clicks on the new task button' do
    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        visit root_path
        click_link I18n.t("pages.tasks.create_task")
        expect(page).to have_content(I18n.t("pages.account.form.sign_in.noun"))
      end
    end

    context 'when user is signed in' do
      let!(:user) { create(:confirmed_user) }
      before { login_as(user) }

      it 'shows new task form', js: true do
        visit root_path
        click_link I18n.t("pages.tasks.create_task")
        expect(page).to_not have_content(I18n.t("pages.tasks.new_task"))
        expect(page).to have_content(I18n.t("activerecord.attributes.task.name"))
        expect(page).to have_content(I18n.t("activerecord.attributes.task.description"))
        expect(page).to have_content(I18n.t("activerecord.attributes.task.reward"))
        expect(page).to have_content(I18n.t("activerecord.attributes.task.deadline"))
        expect(page).to have_content(I18n.t("pages.common.save"))
      end

      context 'when user submits the form' do
        it 'creates a new task', js: true do
          visit root_path
          click_link I18n.t("pages.tasks.create_task")
          fill_in "task_name", with: "Task x"
          fill_in "task_description", with: "Description x"
          fill_in "task_reward", with: "100"
          fill_in "task_deadline", with: "2021-10-10"
          click_button I18n.t("pages.common.save")
          expect(page).to have_content(I18n.t("pages.tasks.created"))
          expect(page).to have_content("Task x")
          expect(page).to have_content("Description x")
          expect(page).to have_content("100")
          expect(page).to have_content(user.username)
        end
      end
    end
  end
end
