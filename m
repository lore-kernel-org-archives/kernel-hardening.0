Date: Mon, 14 Aug 2017 14:29:47 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170814202947.er7uparyhplm77ei@smitten>
References: <20170809200755.11234-1-tycho@docker.com>
 <20170809200755.11234-11-tycho@docker.com>
 <CAGXu5jLp11wqM04L5bWbmSVZBTOYnuGNjsjTitzUOFJm=pn9Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLp11wqM04L5bWbmSVZBTOYnuGNjsjTitzUOFJm=pn9Fg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v5 10/10] lkdtm: Add test for XPFO
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 12:10:47PM -0700, Kees Cook wrote:
> On Wed, Aug 9, 2017 at 1:07 PM, Tycho Andersen <tycho@docker.com> wrote:
> > From: Juerg Haefliger <juerg.haefliger@hpe.com>
> >
> > This test simply reads from userspace memory via the kernel's linear
> > map.
> >
> > hugepages is only supported on x86 right now, hence the ifdef.
> 
> I'd prefer that the #ifdef is handled in the .c file. The result is
> that all architectures will have the XPFO_READ_USER_HUGE test, but it
> can just fail when not available. This means no changes are needed for
> lkdtm in the future and the test provides an actual test of hugepages
> coverage.

If failing tests is okay, I think we can just drop that hunk entirely.
Everything compiles fine, it just doesn't work :). I'll do that for
the next version.

Tycho
