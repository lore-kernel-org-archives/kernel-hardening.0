Return-Path: <SRS0=xFHu=IS=lists.openwall.com=kernel-hardening-return-21016-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B438AC433C1
	for <kernel-hardening@archiver.kernel.org>; Sat, 20 Mar 2021 11:58:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A292561481
	for <kernel-hardening@archiver.kernel.org>; Sat, 20 Mar 2021 11:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A292561481
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21016-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24315 invoked by uid 550); 20 Mar 2021 11:58:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24289 invoked from network); 20 Mar 2021 11:58:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q1S6sOzSSmWv0cJIdKqH5aeKc+ejDOx1KDCFb2YbT3o=;
        b=qpR1PFuQAsHD9BxFuRDr2UgI0M5ZKr1wg73JNKyVGRXQp2STpCUHbOFNXVKc3pYUeU
         BxVh59NlVsKCuKzhWO++s1zTkKdomHSNUUlCTX2S6UNS+I4zg9FgCbRBjeDon1CzZMNK
         ur3VHRNpkiiDHnKnp+3igIpPWc+bJCJEMLRPquJjXjV/NVB5kRpDRjHyVgxKyBNVkxaM
         szDTmEKbH2A2igQ48viQewT3/nFUv2C46SmRvV+HtgcKhuQGm//YLfEhAZGzUWI7sXJu
         XA01inHcYSFdTpjw32pVWcVLYJ6/kHa+a5sLi2kWXCDv4RyMLF/88AOxAZK42GpMgrIp
         gOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Q1S6sOzSSmWv0cJIdKqH5aeKc+ejDOx1KDCFb2YbT3o=;
        b=C+dj73E6prnKNSoE0CWtmE/UOSJ7wdVZDwlFLlbF/9vAUXu5pE4dpiqE91Y7akLHSh
         Bsp3tGDyOhAyvR2L778m007sMv5uh6mYWfS9AmhrLMd0gxOb74ksm47Bf4Q1pr5z0YiI
         zjRGpNMVVzwF43DvlwO9Jpj2SZWvIRuC9WrHOGmF/yYNKUzZ0ZCcf99BFY9SqFZbnzYS
         a2r0Ank7q8uKrfs0kZHrZUrtwG33xKo/MgpM+9YyuJUfb3uVnkT/x9hEMMZfC/t53rTZ
         Rw+01lIp+PfaK8pybGkR9QQ/c9vwOCh/2WdD6LF/nogGnpmAsM0+9pSqSSesakUHCgm3
         JyGA==
X-Gm-Message-State: AOAM531hep5Cz4/DSOfx6JIhVofp8bCxonCOw9cx3lJ58hJoxJm+ZoL5
	6vRjGtiSvv2yohw+/Sz7QPk=
X-Google-Smtp-Source: ABdhPJz01rctCHm86yiIpmHhRp51yZPtxnmqPKRg7nHGuJhzGfxbKyzoIQQxZVmBUirAIENLH5CbDA==
X-Received: by 2002:a05:6402:d4:: with SMTP id i20mr15225084edu.147.1616241503810;
        Sat, 20 Mar 2021 04:58:23 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 20 Mar 2021 12:58:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
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
Message-ID: <20210320115820.GA4151166@gmail.com>
References: <20210319212835.3928492-1-keescook@chromium.org>
 <20210319212835.3928492-5-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319212835.3928492-5-keescook@chromium.org>


* Kees Cook <keescook@chromium.org> wrote:

> Allow for a randomized stack offset on a per-syscall basis, with roughly
> 5-6 bits of entropy, depending on compiler and word size. Since the
> method of offsetting uses macros, this cannot live in the common entry
> code (the stack offset needs to be retained for the life of the syscall,
> which means it needs to happen at the actual entry point).

>  __visible noinstr void do_syscall_64(unsigned long nr, struct pt_regs *regs)
>  {
> +	add_random_kstack_offset();
>  	nr = syscall_enter_from_user_mode(regs, nr);

> @@ -83,6 +84,7 @@ __visible noinstr void do_int80_syscall_32(struct pt_regs *regs)
>  {
>  	unsigned int nr = syscall_32_enter(regs);
>  
> +	add_random_kstack_offset();

>  	unsigned int nr = syscall_32_enter(regs);
>  	int res;
>  
> +	add_random_kstack_offset();

> @@ -70,6 +71,13 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
>  	 */
>  	current_thread_info()->status &= ~(TS_COMPAT | TS_I386_REGS_POKED);
>  #endif
> +
> +	/*
> +	 * x86_64 stack alignment means 3 bits are ignored, so keep
> +	 * the top 5 bits. x86_32 needs only 2 bits of alignment, so
> +	 * the top 6 bits will be used.
> +	 */
> +	choose_random_kstack_offset(rdtsc() & 0xFF);
>  }

1)

Wondering why the calculation of the kstack offset (which happens in 
every syscall) is separated from the entry-time logic and happens 
during return to user-space?

The two methods:

+#define add_random_kstack_offset() do {                                        \
+       if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT, \
+                               &randomize_kstack_offset)) {            \
+               u32 offset = this_cpu_read(kstack_offset);              \
+               u8 *ptr = __builtin_alloca(offset & 0x3FF);             \
+               asm volatile("" : "=m"(*ptr) :: "memory");              \
+       }                                                               \
+} while (0)
+
+#define choose_random_kstack_offset(rand) do {                         \
+       if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT, \
+                               &randomize_kstack_offset)) {            \
+               u32 offset = this_cpu_read(kstack_offset);              \
+               offset ^= (rand);                                       \
+               this_cpu_write(kstack_offset, offset);                  \
+       }                                                               \
+} while (0)

choose_random_kstack_offset() basically calculates the offset and 
stores it in a percpu variable (mixing it with the previous offset 
value), add_random_kstack_offset() uses it in an alloca() dynamic 
stack allocation.

Wouldn't it be (slightly) lower combined overhead to just do it in a 
single step? There would be duplication along the 3 syscall entry 
points, but this should be marginal as this looks small, and the entry 
points would probably be cache-hot.

2)

Another detail I noticed: add_random_kstack_offset() limits the offset 
to 0x3ff, or 1k - 10 bits.

But the RDTSC mask is 0xff, 8 bits:

+       /*
+        * x86_64 stack alignment means 3 bits are ignored, so keep
+        * the top 5 bits. x86_32 needs only 2 bits of alignment, so
+        * the top 6 bits will be used.
+        */
+       choose_random_kstack_offset(rdtsc() & 0xFF);

alloca() itself works in byte units and will round the allocation to 8 
bytes on x86-64, to 4 bytes on x86-32, this is what the 'ignored bits' 
reference in the comment is to, right?

Why is there a 0x3ff mask for the alloca() call and a 0xff mask to the 
RDTSC randomizing value? Shouldn't the two be synced up? Or was the 
intention to shift the RDTSC value to the left by 3 bits?

3)

Finally, kstack_offset is a percpu variable:

  #ifdef CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
  ...
  DEFINE_PER_CPU(u32, kstack_offset);

This is inherited across tasks on scheduling, and new syscalls will 
mix in new RDTSC values to continue to randomize the offset.

Wouldn't it make sense to further mix values into this across context 
switching boundaries? A really inexpensive way would be to take the 
kernel stack value and mix it into the offset, and maybe even the 
randomized t->stack_canary value?

This would further isolate the syscall kernel stack offsets of 
separate execution contexts from each other, should an attacker find a 
way to estimate or influence likely RDTSC values.

Thanks,

	Ingo
