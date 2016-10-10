Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1476016472.2329.38.camel@cvidal.org>
References: <1476016472.2329.38.camel@cvidal.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Oct 2016 13:57:29 -0700
Message-ID: <CAGXu5jK9ZNr+AbVxfAns7PGEiw9NQ5zOp_EG_9dG7i+oeYwyCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] self introduction
To: Colin Vidal <colin@cvidal.org>, Andy Lutomirski <luto@kernel.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 9, 2016 at 5:34 AM, Colin Vidal <colin@cvidal.org> wrote:
> My name is Colin Vidal. I am currently a PhD student in computer
> science. My researches  consist on building a dedicated specific
> language on top of JavaScript in order to handle asynchronous events in
> a synchronous style. Hence, with a direct relation between the control
> flow and the instruction flow.
>
> Beside my researches, I am taking up the Eudyptula Challenge (task 15
> submitted). It helps me to have a global view of the kernel
> (organization, tree, some features), but it is not enough to get
> involved in serious development. Therefore, I am looking for task I can
> accomplish to be involved into real kernel development!

Hi! Welcome to the fun! :)

I see there's already a thread getting into the HARDENED_ATOMIC
effort, though I thought I might bring up some other areas too, in
case they entice you as well. You've got some background in control
flow -- have you spent much time in compiler internals? The recent
addition of the gcc plugin infrastructure means there's a much wider
ability for the kernel to do compiler tricks now. Two things that come
to mind for CFI when looking at the existing PaX/Grsecurity gcc
plugins are the kernexec plugin (which, AIUI, is mainly a weak form of
SMEP emulation on x86, using simple CFI to keep the high bit set on
all kernel function calls) which I think would be easy to extract as a
stand-alone plugin:

https://github.com/linux-scraping/linux-grsecurity/blob/grsec-test/scripts/gcc-plugins/kernexec_plugin.c

And at the other end of the spectrum is the RAP plugin (which does a
portion of PaX's full RAP, though there appear to be some non-trivial
kernel changes need to support it, e.g. per-cpu PGD):

https://pax.grsecurity.net/docs/PaXTeam-H2HC15-RAP-RIP-ROP.pdf

> I still don't have yet a narrow idea about where I can begin. I like
> though the idea of kernel self protection. For instance, I find the VM-
> mapped stack to be really interesting, but I think it is an overkill as
> a beginning, and a lot of work have already been done on it. On the
> architecture point-of-view, I have a preference of x86 since I only
> have this hardware for now, but I can work on ARM and others with QEMU
> too.

A piece missing from vmap-stack (I think) is having guard pages at
_both_ ends of the kernel stack. Andy Lutomirski surely knows better
than I do, but I'm hoping he's working on looking at PCID-based SMAP
emulation. (Hi Andy!) :)

-Kees

-- 
Kees Cook
Nexus Security
