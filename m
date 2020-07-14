Return-Path: <SRS0=z99o=AZ=lists.openwall.com=kernel-hardening-return-19321-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD26C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 21:25:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 62CA120658
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 21:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="n3UTIs7m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62CA120658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19321-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32477 invoked by uid 550); 14 Jul 2020 21:24:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32444 invoked from network); 14 Jul 2020 21:24:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eIAevkBeaME9YWTUo8UY0ZyBLFbUSSkkyRhcPQcy9So=;
        b=n3UTIs7mynRKGzDODTp8B/n0UT9hAcMkGo6wqEADm4JAiqx9DOfaMtF575iPea+rO0
         +I+S93Jdw7u+VxiRzWGRYMdACaoE5kX6lJPEoVX32JYHc1Sc3K3JA+wTo/4kPuPwvROM
         hCy9U5hMuEu91ng2d8vn6i4Z230VnARu4MqSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eIAevkBeaME9YWTUo8UY0ZyBLFbUSSkkyRhcPQcy9So=;
        b=MLXDLTOb02agSECsq/gffC6otcRk6iGjslS5+wGay89wS1eGDYybBcS+Vwphl+aSf5
         JUeQSjudca38iHJRSD9hsHLnftim8eqicwQE2qw+PhdUfpwdKjtlZ2UiD9sCTrzmnbUO
         K3OulS9aUwa1i10BczbTyFxkZ+hBlQ1/A5Hs9OBo1CzzClmWyahexFoWGEajtwivfFNn
         OZbiUBU8ghNSt7cf689cQfyWUTd1g/jC0aE4yogf8xpVi3Krr4fZNKGalHa3juh78yMq
         HvhxQxs82MgYBgjIL/2Zt/p9e0bPFunhqJAYhzYAq626vFM4nHq+/CdOggsjpyhqwgtQ
         B3sg==
X-Gm-Message-State: AOAM531ukPqaHZG0FDY6B/QTyrTVnU4nhA80i1yZXsu4dnELD3xHjW4E
	Bbv/TJUKCYDBLlgJL8rkRcAdxQ==
X-Google-Smtp-Source: ABdhPJwp5UkwyAfrDAMSmZPKmdv5E7KkH/X6aBFhZG6pvM9S40xTMTqgAHiSZkFdw4+UrgEFQyGEDQ==
X-Received: by 2002:a63:d951:: with SMTP id e17mr4856083pgj.318.1594761881770;
        Tue, 14 Jul 2020 14:24:41 -0700 (PDT)
Date: Tue, 14 Jul 2020 14:24:39 -0700
From: Kees Cook <keescook@chromium.org>
To: "Christopher M. Riedl" <cmr@informatik.wtf>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2 5/5] powerpc: Add LKDTM test to hijack a patch mapping
Message-ID: <202007141406.43B82CCFD@keescook>
References: <20200709040316.12789-1-cmr@informatik.wtf>
 <20200709040316.12789-6-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709040316.12789-6-cmr@informatik.wtf>

On Wed, Jul 08, 2020 at 11:03:16PM -0500, Christopher M. Riedl wrote:
> When live patching with STRICT_KERNEL_RWX, the CPU doing the patching
> must use a temporary mapping which allows for writing to kernel text.
> During the entire window of time when this temporary mapping is in use,
> another CPU could write to the same mapping and maliciously alter kernel
> text. Implement a LKDTM test to attempt to exploit such a openings when
> a CPU is patching under STRICT_KERNEL_RWX. The test is only implemented
> on powerpc for now.
> 
> The LKDTM "hijack" test works as follows:
> 
> 	1. A CPU executes an infinite loop to patch an instruction.
> 	   This is the "patching" CPU.
> 	2. Another CPU attempts to write to the address of the temporary
> 	   mapping used by the "patching" CPU. This other CPU is the
> 	   "hijacker" CPU. The hijack either fails with a segfault or
> 	   succeeds, in which case some kernel text is now overwritten.
> 
> How to run the test:
> 
> 	mount -t debugfs none /sys/kernel/debug
> 	(echo HIJACK_PATCH > /sys/kernel/debug/provoke-crash/DIRECT)
> 
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
> ---
>  drivers/misc/lkdtm/core.c  |  1 +
>  drivers/misc/lkdtm/lkdtm.h |  1 +
>  drivers/misc/lkdtm/perms.c | 99 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 101 insertions(+)
> 
> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index a5e344df9166..482e72f6a1e1 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -145,6 +145,7 @@ static const struct crashtype crashtypes[] = {
>  	CRASHTYPE(WRITE_RO),
>  	CRASHTYPE(WRITE_RO_AFTER_INIT),
>  	CRASHTYPE(WRITE_KERN),
> +	CRASHTYPE(HIJACK_PATCH),
>  	CRASHTYPE(REFCOUNT_INC_OVERFLOW),
>  	CRASHTYPE(REFCOUNT_ADD_OVERFLOW),
>  	CRASHTYPE(REFCOUNT_INC_NOT_ZERO_OVERFLOW),
> diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
> index 601a2156a0d4..bfcf3542370d 100644
> --- a/drivers/misc/lkdtm/lkdtm.h
> +++ b/drivers/misc/lkdtm/lkdtm.h
> @@ -62,6 +62,7 @@ void lkdtm_EXEC_USERSPACE(void);
>  void lkdtm_EXEC_NULL(void);
>  void lkdtm_ACCESS_USERSPACE(void);
>  void lkdtm_ACCESS_NULL(void);
> +void lkdtm_HIJACK_PATCH(void);
>  
>  /* lkdtm_refcount.c */
>  void lkdtm_REFCOUNT_INC_OVERFLOW(void);
> diff --git a/drivers/misc/lkdtm/perms.c b/drivers/misc/lkdtm/perms.c
> index 62f76d506f04..b7149daaeb6f 100644
> --- a/drivers/misc/lkdtm/perms.c
> +++ b/drivers/misc/lkdtm/perms.c
> @@ -9,6 +9,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/mman.h>
>  #include <linux/uaccess.h>
> +#include <linux/kthread.h>
>  #include <asm/cacheflush.h>
>  
>  /* Whether or not to fill the target memory area with do_nothing(). */
> @@ -213,6 +214,104 @@ void lkdtm_ACCESS_NULL(void)
>  	*ptr = tmp;
>  }
>  
> +#if defined(CONFIG_PPC) && defined(CONFIG_STRICT_KERNEL_RWX)
> +#include <include/asm/code-patching.h>
> +
> +static struct ppc_inst * const patch_site = (struct ppc_inst *)&do_nothing;

While this is probably fine, I'd prefer a new target instead of re-using
do_nothing.

> +
> +static int lkdtm_patching_cpu(void *data)
> +{
> +	int err = 0;
> +	struct ppc_inst insn = ppc_inst(0xdeadbeef);
> +
> +	pr_info("starting patching_cpu=%d\n", smp_processor_id());
> +	do {
> +		err = patch_instruction(patch_site, insn);
> +	} while (ppc_inst_equal(ppc_inst_read(READ_ONCE(patch_site)), insn) &&
> +			!err && !kthread_should_stop());
> +
> +	if (err)
> +		pr_warn("patch_instruction returned error: %d\n", err);
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	while (!kthread_should_stop()) {
> +		schedule();
> +		set_current_state(TASK_INTERRUPTIBLE);
> +	}
> +
> +	return err;
> +}
> +
> +void lkdtm_HIJACK_PATCH(void)
> +{
> +	struct task_struct *patching_kthrd;
> +	struct ppc_inst original_insn;
> +	int patching_cpu, hijacker_cpu, attempts;
> +	unsigned long addr;
> +	bool hijacked;
> +
> +	if (num_online_cpus() < 2) {
> +		pr_warn("need at least two cpus\n");
> +		return;
> +	}
> +
> +	original_insn = ppc_inst_read(READ_ONCE(patch_site));
> +
> +	hijacker_cpu = smp_processor_id();
> +	patching_cpu = cpumask_any_but(cpu_online_mask, hijacker_cpu);
> +
> +	patching_kthrd = kthread_create_on_node(&lkdtm_patching_cpu, NULL,
> +						cpu_to_node(patching_cpu),
> +						"lkdtm_patching_cpu");
> +	kthread_bind(patching_kthrd, patching_cpu);
> +	wake_up_process(patching_kthrd);
> +
> +	addr = offset_in_page(patch_site) | read_cpu_patching_addr(patching_cpu);
> +
> +	pr_info("starting hijacker_cpu=%d\n", hijacker_cpu);
> +	for (attempts = 0; attempts < 100000; ++attempts) {
> +		/* Use __put_user to catch faults without an Oops */
> +		hijacked = !__put_user(0xbad00bad, (unsigned int *)addr);
> +
> +		if (hijacked) {
> +			if (kthread_stop(patching_kthrd))
> +				goto out;
> +			break;
> +		}
> +	}
> +	pr_info("hijack attempts: %d\n", attempts);
> +
> +	if (hijacked) {
> +		if (*(unsigned int *)READ_ONCE(patch_site) == 0xbad00bad)
> +			pr_err("overwrote kernel text\n");
> +		/*
> +		 * There are window conditions where the hijacker cpu manages to
> +		 * write to the patch site but the site gets overwritten again by
> +		 * the patching cpu. We still consider that a "successful" hijack
> +		 * since the hijacker cpu did not fault on the write.
> +		 */
> +		pr_err("FAIL: wrote to another cpu's patching area\n");
> +	} else {
> +		kthread_stop(patching_kthrd);
> +	}
> +
> +out:
> +	/* Restore the original insn for any future lkdtm tests */
> +	patch_instruction(patch_site, original_insn);

Can this test be done for x86's instruction patching too?

> +}
> +
> +#else
> +
> +void lkdtm_HIJACK_PATCH(void)
> +{
> +	if (!IS_ENABLED(CONFIG_PPC))
> +		pr_err("XFAIL: this test is powerpc-only\n");
> +	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
> +		pr_err("XFAIL: this test requires CONFIG_STRICT_KERNEL_RWX\n");
> +}
> +
> +#endif /* CONFIG_PPC && CONFIG_STRICT_KERNEL_RWX */
> +
>  void __init lkdtm_perms_init(void)
>  {
>  	/* Make sure we can write to __ro_after_init values during __init */
> -- 
> 2.27.0

Otherwise, looks good!

-- 
Kees Cook
