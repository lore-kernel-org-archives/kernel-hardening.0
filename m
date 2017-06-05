Message-ID: <1496625669.21652.2.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sun, 04 Jun 2017 21:21:09 -0400
In-Reply-To: <20170605001225.GA23953@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
	 <1496498027.22395.1.camel@gmail.com> <20170603142110.GA7578@grsecurity.net>
	 <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
	 <20170604032813.GB25424@grsecurity.net>
	 <1496585753.11788.1.camel@gmail.com>
	 <20170605001225.GA23953@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 2017-06-04 at 20:12 -0400, Brad Spengler wrote:
> > And yes my "excuse" is consistent with what I said on GitHub. I
> > became
> > of the stack canary issue when Jann Horn told me about it months
> > ago. I
> > might have IRC logs from back then. I then assumed it was going to
> > get
> > fixed and promptly forgot about it as I do with pretty much every
> > other
> > specific bug. I noticed it again when making related changes in
> > CopperheadOS but: that's a 3.18 LTS kernel and 3.10 LTS kernels for
> > older devices, so it didn't occur to me than Jann might not have
> > gotten
> > it fixed in master, and arm64 doesn't use the per-task canaries so I
> > didn't need to fix that or add the zero byte there yet. Not sure
> > what is
> > so hard to understand about that. I noticed it still wasn't fixed
> > when
> > first making linux-hardened by porting those changes ahead.
> > 
> > If I *had* done research into the issue to point to when it had been
> > first discovered by someone, I wouldn't have found PaX. You don't
> > have
> 
> You wouldn't have found PaX eh?

I'm stating that I wouldn't have found PaX as the origin, as I've said
several times. You linked me to an early mention from 2007 on a mailing
list after deciding to throw a fit about this on IRC. That mailing list
post from 2007 with a fix for this doesn't mention PaX.

> Here's some more history then:
> From "months ago", October 2016:
> https://patchwork.kernel.org/patch/9405499/
> Here's a thread where Jann submitted the same patch as you, where he
> mentions it's from PaX (just that PaX used pax_get_random_long()).
> You participated in this thread, it's even in the reply context your
> reply includes -- look for yourself.  Here's a direct link:
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1262143.ht
> ml

He doesn't say it's *from* PaX. He states that the change is already in
PaX. My understanding then was that Jann found the problem. That's why I
talked to Jann about it when I stumbled on it again and noticed it
hadn't been fixed. As far as I was concerned, it was one of his bug
finds since that's what he does: finding bugs in the Linux kernel,
including ones that he reported to you for grsecurity features.

> Then you submitted it upstream and took credit for yourself:
> https://marc.info/?l=linux-kernel&m=149390477311752&w=2

I submitted that patch after talking to Jann about it again. I am not
'taking credit' for discovering anything by submitting a one line change
migrating it to get_random_long to the write people with a justification
for doing it. We both simply wanted to get a one line change fixing it
landed upstream.

The change in PaX isn't even the same thing: pax_get_random_long is not
a CSPRNG, get_random_long is a CSPRNG (since recently at least).

> > You don't have
> > patches uploaded on the site from before the earliest mailing list
> > post
> > that you pointed me at, which doesn't mention PaX.
> 
> There are no patches currently on the website that you can download at
> all,
> does it mean it's fine to take credit for everything in PaX because of
> that?
> Sorry but this is a really lame excuse.

I didn't take this change from PaX. What actually happened != an excuse.

I'm also simply not going to do deep research into whether someone else
has made tiny changes like this before. I didn't do any research into
whether anyone had previously fixed the assorted buffer overflows that
needed to be fixed for FORTIFY_SOURCE either. I'm not concerned with
whether someone else found one of those bugs before and didn't get a fix
for it landed upstream. If I'm actually using their fix for it, I'll
credit them for it.

I'm pointing out that if for some reason I HAD felt like wasting my time
doing research into it, Google wouldn't have found what you're pointing
to. At best I would have found the mailing list post you showed me.

> You can agree that 2006 is < 2007

Sure, but I don't agree that there's any relevance to who actually found
this bug first. What if someone found it even earlier than PaX and
suddenly shows up here claiming that? Is that relevant? No. The fix
didn't come from them, and it didn't come from PaX.

If you were so concerned about getting credit for this, you could have
gotten the bug fixed upstream.

> established that on github

No, we didn't. You also deleted your GitHub account so I wasn't able to
look back at what you said anymore. I have no idea what you said there.
I remember you saying PaX fixed it in January 2007 and then it seems
someone else found and fixed it independently later in 2007.

> wouldn't have led to PaX.  So let me show you for future reference how
> trivial this is:
> https://github.com/linux-scraping/linux-grsecurity/blame/grsec-test/ke
> rnel/fork.c
> ctrl+f get_random_long
> note: "11 years ago" on the left
> That took all of 10 seconds.
>
> Again not that any of this matters, it's one of many stupid security
> weaknesses upstream developers never cared to fix for years, but if
> we're going to be making up stories as excuses, let's at least get it
> right.  So can we agree it's a case of cryptomnesia, or at minimum you
> remembered the facts wrong?

I'm not making excuses, lying, or forgetting why I was aware of this.

It's fine if you don't believe me and you want to believe that there was
a conspiracy to steal credit for this from you.

> BTW while doing research I found:
> http://linux-arm-kernel.infradead.narkive.com/mAf9QhdP/patch-1-5-rando
> m-stackprotect-introduce-get-random-canary-function
> which credits "ascii armor" to execshield and PaX/grsecurity.
> We've never done ascii armoring in PaX/grsecurity and the technique
> was
> created by solar designer in 1997:
> http://insecure.org/sploits/linux.libc.return.lpr.sploit.html
> Exec Shield arrived at least 5 years later.
> 
> -Brad

I've never written a commit message referencing 'ascii armor' or 'exec
shield'. Not something that's ever been on my radar, unlike glibc using
the leading zero byte for the SSP canary even on 32-bit.
