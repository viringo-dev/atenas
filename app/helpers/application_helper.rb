module ApplicationHelper
  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
  end

  def render_turbo_stream_flash_messages
    turbo_stream.append "flash", partial: "shared/flash"
  end

  def avatar(user)
    image_tag user.avatar.attached? ? user.avatar : "/default-avatar.png",
              data: { previews_target: "preview" },
              class: "rounded-full cursor-pointer"
  end

  def turbo_frame_request?
    request.headers["Turbo-Frame"].present?
  end
end
