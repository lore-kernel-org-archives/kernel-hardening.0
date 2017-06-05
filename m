Message-ID: <1496670876.29205.119.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Mon, 05 Jun 2017 09:54:36 -0400
In-Reply-To: <CAGXu5jJp-U2o9JEicyvM=205P7072kN_UCwh7=+UNJ2Z1HWKvg@mail.gmail.com>
References: <20170602152010.2064-1-riel@redhat.com>
	 <20170602152010.2064-3-riel@redhat.com>
	 <CAGXu5jJp-U2o9JEicyvM=205P7072kN_UCwh7=+UNJ2Z1HWKvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/6] x86/elf: move 32 bit ELF_ET_DYN_BASE to 256MB
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Larry Woodman <lwoodman@redhat.com>, mhocko@suse.de, Daniel Micay <danielmicay@gmail.com>, Will Deacon <will.deacon@arm.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-06-02 at 21:22 -0700, Kees Cook wrote:

> As a result of these things, I'm not sure I like the 256MB change, as
> I'd rather we get the PIE base as low as possible. I *think* this
> should match the ET_EXEC addresses: 32-bit x86 ET_EXEC loads at
> 0x8048000. 64-bit x86 ET_EXEC loads at 0x400000 (though maybe we can
> take 32-bit lower still). However, the kernel needs to notice that
> when running a loader, it should go into the mmap base like a .so,
> which will keep out out of the way no matter what. However, then the
> question becomes "can the brk be placed sanely?" since the brk is
> allocated with whatever is mapped first.

The problem is that the brk is allocated when the loader
is loaded, before the loader maps that second executable.

In other words, the problem has been changed from
"where to place the loader?" to "where to place the
brk?, but remains fundamentally the same.

> I think loading an ET_DYN that lacks PT_INTERP should be mapped
into
> the mmap base so that we can lower ELF_ET_DYN_BASE as far as possible
> in the address space without concern over ET_EXEC collisions.
> (ELF_ET_DYN_BASE should be named ELF_PIE_BASE maybe, since it
> shouldn't be exclusively used for ET_DYN, it should only be for
> ET_DYN
> with PT_INTERP. ET_DYN without PT_INTERP should get loaded into mmap
> like the .so it is.)
> 
> I'm not sure what to do yet for set_brk() when an ET_DYN without
> PT_INTERP is loaded into mmap base, but we need make sure we don't
> create collisions or inappropriately small brk space.

Exactly, we end up with placing the brk at ELF_ET_DYN_BASE +
randomization, instead of placing the interpreter and the
brk there. I don't see how it would help much.

> Additionally, I think we need some runtime checking of the address
> space layout min/max positionns to make sure we can't collide
> anything. (And maybe some pretty ASCII-art to help visualize the
> possible layouts, since we have several sets of variables to take
> into
> account, including: execution style (ET_EXEC, direct loader, and
> PIE),
> sysctl entropy sizing of the regions, and stack rlimit.)

If you want maximum randomization, we should allow things
like having the stack randomized to the bottom of the
address space, and the executable / brk growing up from
some distance above the top of the stack.

Essentially allowing anything to be placed anywhere, and
switching things like executable & mmap placement as a
result of where the stack ends up, etc..
