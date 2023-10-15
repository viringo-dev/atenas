module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.append "flash", partial: "shared/flash"
  end

  def avatar(user)
    image_tag user.avatar.attached? ? user.avatar : "/default-avatar.png",
              data: { previews_target: "preview" },
              class: "w-10 h-10 rounded-full cursor-pointer"
  end
end
