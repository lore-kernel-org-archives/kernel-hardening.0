MIME-Version: 1.0
In-Reply-To: <20171128062824.GU17858@eros>
References: <1511752336.31585.2.camel@gmail.com> <20171128062824.GU17858@eros>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Tue, 28 Nov 2017 17:12:41 +0530
Message-ID: <CAPDLWs9vPtEiikvsimcntqqiukvZ1iLSJS16Bd7xK=GLgvtRjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2] scripts: leaking_addresses: add support for 32-bit
 kernel addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 11:58 AM, Tobin C. Harding <me@tobin.cc> wrote:
>
> At this stage I am unsure
> how best to convey my ideas back to you. It seems that adding 32 bit x86
> support is making a big enough change to the script that rather than you
> patching and me maintaining we could see it more as co-developing the
> patch.

That's just great! Thanks for the vote of confidence..

>I am in no way trying to take away from your changes, I'm happy
> for all work we end up with being applied with you as the author.
Of course not..

> If you are happy with this, I will email a patch to you (and CC
> kernel-hardening).
Yes..

>You could then look at it and see what things you
> like and what things you don't. Also I have not got access to a 32 bit
> x86 machine so it has not been tested. Once you are happy with it
> perhaps you could re-send as v3 and then I can apply it to the tree with
> you as the author.

Certainly, will do..

> The main aims of my changes to your patch are:
>
> 1. Keep inline with current script as much as possible.
> 2. Keep code as clean as possible (Perl can go to spaghetti really fast).
> 3. Try to keep the architecture stuff un-entangled, assuming more
>    architecture specific code will be needed in the future.
>
> And now I'll add a few comments inline intended to add clarity to my
> patch when it comes.

With even a quick glance, I can see you've definitely improved readability and
such...

> Thanks Kaiwan. If any of my methods are unclear or you don't like them
> please do say. I'm hear to learn also, we are shooting for the best
> Kernel possible.
Absolutely! Thanks again..
...

> I played around with these two subs for a while. Let me know what you
> think.
>
> thanks,
> Tobin.

Will look into your patch in detail and revert..

thanks v much,
Kaiwan.
