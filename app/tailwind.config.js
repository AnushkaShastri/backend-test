const { orange } = require("tailwindcss/colors");
const colors = require("tailwindcss/colors");
module.exports = {
  purge: [],
  darkMode: false,
  theme: {
    extend: {
      backgroundImage: {},
      backgroundImage: {
        "bg-image": "url('src/assets/bgimage.png')",
      },
      colors: {
        lightBlue: colors.lightBlue,
        orange: colors.orange,
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
