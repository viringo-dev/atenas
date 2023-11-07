module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        'primary': '#19A7CE',
        'primary-light': '#1FB9E3',
        'secondary': '#146C94',
        'secondary-light': '#1881B2',
        'third': '#03C988',
        'third-light': '#03E79C',
        'dark': '#303543',
        'light': '#303543',
        'negative': '#E63946',
        'negative-light': '#E84C58'
      },
      fontFamily: {
        sans: ['Open Sans']
      },
    },
  },
  plugins: [
    require('@tailwindcss/line-clamp')
  ]
}
