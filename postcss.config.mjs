// postcss.config.mjs

export default {
  plugins: {
    '@tailwindcss/postcss': {}, // Replaces the old 'tailwindcss' plugin
    // Note: Autoprefixer is often included in @tailwindcss/postcss for v4, 
    // so you generally don't need to list it separately.
    // If you need other plugins, they would go here:
    // 'some-other-postcss-plugin': {},
  },
}