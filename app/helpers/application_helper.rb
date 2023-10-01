module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.append "flash", partial: "shared/flash"
  end

  def button_classes(classes = "")
    unless classes.include?("bg-")
      classes.concat(" bg-primary hover:bg-primary-hover")
    end
    "text-white focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full px-5 py-2.5 text-center cursor-pointer whitespace-nowrap #{classes}"
  end

  def input_classes(classes = "")
    "#{classes} block w-full p-2 text-gray-900 border border-gray-300 rounded-lg bg-gray-50 md:text-xs focus:ring-blue-500 focus:border-blue-500"
  end

  def label_classes(classes = "")
    "#{classes} block mb-1 text-sm font-medium text-gray-900"
  end

  def select_classes(classes = "")
    "#{classes} bg-gray-50 border border-gray-300 text-gray-900 md:text-xs rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2"
  end

  def date_classes(classes = "")
    "#{classes} bg-gray-50 border border-gray-300 text-gray-900 md:text-xs rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 md:p-2"
  end

  def checkbox_classes(classes = "")
    "#{classes} w-5 bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5"
  end

  def avatar(user)
    image_tag user.avatar.attached? ? user.avatar : "/default-avatar.png",
              data: { previews_target: "preview" },
              class: "w-10 h-10 rounded-full cursor-pointer"
  end
end
