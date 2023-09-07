module ApplicationHelper
  def button_classes(classes = nil)
    "#{classes} text-white bg-primary focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full px-5 py-2.5 text-center cursor-pointer whitespace-nowrap"
  end

  def input_classes(classes = nil)
    "#{classes} block rounded-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 bg-gray-50 border border-gray-300 appearance-nonefocus:outline-none focus:ring-0 focus:border-blue-600 peer"
  end

  def label_classes(classes = nil)
    "#{classes} absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4"
  end

  def select_classes(classes = nil)
    "#{classes} block rounded-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 bg-gray-50 border border-gray-300 appearance-nonefocus:outline-none focus:ring-0 focus:border-blue-600 peer"
  end

  def checkbox_classes(classes = nil)
    "#{classes} w-5 bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5"
  end
end
