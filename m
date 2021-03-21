Return-Path: <SRS0=RX8u=IT=lists.openwall.com=kernel-hardening-return-21024-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AF9C433C1
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 17:04:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 48D0F61920
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 17:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48D0F61920
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21024-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17759 invoked by uid 550); 21 Mar 2021 17:04:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17736 invoked from network); 21 Mar 2021 17:04:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t6QjqKPe2nTK/PNzThmSOWe7GdZqbg6jHmNdZttH5JY=;
        b=kS0l+gnw6EHePRjrc1IKP71VOtAYgrJ/DvSJI87MecLBwpXsLwucas1kVL44njHOJD
         Khoo0uVVUFRXCYmj4hVz4zS64uDP+RLLOH01d0sBCMXWt/rX8Ya9tRjKEiNqtQRBPi0x
         wkZZ6b6gOyBIeboYXlFaaOlvX2/Ui7wcSKz8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t6QjqKPe2nTK/PNzThmSOWe7GdZqbg6jHmNdZttH5JY=;
        b=f9nR1G6fVfZ33vxFxN0GIyDJQQagsfW5Uj6w7LBv+RpXeUo+qcF4fGDoOJTOasDPGt
         wd589xhEtwbBlRoIgFCk7RDtZC02nFx48tNz1fCEEYWHvzFaIAVhLU+jAJI1gk7lJ0hZ
         lRjrBE2IhkIx62TU6Ja/FZtkmAJt+xqr8VWGgLbAwPZVNeNMIzqZwZNGaIIiS2TmGmyL
         OAqg87aBkypjZk1lEl/3ZmildCzoJyAIpNOj6V61VAjNVpxyJ08PyvnWHKSCJyVpAdCU
         22+Xyrc5HdnSSCkX/3DnvbOsDQcocZ4cWj10vGYmhwA6uB4VxspL3Y6tWqiv31LQ3aTt
         guEw==
X-Gm-Message-State: AOAM532b9m5/AHRMTxzG8IZXp+K6hwthqy2HT1sbn6Mgnn8n3xsosZh2
	YWR1E14HjRB2Sl88sByZEkokLg==
X-Google-Smtp-Source: ABdhPJwYdOzaG5EX8VfuaSd/pv73OKX7Gdj5qaTHa4vBEGnBqdu/yXDr+Yzf5Pmcf6GbAWD8fFNpIQ==
X-Received: by 2002:a63:d17:: with SMTP id c23mr19993736pgl.251.1616346234415;
        Sun, 21 Mar 2021 10:03:54 -0700 (PDT)
Date: Sun, 21 Mar 2021 10:03:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 4/6] x86/entry: Enable random_kstack_offset support
Message-ID: <202103210944.6EA6C80@keescook>
References: <20210319212835.3928492-1-keescook@chromium.org>
 <20210319212835.3928492-5-keescook@chromium.org>
 <20210320115820.GA4151166@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320115820.GA4151166@gmail.com>

On Sat, Mar 20, 2021 at 12:58:20PM +0100, Ingo Molnar wrote:
> 
> * Kees Cook <keescook@chromium.org> wrote:
> 
> > Allow for a randomized stack offset on a per-syscall basis, with roughly
> > 5-6 bits of entropy, depending on compiler and word size. Since the
> > method of offsetting uses macros, this cannot live in the common entry
> > code (the stack offset needs to be retained for the life of the syscall,
> > which means it needs to happen at the actual entry point).
> 
> >  __visible noinstr void do_syscall_64(unsigned long nr, struct pt_regs *regs)
> >  {
> > +	add_random_kstack_offset();
> >  	nr = syscall_enter_from_user_mode(regs, nr);
> 
> > @@ -83,6 +84,7 @@ __visible noinstr void do_int80_syscall_32(struct pt_regs *regs)
> >  {
> >  	unsigned int nr = syscall_32_enter(regs);
> >  
> > +	add_random_kstack_offset();
> 
> >  	unsigned int nr = syscall_32_enter(regs);
> >  	int res;
> >  
> > +	add_random_kstack_offset();
> 
> > @@ -70,6 +71,13 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
> >  	 */
> >  	current_thread_info()->status &= ~(TS_COMPAT | TS_I386_REGS_POKED);
> >  #endif
> > +
> > +	/*
> > +	 * x86_64 stack alignment means 3 bits are ignored, so keep
> > +	 * the top 5 bits. x86_32 needs only 2 bits of alignment, so
> > +	 * the top 6 bits will be used.
> > +	 */
> > +	choose_random_kstack_offset(rdtsc() & 0xFF);
> >  }
> 
> 1)
> 
> Wondering why the calculation of the kstack offset (which happens in 
> every syscall) is separated from the entry-time logic and happens 
> during return to user-space?
> 
> The two methods:
> 
> +#define add_random_kstack_offset() do {                                        \
> +       if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT, \
> +                               &randomize_kstack_offset)) {            \
> +               u32 offset = this_cpu_read(kstack_offset);              \
> +               u8 *ptr = __builtin_alloca(offset & 0x3FF);             \
> +               asm volatile("" : "=m"(*ptr) :: "memory");              \
> +       }                                                               \
> +} while (0)
> +
> +#define choose_random_kstack_offset(rand) do {                         \
> +       if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT, \
> +                               &randomize_kstack_offset)) {            \
> +               u32 offset = this_cpu_read(kstack_offset);              \
> +               offset ^= (rand);                                       \
> +               this_cpu_write(kstack_offset, offset);                  \
> +       }                                                               \
> +} while (0)
> 
> choose_random_kstack_offset() basically calculates the offset and 
> stores it in a percpu variable (mixing it with the previous offset 
> value), add_random_kstack_offset() uses it in an alloca() dynamic 
> stack allocation.
> 
> Wouldn't it be (slightly) lower combined overhead to just do it in a 
> single step? There would be duplication along the 3 syscall entry 
> points, but this should be marginal as this looks small, and the entry 
> points would probably be cache-hot.

In earlier threads it was pointed out that one way to make things less
predictable was to do the calculation at the end of a syscall so that it
was more distant from entering userspace (with the thinking that things
like rdtsc were more predictable by userspace if it was always happening
X cycles after entering a syscall). Additionally, the idea of using
percpu meant that the chosen values wouldn't be tied to a process,
making even "short" syscalls (i.e. getpid) less predictable because an
attacker would need to have pinned the process to a single CPU, etc.

I can include these details more explicitly in the next change log, if
you think that makes sense?

> 2)
> 
> Another detail I noticed: add_random_kstack_offset() limits the offset 
> to 0x3ff, or 1k - 10 bits.
> 
> But the RDTSC mask is 0xff, 8 bits:
> 
> +       /*
> +        * x86_64 stack alignment means 3 bits are ignored, so keep
> +        * the top 5 bits. x86_32 needs only 2 bits of alignment, so
> +        * the top 6 bits will be used.
> +        */
> +       choose_random_kstack_offset(rdtsc() & 0xFF);
> 
> alloca() itself works in byte units and will round the allocation to 8 
> bytes on x86-64, to 4 bytes on x86-32, this is what the 'ignored bits' 
> reference in the comment is to, right?
> 
> Why is there a 0x3ff mask for the alloca() call and a 0xff mask to the 
> RDTSC randomizing value? Shouldn't the two be synced up? Or was the 
> intention to shift the RDTSC value to the left by 3 bits?

Yes, it's intentional -- the 0x3ff limit is there to make sure the
alloca has a distinct upper bound, and the 8 bits is there to let the
compiler choose how much of those 8 bits it wants to throw away to stack
alignment. The limit to "at most 8 bits" (really 5) is chosen as a
middle ground between raising unpredictability without shrinking the
available stack space too much. (Note that arm64's alignment has to
tweak this by 1 more bit, so it is masking with 0x1ff.

I could attempt to adjust the comments to reflect these considerations.

> 3)
> 
> Finally, kstack_offset is a percpu variable:
> 
>   #ifdef CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
>   ...
>   DEFINE_PER_CPU(u32, kstack_offset);
> 
> This is inherited across tasks on scheduling, and new syscalls will 
> mix in new RDTSC values to continue to randomize the offset.
> 
> Wouldn't it make sense to further mix values into this across context 
> switching boundaries? A really inexpensive way would be to take the 
> kernel stack value and mix it into the offset, and maybe even the 
> randomized t->stack_canary value?
> 
> This would further isolate the syscall kernel stack offsets of 
> separate execution contexts from each other, should an attacker find a 
> way to estimate or influence likely RDTSC values.

I think this was discussed at some point too, though my search-foo is
failing me. I'm open to adding this to the mix, though care is needed
for both stack address and stack canary values, since they both have
specific structure (i.e. high and low bits of address are "known", and
low bits of canary are always zero) and we don't want to run the risk
of entangling secret values: if one can be exposed, does the entangling
expose the others?

I've had to deal with both of these issues with the slab freelist pointer
obfuscation, so my instinct here is to avoid mixing the other values in.
I'm open to improving it, of course, but I think rdtsc is a good first
step.

-- 
Kees Cook
