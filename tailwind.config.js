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
        'secondary': '#146C94',
        'third': '#AFD3E2',
        'dark': '#303543',
        'light': '#303543',
      },
      fontFamily: {
        sans: ['Montserrat']
      },
    },
  },
}
