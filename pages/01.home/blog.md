---
title: FP Ninja
menu: Home
subheading: Random stuff by a guy who happens to have a blog o.O
header_image: header_img.png

content:
    items: @self.children
    order:
        by: date
        dir: desc
    limit: 10
    pagination: true

pagination: true
---

<style>
  .intro-header { position: relative; }

  .intro-header:before {
    content: ''; position: absolute; top: 0; left: 0; background: rgba(0,0,0,0.7); width: 100%; height: 100%; z-index: 0;
  }
</style>
