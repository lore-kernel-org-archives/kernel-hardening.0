Return-Path: <SRS0=N4b/=5N=lists.openwall.com=kernel-hardening-return-18274-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC15C43331
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 22:27:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7383B20714
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 22:27:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="R6dijiNn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7383B20714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18274-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24193 invoked by uid 550); 28 Mar 2020 22:26:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24158 invoked from network); 28 Mar 2020 22:26:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I449BRJgedsSivIUojFSGlUr7SW0PD6XbCp1RY7ckCM=;
        b=R6dijiNnIGvlrdz/LQlTPtBAm1fuVdrIyT1rEN6d57HB22MPKyolrj2fViPcfIP+zy
         4O+MU80uB8/DRKyPw/z9pKEG01b2k8uwV9fqfkgdZdfNg+pUP51naSDHX1bXEnkzR+io
         yMlJpSHEuuISEw4k/+SDzjTgDqEmje8AQuNos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I449BRJgedsSivIUojFSGlUr7SW0PD6XbCp1RY7ckCM=;
        b=Sa6e8kZo8HFgJxUWp5tRRxw79IB377ZxjHprcnPxYW+YVXzsHaGneiaOdOydYTbCUa
         aSK/IMNuhopXa7BqADq2kF87SCoZ5j8Zin9djIiITSwCg37OyBmR0PCwVIZQ1vmrzq44
         PTHPCM0X6eIKuoe+Jv9F4NyQAbmZ1LF4mtTlO7nGNTUQk6rKfxxASLbebDJPNRvmjdAo
         B9YduQJEEyvvG1KWTr2uJflafbkZ5H9s6VoSvV2JEIrLzES6SfLje+xHnlZFzRBMu8wu
         /Ii2CM19IwejOMc/nM1PnniYqiT5bQrBEFx6KTGOR2wWnNDXlscYnFOTvBaM1/fbOHHX
         +oqQ==
X-Gm-Message-State: AGi0PuY1FXJyhcgGyxhJweF9MgBVWuw5egBswwYThSxUIyPfCFSiNiS4
	VlKukLx/DYfnPP3Gh+P3wSdrgQ==
X-Google-Smtp-Source: APiQypKzsQBsasJUhTY1iSTW4oocv7YTHqUrrfDWiF0W34WrwDjKao4vSCoTbxgj3zPXUf3E+WdlUQ==
X-Received: by 2002:a63:5744:: with SMTP id h4mr2535885pgm.235.1585434404738;
        Sat, 28 Mar 2020 15:26:44 -0700 (PDT)
Date: Sat, 28 Mar 2020 15:26:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] x86/entry: Enable random_kstack_offset support
Message-ID: <202003281520.A9BFF461@keescook>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-5-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324203231.64324-5-keescook@chromium.org>

On Tue, Mar 24, 2020 at 01:32:30PM -0700, Kees Cook wrote:
> Allow for a randomized stack offset on a per-syscall basis, with roughly
> 5 bits of entropy.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/Kconfig        |  1 +
>  arch/x86/entry/common.c | 12 +++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index beea77046f9b..b9d449581eb6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -150,6 +150,7 @@ config X86
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
>  	select HAVE_ARCH_VMAP_STACK		if X86_64
> +	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
>  	select HAVE_ARCH_WITHIN_STACK_FRAMES
>  	select HAVE_ASM_MODVERSIONS
>  	select HAVE_CMPXCHG_DOUBLE
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 9747876980b5..086d7af570af 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -26,6 +26,7 @@
>  #include <linux/livepatch.h>
>  #include <linux/syscalls.h>
>  #include <linux/uaccess.h>
> +#include <linux/randomize_kstack.h>
>  
>  #include <asm/desc.h>
>  #include <asm/traps.h>
> @@ -189,6 +190,13 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
>  	lockdep_assert_irqs_disabled();
>  	lockdep_sys_exit();
>  
> +	/*
> +	 * x86_64 stack alignment means 3 bits are ignored, so keep
> +	 * the top 5 bits. x86_32 needs only 2 bits of alignment, so
> +	 * the top 6 bits will be used.
> +	 */
> +	choose_random_kstack_offset(rdtsc() & 0xFF);
> +
>  	cached_flags = READ_ONCE(ti->flags);
>  
>  	if (unlikely(cached_flags & EXIT_TO_USERMODE_LOOP_FLAGS))
> @@ -283,6 +291,7 @@ __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
>  {
>  	struct thread_info *ti;
>  
> +	add_random_kstack_offset();
>  	enter_from_user_mode();
>  	local_irq_enable();
>  	ti = current_thread_info();

So, I got an email from 0day that this caused a performance regression[1]
with things _turned off_. On closer examination:

Before (objdump -dS vmlinux):

__visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
{
ffffffff81003920:       41 54                   push   %r12
ffffffff81003922:       55                      push   %rbp
ffffffff81003923:       48 89 f5                mov    %rsi,%rbp
ffffffff81003926:       53                      push   %rbx
ffffffff81003927:       48 89 fb                mov    %rdi,%rbx
        struct thread_info *ti;

        enter_from_user_mode();
        local_irq_enable();
...


After:

__visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
{ 
ffffffff81003960:       55                      push   %rbp
ffffffff81003961:       48 89 e5                mov    %rsp,%rbp
ffffffff81003964:       41 55                   push   %r13
ffffffff81003966:       41 54                   push   %r12
ffffffff81003968:       49 89 f4                mov    %rsi,%r12
ffffffff8100396b:       53                      push   %rbx
ffffffff8100396c:       48 89 fb                mov    %rdi,%rbx
ffffffff8100396f:       48 83 ec 08             sub    $0x8,%rsp
ffffffff81003973:       65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
ffffffff8100397a:       00 00 
ffffffff8100397c:       48 89 45 e0             mov    %rax,-0x20(%rbp)
ffffffff81003980:       31 c0                   xor    %eax,%eax
        asm_volatile_goto("1:"
ffffffff81003982:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
        struct thread_info *ti;

        add_random_kstack_offset();
        enter_from_user_mode();
        local_irq_enable();

The "nopl" there is the static_branch code that I'd expect. However, the
preample is quite different. *drum roll* Anyone else recognize %gs:0x28?

That's the stack canary. :P It seems that GCC views this as an array:

                char *ptr = __builtin_alloca(offset & 0x3FF);
                asm volatile("" : "=m"(*ptr));

because it's locally allocated on the stack. *face palm*

I'll go figure out a way to fix this...

-Kees

[1] https://lore.kernel.org/lkml/202003281505.0F481D3@keescook/

-- 
Kees Cook
