require 'rails_helper'

RSpec.describe 'Tasks index', type: :feature do
  let!(:task_1) { create(:task, name: "Task 1") }
  let!(:task_2) { create(:task, name: "Task 2") }
  let!(:task_3) { create(:task, name: "Task 3") }
  let!(:task_4) { create(:task, name: "Task 4") }
  let!(:task_5) { create(:task, name: "Task 5") }
  let!(:task_6) { create(:task, name: "Task 6") }

  it 'can see all bided tasks' do
    visit tasks_path
    expect(page).to have_content('Task 2')
    expect(page).to have_content('Task 3')
    expect(page).to have_content('Task 4')
    expect(page).to have_content('Task 5')
    expect(page).to have_content('Task 6')
  end

  it 'paginates bided tasks' do
    visit tasks_path
    
    click_link I18n.t("pages.common.see_more")
    expect(page).to have_content('Task 1')
  end

  it 'shows sign in and sign up links' do
    visit tasks_path
    expect(page).to have_content(I18n.t("pages.header.sign_in"))
    expect(page).to have_content(I18n.t("pages.header.sign_up"))
  end

  it 'shows the new task button' do
    visit tasks_path
    expect(page).to have_content(I18n.t("pages.tasks.create_task"))
  end

  context 'when user clicks on the new task button' do
    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        visit tasks_path
        click_link I18n.t("pages.tasks.create_task")
        expect(page).to have_content(I18n.t("pages.account.form.sign_in.noun"))
      end
    end
  end
end
