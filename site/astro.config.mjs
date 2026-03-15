// @ts-check
import { defineConfig } from 'astro/config'
import starlight from '@astrojs/starlight'
import starlightCatppuccin from '@catppuccin/starlight'

export default defineConfig({
  site: 'https://solidrhino.github.io',
  base: '/dotfiles',
  integrations: [
    starlight({
      title: 'dotfiles',
      favicon: '/favicon.svg',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/SolidRhino/dotfiles' },
      ],
      sidebar: [
        { label: 'Home', slug: 'index' },
        { label: 'Cheatsheet', slug: 'cheatsheet' },
        { label: 'Changelog', slug: 'changelog' },
      ],
      lastUpdated: true,
      plugins: [
        starlightCatppuccin({
          dark:  { flavor: 'mocha', accent: 'mauve' },
          light: { flavor: 'latte', accent: 'mauve' },
        }),
      ],
    }),
  ],
})
