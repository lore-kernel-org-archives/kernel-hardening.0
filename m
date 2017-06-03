Message-ID: <1496492216.21640.3.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 03 Jun 2017 08:16:56 -0400
In-Reply-To: <CAGXu5j+MhA=B3cGZR+btdhz1VNM01uoWFOc2D0bKGJc0Y76q9A@mail.gmail.com>
References: <20170602152010.2064-1-riel@redhat.com>
	 <20170602152010.2064-4-riel@redhat.com>
	 <CAGXu5j+MhA=B3cGZR+btdhz1VNM01uoWFOc2D0bKGJc0Y76q9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 3/6] x86/mmap: properly account for
 stack randomization in mmap_base
To: Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Larry Woodman <lwoodman@redhat.com>, mhocko@suse.de, Will Deacon <will.deacon@arm.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-06-02 at 21:46 -0700, Kees Cook wrote:
> On Fri, Jun 2, 2017 at 8:20 AM,  <riel@redhat.com> wrote:
> > From: Rik van Riel <riel@redhat.com>
> > 
> > When RLIMIT_STACK is, for example, 256MB, the current code results
> > in
> > a gap between the top of the task and mmap_base of 256MB, failing to
> > take into account the amount by which the stack address was
> > randomized.
> > In other words, the stack gets less than RLIMIT_STACK space.
> 
> Is this entirely accurate? The top of the task would be task_size, but
> this code is using task_size / 6 * 5 as the bottom of stack / top of
> mmap gap_max. Is there a reason for this?

MIN_GAP / MAX_GAP are only the boundaries that this gap is clamped to.

If it's not smaller than MIN_GAP, MIN_GAP isn't used. If it's not larger
than MAX_GAP, MAX_GAP isn't used. The stack randomization is currently
only taken into account for MIN_GAP. This only fixes that bug by always
taking it into account. It's not a subjective design change.

The MAX_GAP value is 5/6 of the address space which is overly large but
that's a separate bug.
