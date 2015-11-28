Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 28 Nov 2015 10:25:17 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20151128092517.GH32190@chrystal.uk.oracle.com>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
 <20151125234542.GA10324@chrystal>
 <CAGXu5jL8CzBum9Od1BhiwhVqOdJ0aZbCz126aCnu6zp1Zj6-0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL8CzBum9Od1BhiwhVqOdJ0aZbCz126aCnu6zp1Zj6-0w@mail.gmail.com>
Subject: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: Kees Cook <keescook@chromium.org>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 27, 2015 at 12:23:58PM -0800, Kees Cook wrote:
> On Wed, Nov 25, 2015 at 3:45 PM, Quentin Casasnovas
> <quentin.casasnovas@oracle.com> wrote:
> >
> > Finally, I'd like to find a real life example where one could overflow the
> > kernel stack, so it can be used to test the feature (once properly split)
> > and show it can happen, for real, before sending real patches for review.
> > I might have found such a case because of what appears to me like a gcc
> > bug, more on this in another follow up :)
> 
> I think at least some of the past flaws have been related to having
> dynamic stack allocations, where an attacker could control the size of
> the object. And "alloca" overflow style attack.
> 

It turns out there isn't any gcc problems and huge stack usage (sometimes
even 5Kb, like for nl80211_send_wiphy(), or 2Kb in interrupt context for
kbd_event()) in functions not supposed to require a lot of stack was caused
by KASAN on my tests.  The THREAD_SIZE is properly augmented when using
KASAN so that shouldn't cause any problems, sorry for the noise.

> 
> I will see about getting an lkdtm test written too. Though testing
> this when there is no guard page seems like a bad idea. I'll have to
> get creative on the overwrite. Hmm.
> 

:)

Quentin
