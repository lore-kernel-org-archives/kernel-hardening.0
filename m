Return-Path: <SRS0=HSlS=U2=lists.openwall.com=kernel-hardening-return-16303-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D672DC48BD7
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 17:29:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 341EF2064A
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 17:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oDEgl6m/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 341EF2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16303-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27979 invoked by uid 550); 27 Jun 2019 17:28:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27958 invoked from network); 27 Jun 2019 17:28:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1BuKXBmmW9/P/7i29LRIiTw7qTDu/2or3umd5ZEV8Lo=;
        b=oDEgl6m/gy5Of4Vf+KJ7EdiB5UApvl/p5nbHKbFmiGRum3SByz96/Z0eBCqFDhdP7H
         tYEuNbeu8qY68ho01JwoUKsD9W6Ay7GZvAIAyenZJMiW5Ux6tDLjV369gNKWlrDRvXJC
         4S5uxcWftfMBu/IA9fb+m76jrdTMv9QSz4qn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1BuKXBmmW9/P/7i29LRIiTw7qTDu/2or3umd5ZEV8Lo=;
        b=cglrSzsKRZf3pmAkHOQQBD159RfmZB/blVZAvWyZuJjgilyZKrxs//pcj4akIlG0Sk
         BgDnrwAV37GpGL4UxyJsF45SVGEVgZ7g4v6Py1cuoFN16HGtLZgWtfKnC9W+YtupSdR2
         SL5X8kaqeolaUrziBxeFJYZ/pKtmsFiLBoRkbJbK/59DsZkYDPhdNXl1jGME1Vun3lwu
         halYfEqij+9XmqdIerOKEP4aLhacNP0aIbWMHFbt1P/wkC3M+WBifmyRKONgrsrnSLtW
         SuP5KUdnN/uFY9bz1amvymu8ZCYrplumVY02+OdlCbvr4kW+jniRukHPNqcc73DVCfly
         10XA==
X-Gm-Message-State: APjAAAWY4A5Sv5oz21irvcbGpEXFCE1ygqiesgxIsopzMwm8CUwTDfxZ
	nZflRUmIwpAxbGnKOHyaQhneEg==
X-Google-Smtp-Source: APXvYqy3tPJAc6F33ZKoDp1dJlxiuk6bL+tlx77piHErqbQ17H3BVnKEMbzBjTSyC6qfYrNj43KOyw==
X-Received: by 2002:a17:90a:730b:: with SMTP id m11mr7289827pjk.89.1561656525785;
        Thu, 27 Jun 2019 10:28:45 -0700 (PDT)
Date: Thu, 27 Jun 2019 10:28:44 -0700
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 4/8] x86/vsyscall: Document odd SIGSEGV error code for
 vsyscalls
Message-ID: <201906271028.00EE29E9E@keescook>
References: <cover.1561610354.git.luto@kernel.org>
 <75c91855fd850649ace162eec5495a1354221aaa.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75c91855fd850649ace162eec5495a1354221aaa.1561610354.git.luto@kernel.org>

On Wed, Jun 26, 2019 at 09:45:05PM -0700, Andy Lutomirski wrote:
> Even if vsyscall=none, we report uer page faults on the vsyscall
> page as though the PROT bit in the error code was set.  Add a
> comment explaining why this is probably okay and display the value
> in the test case.
> 
> While we're at it, explain why our behavior is correct with respect
> to PKRU.
> 
> This also modifies the selftest to print the odd error code so that
> you can run the selftest and see that the behavior is odd.
> 
> If anyone really cares about more accurate emulation, we could
> change the behavior.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/mm/fault.c                         | 7 +++++++
>  tools/testing/selftests/x86/test_vsyscall.c | 9 ++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 288a5462076f..58e4f1f00bbc 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -710,6 +710,10 @@ static void set_signal_archinfo(unsigned long address,
>  	 * To avoid leaking information about the kernel page
>  	 * table layout, pretend that user-mode accesses to
>  	 * kernel addresses are always protection faults.
> +	 *
> +	 * NB: This means that failed vsyscalls with vsyscall=none
> +	 * will have the PROT bit.  This doesn't leak any
> +	 * information and does not appear to cause any problems.
>  	 */
>  	if (address >= TASK_SIZE_MAX)
>  		error_code |= X86_PF_PROT;
> @@ -1375,6 +1379,9 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	 *
>  	 * The vsyscall page does not have a "real" VMA, so do this
>  	 * emulation before we go searching for VMAs.
> +	 *
> +	 * PKRU never rejects instruction fetches, so we don't need
> +	 * to consider the PF_PK bit.
>  	 */
>  	if (is_vsyscall_vaddr(address)) {
>  		if (emulate_vsyscall(hw_error_code, regs, address))
> diff --git a/tools/testing/selftests/x86/test_vsyscall.c b/tools/testing/selftests/x86/test_vsyscall.c
> index 0b4f1cc2291c..4c9a8d76dba0 100644
> --- a/tools/testing/selftests/x86/test_vsyscall.c
> +++ b/tools/testing/selftests/x86/test_vsyscall.c
> @@ -183,9 +183,13 @@ static inline long sys_getcpu(unsigned * cpu, unsigned * node,
>  }
>  
>  static jmp_buf jmpbuf;
> +static volatile unsigned long segv_err;
>  
>  static void sigsegv(int sig, siginfo_t *info, void *ctx_void)
>  {
> +	ucontext_t *ctx = (ucontext_t *)ctx_void;
> +
> +	segv_err =  ctx->uc_mcontext.gregs[REG_ERR];
>  	siglongjmp(jmpbuf, 1);
>  }
>  
> @@ -416,8 +420,11 @@ static int test_vsys_r(void)
>  	} else if (!can_read && should_read_vsyscall) {
>  		printf("[FAIL]\tWe don't have read access, but we should\n");
>  		return 1;
> +	} else if (can_read) {
> +		printf("[OK]\tWe have read access\n");
>  	} else {
> -		printf("[OK]\tgot expected result\n");
> +		printf("[OK]\tWe do not have read access: #PF(0x%lx)\n",
> +		       segv_err);
>  	}
>  #endif
>  
> -- 
> 2.21.0
> 

-- 
Kees Cook
