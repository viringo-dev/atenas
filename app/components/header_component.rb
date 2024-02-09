# frozen_string_literal: true

class HeaderComponent < ApplicationComponent
  attr_reader :channels
  def initialize(channels:)
    @channels = channels
  end

  erb_template <<-ERB
    <header class="sticky top-0 z-10">
      <nav class="bg-primary">
        <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto px-2 md:px-8 py-3">
          <div class="flex">
            <button data-collapse-toggle="navbar-user" type="button" class="inline-flex items-center w-10 h-10 justify-center text-sm rounded-lg md:hidden focus:outline-none" aria-controls="navbar-user" aria-expanded="false">
              <svg class="w-5 h-5 text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 17 14">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1h15M1 7h15M1 13h15"/>
              </svg>
            </button>
            <a href="/" class="flex items-center">
              <%= link_to root_path, class: "flex items-center" do %>
                <%= image_tag("/logo.png", class: "h-8") %>
              <% end %>
            </a>
          </div>
          <div class="flex items-center md:order-2">
            <% if current_user %>
              <%= turbo_stream_from current_user %>
              <%= link_to notifications_path, class: "w-6 text-white mr-3 relative" do %>
                <%= render 'icons/notification' %>
                <%= tag.div id: "new-notification" do %>
                  <% if current_user.has_unread_notifications? %>
                    <div class="dot-notification"></div>
                  <% end %>
                <% end %>
              <% end %>
              <%= link_to messages_path, class: "w-6 text-white mr-3 relative" do %>
                <%= render 'icons/channels' %>
                <%= tag.div id: "message-notification" do %>
                  <% if channels.select { |channel| channel.unread_messages_count.positive? }.any? %>
                    <div class="dot-notification"></div>
                  <% end %>
                <% end %>
              <% end %>
              <button type="button" class="w-10 h-10 flex mr-3 text-sm rounded-full md:mr-0" id="user-menu-button" aria-expanded="false" data-dropdown-toggle="user-dropdown" data-dropdown-placement="bottom">
                <%= avatar(current_user) %>
              </button>
              <!-- Dropdown menu -->
              <div class="z-50 hidden my-4 text-base list-none bg-white divide-y divide-gray-100 rounded-lg shadow" id="user-dropdown">
                <ul class="" aria-labelledby="user-menu-button">
                  <li>
                    <%= link_to t("pages.header.account"), account_path, class: "block px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 w-full text-left hover:rounded-t-lg" %>
                  </li>
                </ul>
                <ul class="" aria-labelledby="user-menu-button">
                  <li>
                    <%= button_to t("pages.account.sign_out"), logout_path, method: :delete, data: { turbo: false }, class: "block px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 w-full text-left" %>
                  </li>
                </ul>
              </div>
            <% else %>
              <div class="flex gap-x-2">
                <%= link_to t("pages.header.sign_in"), login_path, class: "btn bg-secondary hover:bg-secondary-light px-2 md:px-5" %>
                <%= link_to t("pages.header.sign_up"), sign_up_path, class: "btn bg-third hover:bg-third-light px-2 md:px-5" %>
              </div>
            <% end %>
          </div>
          <div class="items-center justify-between hidden w-full md:flex md:w-auto md:order-1" id="navbar-user">
            <div class="flex flex-col font-medium p-4 md:p-0 mt-4 border border-gray-100 rounded-lg md:flex-row md:space-x-8 md:mt-0 md:border-0">
              <%= render(NavLinkComponent.new(name: t("pages.header.tasks"), path: root_path)) %>
              <% if current_user %>
                <%= render(NavLinkComponent.new(name: t("pages.header.my_tasks"), path: my_tasks_path)) %>
                <%= render(NavLinkComponent.new(name: t("pages.header.my_bids"), path: my_bids_path)) %>
              <% end %>
              <%= render(NavLinkComponent.new(name: t("pages.header.how_it_works"), path: how_it_works_path)) %>
            </div>
          </div>
      </nav>
    </header>
  ERB
end
