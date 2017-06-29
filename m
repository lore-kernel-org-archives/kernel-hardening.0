Date: Thu, 29 Jun 2017 16:13:16 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170629221316.wymc2dzvzgjzse3p@smitten>
References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com>
 <20170623224820.neo5b4k7dxar5mqs@smitten>
 <CAGXu5jLps0PA6uoRGwb3xo_q9q0NBCh786YJtihVU6a74mvduw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLps0PA6uoRGwb3xo_q9q0NBCh786YJtihVU6a74mvduw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH RFC v2 1/1] gcc-plugins: Add stackleak feature erasing
 the kernel stack at the end of syscalls
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 29, 2017 at 02:33:20PM -0700, Kees Cook wrote:
> > One option is to write a kernel module that exposes some device that
> > we could do an ioctl(fd, IO_CHECK_STACK_POISON, pid) or something to
> > check it, but it's not clear how to fit this into the kernel's current
> > testing infrastructure.
> 
> Hmm, so one pid would do deep syscall, return and then spin in
> userspace so its stack could be examined by another thread? I'm
> lacking imagination about how to wire that kind of thing up, though,
> as you say.

Yeah, that's the idea.

> > From 1a5013cdc8f1520a0b220fe92047817a68e0be21 Mon Sep 17 00:00:00 2001
> > From: Tycho Andersen <tycho@docker.com>
> > Date: Thu, 8 Jun 2017 12:43:07 -0600
> > Subject: [PATCH] lkdtm: add a test for STACKLEAK plugin
> >
> > This test does two things: it checks that the current syscall's stack (i.e.
> > the call that's loading the module) is poisoned correctly and then checks
> > that an alloca that will be too large causes a BUG().
> >
> > Ideally we'd be able to check end-to-end that a syscall results in an
> > entirely poisoned stack, but I'm not sure how to do a syscall from lkdtm.
> 
> I like this. I think it needs some tweaking, notes below...

Thanks for taking a look. I'll take the review and roll it into
another version. FWIW, the poison test seems kind of racy for me right
now (sometimes the stack poison is wrong), and I'm still trying to
figure out why.

Cheers,

Tycho
