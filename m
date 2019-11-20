Return-Path: <SRS0=pWjV=ZM=lists.openwall.com=kernel-hardening-return-17407-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C050C432C3
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Nov 2019 09:58:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A5E1621D7A
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Nov 2019 09:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="jFjecU/K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5E1621D7A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17407-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25999 invoked by uid 550); 20 Nov 2019 09:58:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25979 invoked from network); 20 Nov 2019 09:58:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1574243891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=K6XtfsmuOWVyvNSkl/OwZZStrOVOUJCeIR1iP8qeEBg=;
	b=jFjecU/KcYAyQAmdJjS4m4iM2zQx67FlcwDS2d9V7uxQNfBxxTtg14h+CqHyk89+aAYhfR
	hm/eJUuwUhSLH8h61Q4XLBaac/6Ouo6kE48Li12NtkFOP54MAmYTifuDuQzghMyAjK2wtp
	ui+APoH39yhjpKgheiq03scykvJi9Yo=
Date: Wed, 20 Nov 2019 10:58:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tianlin Li <tli@digitalocean.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Greentime Hu <green.hu@gmail.com>,
	Vincent Chen <deanbo422@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Jessica Yu <jeyu@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [RFC PATCH] kernel/module: have the callers of set_memory_*()
 check the return value
Message-ID: <20191120095804.GB2634@zn.tnic>
References: <20191119155149.20396-1-tli@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191119155149.20396-1-tli@digitalocean.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 19, 2019 at 09:51:49AM -0600, Tianlin Li wrote:
> Right now several architectures allow their set_memory_*() family of 
> functions to fail, but callers may not be checking the return values. We 
> need to fix the callers and add the __must_check attribute.

Please formulate commit messages in passive tone. "we" is ambiguous.

From Documentation/process/submitting-patches.rst:

 "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour."

Also, you could add a high-level summary of the failure case from:

https://lore.kernel.org/netdev/20180628213459.28631-4-daniel@iogearbox.net/

as a more real-life, convincing justification for this.

> They also may not provide any level of atomicity, in the sense that
> the memory protections may be left incomplete on failure.
> This issue likely has a few 
> steps on effects architectures[1]:
> 1)Have all callers of set_memory_*() helpers check the return value.
> 2)Add __much_check to all set_memory_*() helpers so that new uses do not 

__must_check

> ignore the return value.
> 3)Add atomicity to the calls so that the memory protections aren't left in 
> a partial state.
> 
> Ideally, the failure of set_memory_*() should be passed up the call stack, 
> and callers should examine the failure and deal with it. But currently, 
> some callers just have void return type.
> 
> We need to fix the callers to handle the return all the way to the top of 
> stack, and it will require a large series of patches to finish all the three 
> steps mentioned above. I start with kernel/module, and will move onto other 
> subsystems. I am not entirely sure about the failure modes for each caller. 
> So I would like to get some comments before I move forward. This single 
> patch is just for fixing the return value of set_memory_*() function in 
> kernel/module, and also the related callers. Any feedback would be greatly 
> appreciated.
> 
> [1]:https://github.com/KSPP/linux/issues/7
> 
> Signed-off-by: Tianlin Li <tli@digitalocean.com>
> ---
>  arch/arm/kernel/ftrace.c   |   8 +-
>  arch/arm64/kernel/ftrace.c |   6 +-
>  arch/nds32/kernel/ftrace.c |   6 +-
>  arch/x86/kernel/ftrace.c   |  13 ++-
>  include/linux/module.h     |  16 ++--
>  kernel/livepatch/core.c    |  15 +++-
>  kernel/module.c            | 170 +++++++++++++++++++++++++++----------
>  kernel/trace/ftrace.c      |  15 +++-
>  8 files changed, 175 insertions(+), 74 deletions(-)

Yeah, general idea makes sense but you'd need to redo your patch ontop
of linux-next because there are some changes in flight in ftrace-land at
least and your patch won't apply anymore after next week, when the merge
window opens.

Also, you should use checkpatch before sending a patch as sometimes it makes
sense what it complains about:

WARNING: Missing a blank line after declarations
#79: FILE: arch/arm/kernel/ftrace.c:68:
+       int ret;
+       ret = set_all_modules_text_ro();

WARNING: Missing a blank line after declarations
#150: FILE: arch/x86/kernel/ftrace.c:61:
+       int ret;
+       ret = set_all_modules_text_ro();

WARNING: trailing semicolon indicates no statements, indent implies otherwise
#203: FILE: kernel/livepatch/core.c:731:
+               if (module_enable_ro(patch->mod, true));
+                       pr_err("module_enable_ro failed.\n");

ERROR: trailing statements should be on next line
#203: FILE: kernel/livepatch/core.c:731:
+               if (module_enable_ro(patch->mod, true));

WARNING: Missing a blank line after declarations
#451: FILE: kernel/module.c:2091:
+       int ret;
+       ret = frob_text(&mod->core_layout, set_memory_x);

WARNING: Missing a blank line after declarations
#511: FILE: kernel/trace/ftrace.c:5819:
+               int ret = ftrace_arch_code_modify_prepare();
+               if (ret) {

WARNING: Missing a blank line after declarations
#527: FILE: kernel/trace/ftrace.c:5864:
+               int ret = ftrace_arch_code_modify_post_process();
+               FTRACE_WARN_ON(ret);

> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index c4ce08f43bd6..39bfc0685854 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -721,16 +721,25 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>  
>  	mutex_lock(&text_mutex);
>  
> -	module_disable_ro(patch->mod);
> +	ret = module_disable_ro(patch->mod);
> +	if (ret) {
> +		mutex_unlock(&text_mutex);
> +		return ret;
> +	}
>  	ret = klp_write_object_relocations(patch->mod, obj);
>  	if (ret) {
> -		module_enable_ro(patch->mod, true);
> +		if (module_enable_ro(patch->mod, true));
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

and if you look at its output above closely, it might even help you
catch the bug you've added.

 [ Don't worry, happens to the best of us. :-) ]

Also, what would help review is if you split your patch:

patch 1: Change functions to return a retval
patch 2-n: Change call sites to handle retval properly

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
