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
        'secondary-hover': '#116185',
        'third': '#03C988',
        'third-hover': '#02B47A',
        'dark': '#303543',
        'light': '#303543',
      },
      fontFamily: {
        sans: ['Montserrat']
      },
    },
  },
  plugins: [
    require('@tailwindcss/line-clamp')
  ]
}
