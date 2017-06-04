Message-ID: <1496585753.11788.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sun, 04 Jun 2017 10:15:53 -0400
In-Reply-To: <20170604032813.GB25424@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
	 <1496498027.22395.1.camel@gmail.com> <20170603142110.GA7578@grsecurity.net>
	 <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
	 <20170604032813.GB25424@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> Cryptomnesia I guess, you looked at every other line of PaX to rip out
> stuff like:

Searching for __read_only and categorizing them as ones requiring
pax_open_kernel and not requiring it != reading the entire patch set
line by line, and you have the timeline very wrong.

> when I pointed it out to you.  Are the above changes your own work
> too?

Clearly not, and they aren't submitted upstream like that. I've been
treating it as a scratch space for putting together changes to send
upstream and they haven't all had commit messages written. For the
__ro_after_init changes that I submitted, I wrote commit messages
stating which parts came from PaX. I'll write full commit messages
before pushing there from now on. I hadn't done it for those because I
wasn't finished and I couldn't yet write a commit message that I
wouldn't need to change later.

My knowledge of the SSP canary issue predates making linux-hardened or
being on bad terms from you.

> but totally never saw that line that's been there ever since SSP
existed
> in the kernel.  It also doesn't mesh with your lengthy excuse on
github
> when I pointed it out to you.  Are the above changes your own work
too?

I don't have total knowledge about what exists in PaX. I had no idea
that it made changes like effectively disabling the cr4 caching or
partially protecting page tables on x86 until recently. How would I know
that it made a one line change fixing that stack canary issue? I wasn't
familiar with the ASLR implementation then including the
pax_get_random_long function which it used as the fix.

And yes my "excuse" is consistent with what I said on GitHub. I became
of the stack canary issue when Jann Horn told me about it months ago. I
might have IRC logs from back then. I then assumed it was going to get
fixed and promptly forgot about it as I do with pretty much every other
specific bug. I noticed it again when making related changes in
CopperheadOS but: that's a 3.18 LTS kernel and 3.10 LTS kernels for
older devices, so it didn't occur to me than Jann might not have gotten
it fixed in master, and arm64 doesn't use the per-task canaries so I
didn't need to fix that or add the zero byte there yet. Not sure what is
so hard to understand about that. I noticed it still wasn't fixed when
first making linux-hardened by porting those changes ahead.

If I *had* done research into the issue to point to when it had been
first discovered by someone, I wouldn't have found PaX. You don't have
patches uploaded on the site from before the earliest mailing list post
that you pointed me at, which doesn't mention PaX.

It's a one line fix for a bug that barely even matters. I'm not sure why
it's so important to you that I do impossible historical research (you
don't have the patches uploaded, I don't see them anywhere else) to
figure out who to credit, and as I've pointed out it cannot be assumed
that a change in PaX is something to credit to you or pipacs rather than
a fix you picked up from a mailing list, even if I had access to those
earlier patches and had decided to go on a research expedition to fix a
minor bug.

If it was so important to you that you get credit for fixing the bug,
why didn't you submit it yourself? It was trivial to get it landed when
it was simply sent to the right people without needing any discussion.

> 
> > > And how is grsecurity not entirely based on the work of others
> > > i.e.
> > the Linux kernel, just as CopperheadOS is based on Android Open
> > Source
> > Project and all of the baseline functionality and security model
> > provided by it?
> 
> These false equivalences of yours are nonsense -- anyone can look at
> https://github.com/thestinger/linux-hardened/issues
> and see how utterly dependent you are.  You are comparing apples and
> oranges because you need to to justify your existence.  You didn't
> contribute a line of code to our work in 16 years and now you're
> trying
> to make a name for yourself off our work and reputation.  But you just
> make a fool of yourself when on one hand you're desperately
> copy+pasting
> and on the other trying to pretend you don't depend on it, or that
> your
> dependence on copy+pasting our work is somehow equivalent to building
> on
> top of whatever version of Linux that exists.
> 
> -Brad

The linux-hardened project was just created. The initial work is porting
existing hardening features to a mainline kernel split out as components
since that's the lowest hanging fruit: working towards parity with what
we already had before. Changes like slab canaries, SSP tweaks and
fortify aren't linux-hardened work, they existed in CopperheadOS for a
long time.
