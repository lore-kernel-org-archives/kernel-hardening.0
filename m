Date: Tue, 27 Mar 2018 13:32:50 +0100
From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 33/38] arm64: Implement thread_struct whitelist for
 hardened usercopy
Message-ID: <20180327123248.GI16308@e103592.cambridge.arm.com>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-34-git-send-email-keescook@chromium.org>
 <20180115122458.GI12608@e103592.cambridge.arm.com>
 <CAGXu5jLHb3BQ9U7g6suoVZwVeETiXiCRbxsprpLNiFxcjcWk1A@mail.gmail.com>
 <20180326162158.GH16308@e103592.cambridge.arm.com>
 <CAGXu5jL1S+CFEruBOaN_yJa7cY+a9gr8cBQgFcYowW=gT5VfSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL1S+CFEruBOaN_yJa7cY+a9gr8cBQgFcYowW=gT5VfSA@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 26, 2018 at 10:41:09AM -0700, Kees Cook wrote:
> On Mon, Mar 26, 2018 at 9:22 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> > [Dropped most of the original Cc list, since most people are unlikely to
> > care about this thread archaeology.]
> >
> > On Mon, Jan 15, 2018 at 12:06:17PM -0800, Kees Cook wrote:
> >> On Mon, Jan 15, 2018 at 4:24 AM, Dave P Martin <Dave.Martin@arm.com> wrote:
> >> > On Thu, Jan 11, 2018 at 02:03:05AM +0000, Kees Cook wrote:
> >> >> This whitelists the FPU register state portion of the thread_struct for
> >> >> copying to userspace, instead of the default entire structure.
> >> >>
> >> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> >> Cc: Will Deacon <will.deacon@arm.com>
> >> >> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> >> >> Cc: Ingo Molnar <mingo@kernel.org>
> >> >> Cc: James Morse <james.morse@arm.com>
> >> >> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> >> >> Cc: Dave Martin <Dave.Martin@arm.com>
> >> >> Cc: zijun_hu <zijun_hu@htc.com>
> >> >> Cc: linux-arm-kernel@lists.infradead.org
> >> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> >> ---
> >> >>  arch/arm64/Kconfig                 | 1 +
> >> >>  arch/arm64/include/asm/processor.h | 8 ++++++++
> >> >>  2 files changed, 9 insertions(+)
> >> >>
> >> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >> >> index a93339f5178f..c84477e6a884 100644
> >> >> --- a/arch/arm64/Kconfig
> >> >> +++ b/arch/arm64/Kconfig
> >> >> @@ -90,6 +90,7 @@ config ARM64
> >> >>       select HAVE_ARCH_MMAP_RND_BITS
> >> >>       select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
> >> >>       select HAVE_ARCH_SECCOMP_FILTER
> >> >> +     select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> >> >>       select HAVE_ARCH_TRACEHOOK
> >> >>       select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> >> >>       select HAVE_ARCH_VMAP_STACK
> >> >> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> >> >> index 023cacb946c3..e58a5864ec89 100644
> >> >> --- a/arch/arm64/include/asm/processor.h
> >> >> +++ b/arch/arm64/include/asm/processor.h
> >> >> @@ -113,6 +113,14 @@ struct thread_struct {
> >> >>       struct debug_info       debug;          /* debugging */
> >> >>  };
> >> >>
> >> >> +/* Whitelist the fpsimd_state for copying to userspace. */
> >> >> +static inline void arch_thread_struct_whitelist(unsigned long *offset,
> >> >> +                                             unsigned long *size)
> >> >> +{
> >> >> +     *offset = offsetof(struct thread_struct, fpsimd_state);
> >> >> +     *size = sizeof(struct fpsimd_state);
> >> >
> >> > This should be fpsimd_state.user_fpsimd (fpsimd_state.cpu is important
> >> > for correctly context switching and not supposed to be user-accessible.
> >> > A user copy that encompasses that is definitely a bug).
> >>
> >> So, I actually spent some more time looking at this due to the
> >> comments from rmk on arm32, and I don't think any whitelist is needed
> >> here at all. (i.e. it can be *offset = *size = 0) This is because all
> >> the usercopying I could find uses static sizes or bounce buffers, both
> >> of which bypass the dynamic-size hardened usercopy checks.
> >>
> >> I've been running some arm64 builds now with this change, and I
> >> haven't tripped over any problems yet...
> >
> > Hmmm, it looks like we may be hitting this with user_regset_copyout()
> > when reading the fp regs via ptrace.  This is maybe not surprising,
> 
> Did you get one of the WARNs for it?

Mark Rutland got it by running Syzkaller, but it's easily reproducible
with CONFIG_HARDENED_USERCOPY enabled.

> > since the size comes from userspace for PTRACE_{GET,SET}REGSET.
> > Also, while we copy into a bounce buffer for SETREGSET here, we do copy
> > straight out of task_struct for GETREGSET here.
> 
> Hm, yeah,
> 
> > This suggests we should have:
> >
> >         *offset = offsetof(struct thread_struct, fpsimd_state);
> >         *size = sizeof(struct user_fpsimd_state);
> 
> This is what I had originally for arm64, but when I tried exercising
> this code more recently, it didn't need the whitelist. It really looks
> like I forgot what I had tested the first time, though. :P
> 
> > Thoughts?
> 
> Seems like it would be tripped by:
> 
> static int __fpr_get(struct task_struct *target,
>                      const struct user_regset *regset,
>                      unsigned int pos, unsigned int count,
>                      void *kbuf, void __user *ubuf, unsigned int start_pos)
> {
>         struct user_fpsimd_state *uregs;
> 
>         sve_sync_to_fpsimd(target);
> 
>         uregs = &target->thread.fpsimd_state.user_fpsimd;
> 
>         return user_regset_copyout(&pos, &count, &kbuf, &ubuf, uregs,
>                                    start_pos, start_pos + sizeof(*uregs));
> }
> 
> And similarly __fpr_set(), compat_vfp_get(), compat_vfp_set(),
> sve_get(), and sve_set(), ?

All are probably affected except for __fpr_set() which uses a bounce
buffer.  I'm not sure why though: compat_vfp_set() doesn't use a bounce
buffer, though it's not trying to do anything different.

> > I'm making some assumptions about how the usercopy hardening works.
> 
> I think you're right -- I just tricked myself after looking at arm32.

OK, I'll send a patch once we've retested.

Cheers
---Dave
