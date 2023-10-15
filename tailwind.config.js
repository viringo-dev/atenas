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
        'primary-dark': '#1696B9',
        'secondary': '#146C94',
        'secondary-dark': '#116185',
        'third': '#03C988',
        'third-dark': '#02B47A',
        'dark': '#303543',
        'light': '#303543',
        'negative': '#E63946',
        'negative-dark': '#E21F2E'
      },
      fontFamily: {
        sans: ['Roboto']
      },
    },
  },
  plugins: [
    require('@tailwindcss/line-clamp')
  ]
}
