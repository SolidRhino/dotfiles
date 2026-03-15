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
      editLink: {
        baseUrl: 'https://github.com/SolidRhino/dotfiles/edit/main/site/',
      },
      head: [
        { tag: 'meta', attrs: { property: 'og:type',        content: 'website' } },
        { tag: 'meta', attrs: { property: 'og:title',       content: 'dotfiles' } },
        { tag: 'meta', attrs: { property: 'og:description', content: 'Personal dotfiles for macOS & Linux managed with chezmoi.' } },
        { tag: 'meta', attrs: { property: 'og:url',         content: 'https://solidrhino.github.io/dotfiles' } },
      ],
      plugins: [
        starlightCatppuccin({
          dark:  { flavor: 'mocha', accent: 'mauve' },
          light: { flavor: 'latte', accent: 'mauve' },
        }),
      ],
    }),
  ],
})
