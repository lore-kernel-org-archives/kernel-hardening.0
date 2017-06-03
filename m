MIME-Version: 1.0
In-Reply-To: <20170603142110.GA7578@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net> <1496498027.22395.1.camel@gmail.com>
 <20170603142110.GA7578@grsecurity.net>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 3 Jun 2017 11:55:04 -0400
Message-ID: <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 3 June 2017 at 10:21, Brad Spengler <spender@grsecurity.net> wrote:
> commit 813d0df7042a8430481d245618cbab39b76876fc
> Author: Brad Spengler <spender@grsecurity.net>
> Date:   Sat Jul 25 11:28:15 2015 -0400
>
>     Implement modify_ldt sysctl toggle from https://lkml.org/lkml/2015/7/25/103,
>     make it not depend on CONFIG_MODIFY_LDT_SYSCALL, force modify_ldt to off
>     regardless of config setting if grsec is enabled (with the allowance to
>     turn it on at runtime), and harden up the implementation a bit
>
>     Conflicts:
>
>         arch/x86/Kconfig
>         kernel/sysctl.c
>
>
> It's right there in the changelogs (which you can still find online).  Here's a
> google cache entry for the link:
> https://webcache.googleusercontent.com/search?q=cache:2IlruFKV2RIJ:https://lkml.org/lkml/2015/7/25/103+&cd=1&hl=en&ct=clnk&gl=us
> I did not and have never removed someone's copyright notice and added my
> own to the copy+pasted code, as is the case of what's happening here
> that I'm complaining about and that I had to complain about in the past
> when Intel did it.

That's what I said: at one point, it was mentioned in a changelog
which was removed when grsecurity moved to the next major kernel
version along with other cases. The attribution wasn't made in the
patch and there isn't anything similar to the Linux kernel's Git
history providing a long-term attribution. Only changelogs that were
removed after each major release and are now entirely gone. It's as if
you've taken ownership of the code. A third party archive of your
changelogs hosted lesewhere and the fact that it can be found via a
search doesn't really change that there isn't attribution in the
patches either via available commit history or inline comments /
documentation. I'm not saying that wrong. I'm saying that you're
getting mad about something less than that.

A copyright header in a separate file is not exactly the same thing.
Lawyers like to have the headers in every file so it doesn't get lost
if a file is extracted / distributed alone, especially if people don't
look at the other files. It doesn't really work because it's normal to
move code around between files with different headers and to base code
on other files without copying headers back and forth everywhere,
which is definitely true for grsecurity. It's not as if there wasn't
attribution given. It's not attribution in the form you want and when
people do give you attribution you talk about them coasting on your
reputation or implying that their interpretation of the code is
comparable to where it came from. If they independently write the
features without using your code as a reference (KSTACKOVERFLOW vs.
VMAP_STACK, ARM memory domain PAN emulation), you're not happy with
that either. You simply don't think it's right for any features that
are in grsecurity to land upstream in any form. No matter how it
happens, you'll see it as wrong / plagiarism. If it's done entirely
separate from upstream (as it was in CopperheadOS), you've never had
an issue with it. You weren't truly interested in being paid to
upstream it yourself either, only to develop code downstream in a
massive out-of-tree patch set.

It was only a few years ago that you were arguing that upstream should
take these features from grsecurity. How was that supposed to happen
then?

> Unlike you and the KSPP, our security reputation isn't entirely based on
> the work of others.  If properly crediting work is such a difficult problem
> that you don't want to be bothered with, there's a very simple solution:
> come up with your own ideas and write your own code!

I don't do much Linux kernel work in the first place... that hasn't
been what I've worked on and I don't have a problem with crediting
you. You've only taken issue with a tweet where I said 'from PaX /
grsecurity' instead of clarifying that it came from the last publicly
available patch. Sending me a legal threat over that tweet was
ridiculous especially considering that the post linked to by that
thread of tweets even already did what you want: stating it's a
comparison with the last publicly available patch. You also took issue
with a stack canary fix which you're adamant must have come from PaX
but that's not what happened: it was noticed and fixed when adding a
zero byte there to match the earlier changes changing userspace junk
filling to zeroing and adding a zero byte to the heap canaries and
stack canaries in userspace.

And how is grsecurity not entirely based on the work of others i.e.
the Linux kernel, just as CopperheadOS is based on Android Open Source
Project and all of the baseline functionality and security model
provided by it?

It wasn't until I turned the CopperheadOS kernel change set into
linux-hardened for mainline that you had a problem with it and I doubt
you would have been against it if the intention wasn't to upstream any
of it and you weren't already mad at me simply for pointing out that
the USERCOPY useroffset/usersize feature exists along with the slub
free list XOR mangling, which I find ridiculous. It's it being
upstreamed that bothers you.
