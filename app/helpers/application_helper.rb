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

  def active_link_to(text = nil, path = nil, **options, &)
    path ||= text

    options[:class] = class_names(options[:class], "border-white") if current_page?(path)
    return link_to(path, options, &) if block_given?

    link_to text, path, options
  end
end
