---
title: "Cookie notices for your static site or JAM stack"
summary: "Summary here"
---

## Overview {#overview}

You see them everywhere, including this site, annoying cookie consent boxes obscuring the content you actually want to see. Some users actually really like them as they "give control over privacy". I don't think they would be so happy about all those boxes if they had seen how many cookies most sites are setting tracking cookies before consent has been given. In many cases, it seems these sites are doing the bare minimum to add plausible deniability, but it's also the case that implementing such a system is actually incredibly complicated.

![Image of cookies before consent]({{< static "images/bad-cookie-warning.png" >}})

Just have a look at this conversation between a group of very intelligent people who are just trying to make their popular Open Source blogging platform compliant with privacy regulations. There is no benefit to them to infringe on user privacy, but stripping everything down to purely functional cookies turned out to be a lot more work than anybody would expect. I'm still not sure the goal was completely reached. https://github.com/gohugoio/hugo/issues/4616

## So, just check for consent cookie? {#check-for-consent}

On the surface, it all seems very trivial, until you really start thinking about it...

Ok so we rely on third-party services such as Disqus for user comments, Youtube/Vimeo for embedded videos, Google Analytics for knowing what content people read so we know where to spend time, Twitter embeds for quoting others and maybe Instagram embeds. Oh... and we use Cloudflare as the CDN (hosting content on computers that are near our users so that downloads are fast). All of these services cause cookies to be set on user's computers and if we try to use these services we have no control over what cookies they set unless they give us control. But they are mostly based in the US so they give little concern to European laws.

So if we can't control what they set, then we need to block them until the user has consented. But wait... isn't this blocking access to content on the condition of consent specifically something that GDPR says we cannot do? Yeah, it is, but what options do we have? Create our own video hosting service and hope that the content we want to reference is uploaded by its creator? However, this isn't really the main content that the user wanted to view, they came to see the blog post, and maybe they don't care about the peripheral content, but does the GDPR? Do we need a team of lawyers to sort out this mess?

OK, let's just block these third-party services until we have consent from users... but wait... we create our blog using a static site generator and host it on Github pages which only serves static pages. We have no way of toggling these things based on user preference without completely migrating to a new blogging tool and hosting platform both of which support dynamic pages. That's a lot of work and complexity to introduce when we have already invested in the current platforms and it throws away all the speed advantages we had with the previous approach.

So is there another solution? Maybe we could have some sort of loading page that sits in front of our site that then either sends people to the cookie-free page that uses no third-party tools or the version with third-party content depending on their selection. But then what stops somebody from navigating to the cookie enabled version? We are back to square one. This is also introducing a lot of complexity and we can still no longer just use Github pages.

But that doesn't even cover the full extent of this, as apparently cookie consent [needs to be granular](https://www.pinsentmasons.com/out-law/news/granular-approach-to-cookie-consent-required-in-spain). Users need to be able to revoke consent and this approach requires everybody to always be on their toes and not introduce any external calls that could end up accidentally setting a cookie. This isn't a great solution unless your site is put together by robots who never make mistakes.

This is fast becoming a nightmare and we haven't even got to the wording we can legally use for the decisions that users must make or the fact that some countries require [keeping records of consent](https://www.iubenda.com/en/help/5525-cookies-gdpr-requirements#records). We are already talking about a system that could end up far more complex than all the other features in the rest of the site combined.

## The Solution

So what's a dev to do. We don't want to spend our lives dealing with what is actually a very complex legal, social and technical challenge that's constantly changing. We're in luck though. Some people have already thought long and hard and come up with a fantastic solution.

Meet [Osano](https://www.osano.com/cookieconsent) and no, there are no kickbacks here, they are have just made a complicated problem simple and so deserve the kudos. When I saw their pricing I was a bit thrown back, but the more I've looked into this the more of a reasonable price this seems, especially when you can start off on a free plan.

So what's so good about it? Well it's mostly managed for you with very few changes required on your end. You add an Osano script to the top of your page, set the settings to strict and it will immediately start removing third-party scripts, iframes and other resources when the page is loaded. It will report the things it blocks back to Osano so they then show up in your Osano admin panel. It will then allow you to categorise each of these and provide suggestions for some common ones based on what Osano's lawyers have determined.

When a user comes to your site they are asked which categories of cookies they want to accept and based on what they select the Osano script will allow scripts or other resources in those specific categories to load. The best part about this is that it removes human error as anything new can just be blocked by default until the person managing your Osano account account has categorised it.

Ultimately I hope in the future there is no need for a company like this to exist (sorry Osano), but right now there is and they are doing a damn good job.

## Steps {#steps}

### 1) Signup for Osano {#signup}

Visit the [plans](https://www.osano.com/plans) page. You should be fine with the free plan unless your site is quite popular. Check for the confirmation email and then login.

### 2) Navigate to Consent Management {#consent-management}

Next you need to wait through an unhelpful introduction video. Then click on "Consent Management" tab in the top left. This is intially where you will spend most of your time.

### 3) Fill in details for your site {#configure}

Click the big plus symbol in the bottom right to add your site and then fill out details such on the next page: name, domain and the URL for your privacy policy. You can also set up Styling on the next tab so that the consent box fits the look of your site.

### 4) Publish

When everything is set how you like it, you need click the `Publish` button. When you do this, Osano generates a script for you and pushes it out to their content delivery network. Next just click on the "Get Code" button and copy this and paste it into your site, making sure it is the very first script on your page. This part is critical as not doing this will mean Osano might not be able to block some things it should be blocking.

### 5) Categorise

Now when visitors hit your site Osano will capture info about what scripts, iframes and cookies are being loaded. It will initially allow these through until you change the `Mode` on the settings page from `Discovery/Listener` to `Strict`. It does this because it doesn't wish to break your site.

Anyway as it finds resources it will start populating `Discovered` entries under the `Scripts` and `Cookies` tabs. You will need to move everything from `Discovered` to `Managed` by selecting a category for the type of data each service collects. Osano already prepopulates a lot of this base on what their lawyers have discovered about many common services, so this is actually a lot easier than it seems.

### 6) Turn on strict mode

After you have finished moving everything to `Managed`, if you haven't already you should switch to strict mode so that thing will be blocked until consent is given by a visitor.

### 7) Test

Osano is pretty good, but it's also not a silver bullet. There are certain things it cannot catch, such as when an event being triggered on your page [causes another script to be loaded](https://docs.osano.com/article/19-developer-documentation). So make sure you test things out as a user where you try out the different combinations to make sure they are behaving as they should.

## Success

Congratulations, your site will now also present users with these annoying but necessary cookie warnings. However, unlike many of the implementations out there that completely negate the entire point of adding the warning, this one will actually protect user privacy and help you be compliant.
