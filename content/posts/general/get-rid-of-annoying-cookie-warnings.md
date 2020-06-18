---
title: "Get rid annoying cookie warnings"
summary: "Summary here"
---

## Overview {#overview}

![Image of cookies before consent](/runbooks/images/cookie-consent.png)

You know the story, you're just browsing for amazing cookie recipes, or just reading a runbook &#x1F609; and you are rudely interrupted by one of those annoying cookie consent warnings begging you to give up your privacy. Any site, including this one, that wants to do even basic things like embedding Youtube videos, needs one of these annoying consent boxes. Even the government bodies that required websites to introduce these banners are starting to realise [there might have been a less intrusive way](https://www.bbc.com/news/business-38583001).

If you're like me, your thinking... I already have an automated system that clears out third party cookies, why do I need this annoying warning covering the content that I came here to see? But it's not just you, even site maintainers who don't wish to track you but just want to add Disqus page comments or gather anonymised Google analytics must add these annoying popups. On top of this, as discussed in the intro to a previous runbook, adding this to a site is also [far more complicated than you might imagine](/content/general/add-cookie-notices-to-your-static-site). To top it all off, many of the implementations actually add tracking cookies __before__ you consent and then don't even allow you to withdraw it or make doing so very difficult.

Sadly, the ad or tracking blocker software that you were using to protect your privacy (e.g. Ublock Origin, Ghostery, Brave Browser, or even just Incognito Mode, etc), is now the thing that clears out all those consent cookies. This means you end up getting constantly bugged about cookies far more than people who never took steps to address their own privacy.

So what's the solution...

## Steps {#steps}

Well it turns out you can use the same tools to block these annoyances

### 1) Install Ublock Origin {#step-1}
Here are the download links for various browsers:
  - [Chrome or Brave](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)
  - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - [Edge](https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak)
  - Safari: Unfortunately Apple has put an end to this extension on Safari
### 2) Open the "Option" window
Right-click on Ublock Origin icon and select "Options" from the menu:  
  ![right click on Ublock Origin icon and select "Options"](/runbooks/images/ublock-right-click-options.png)
### 3) Enable EasyList Cookie
1) Select the "Filter lists" tab
2) Expand the "Annoyances" section
3) Check the "EasyList Cookie" checkbox
4) Click "Update now" to make sure the List has been updated
5) Click "Apply changes" to activate the EasyList Cookie filter  

  ![showing filter list tab with EasyList Cookie selected](/runbooks/images/ublock-enable-easycookie.png)

## Success

Now you can finally browse the web in peace again.

Well mostly... there are still a few variants which Ublock can't simply hide, such as Yahoo's approach of doing a redirection. But the most common consent variants are handled, which is good enough while we wait for a real solution like implementing consent at the browser level.

## Further Information

* [Cookie consent popups - stop the madness](https://community.brave.com/t/cookie-consent-popups-stop-the-madness/102904)
* [No cookie consent walls — and no, scrolling isn’t consent, says EU data protection body](https://techcrunch.com/2020/05/06/no-cookie-consent-walls-and-no-scrolling-isnt-consent-says-eu-data-protection-body/)
* [Cookie banner frustration to be tackled by EU](https://www.bbc.com/news/business-38583001)
