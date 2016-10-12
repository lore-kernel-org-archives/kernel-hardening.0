Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476260846.19479.5.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Wed, 12 Oct 2016 10:27:26 +0200
In-Reply-To: <CAGXu5jK9ZNr+AbVxfAns7PGEiw9NQ5zOp_EG_9dG7i+oeYwyCg@mail.gmail.com>
References: <1476016472.2329.38.camel@cvidal.org>
	 <CAGXu5jK9ZNr+AbVxfAns7PGEiw9NQ5zOp_EG_9dG7i+oeYwyCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] self introduction
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

> > Beside my researches, I am taking up the Eudyptula Challenge (task
> > 15 submitted). It helps me to have a global view of the kernel
> > (organization, tree, some features), but it is not enough to get
> > involved in serious development. Therefore, I am looking for task
> > I can accomplish to be involved into real kernel development!
>
> Hi! Welcome to the fun! :)

Cheers :)

> I see there's already a thread getting into the HARDENED_ATOMIC
> effort, though I thought I might bring up some other areas too, in
> case they entice you as well. You've got some background in control
> flow -- have you spent much time in compiler internals? The recent

Not really on mainstream compilers. I've done some static inter/intra
procedural analysis on previous projects (in order to optimize object
call site), and the compiler of the DSL I'm working on is based on a
completely different theories (it uses Esterel synchronous language
semantic) and does not uses static CFG. Hence, I am quite far of CFI
analysis :(

> addition of the gcc plugin infrastructure means there's a much wider
> ability for the kernel to do compiler tricks now. Two things that
> come to mind for CFI when looking at the existing PaX/Grsecurity gcc
> plugins are the kernexec plugin (which, AIUI, is mainly a weak form
> of SMEP emulation on x86, using simple CFI to keep the high bit set
> on all kernel function calls) which I think would be easy to extract
> as a stand-alone plugin:
>
> https://github.com/linux-scraping/linux-grsecurity/blob/grsec-test/sc
> ripts/gcc-plugins/kernexec_plugin.c

If I understand, this plugin protects against running user-space code
in supervisor mode (SMEP emulation, so avoid ROP class exploit), but
since this analysis is purely static, it does not protects again
out-of-tree dynamically loaded modules, right?

> And at the other end of the spectrum is the RAP plugin (which does a
> portion of PaX's full RAP, though there appear to be some non-trivial
> kernel changes need to support it, e.g. per-cpu PGD):
>
> https://pax.grsecurity.net/docs/PaXTeam-H2HC15-RAP-RIP-ROP.pdf

Seems really interesting, though! I have plenty of food for thought
with HARDENED_ATOMIC port for now, but I keep that in the back of my
mind!

> > I still don't have yet a narrow idea about where I can begin. I
> > like though the idea of kernel self protection. For instance, I
> > find the VM- mapped stack to be really interesting, but I think it
> > is an overkill as a beginning, and a lot of work have already been
> > done on it. On the architecture point-of-view, I have a preference
> > of x86 since I only have this hardware for now, but I can work on
> > ARM and others with QEMU too.
>
> A piece missing from vmap-stack (I think) is having guard pages at
> _both_ ends of the kernel stack. Andy Lutomirski surely knows better
> than I do, but I'm hoping he's working on looking at PCID-based SMAP
> emulation. (Hi Andy!) :)
>
> -Kees

Thanks!

Colin
