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
        'primary-hover': '#1696B9',
        'secondary': '#146C94',
        'secondary-hover': '#116185',
        'third': '#03C988',
        'third-hover': '#02B47A',
        'dark': '#303543',
        'light': '#303543',
        'negative': '#F6635C',
        'negative-hover': '#F4443B'
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
