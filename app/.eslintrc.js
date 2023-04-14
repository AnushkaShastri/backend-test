module.exports = {
  // ...
  overrides: [
    {
      // ...
      extends: [
        // ...
        'next/babel',
        'prettier/@typescript-eslint',
        'plugin:prettier/recommended',
      ],
      rules: {
        // ...
        'prettier/prettier': ['error', {}, { usePrettierrc: true }],
      },
    },
  ],
}