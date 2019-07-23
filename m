Return-Path: <SRS0=7VZ7=VU=lists.openwall.com=kernel-hardening-return-16563-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E272C76186
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 21:29:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4E263218D4
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 21:29:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Qg5NJFPj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E263218D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16563-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23593 invoked by uid 550); 23 Jul 2019 21:29:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23559 invoked from network); 23 Jul 2019 21:29:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OWdCNqJGYsKwQKw/7IBES5RNvU+nb+rFc9xiJalsj58=;
        b=Qg5NJFPjWQQQ2q5x01/eq25u5SEH83Pxvo14WqJDSZd3cGt5CAEPj53pgdBFERmjbd
         QviotmsjvSxjsQozER/H3dov5IvBAENwvmcGPXW0Oc+HScbpnSPoNKgqTWTHexIhsgaR
         opcvX8pwKVc0cLLKWN3/SxUdoyk80n7xEAb4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OWdCNqJGYsKwQKw/7IBES5RNvU+nb+rFc9xiJalsj58=;
        b=HhcBil7SrmobK2BUUCIY0/HieS/LjZGAiEP89rCxO2bPuvEK6VJSoNUOcUURoQf5xD
         z5Dwu/Y0JycPrUIIINkRA9+R/rydolxrlzha3mBenI+bGQVbsRUg++hpegM7usjdOPCJ
         sigG57qjIq2SHDH7O06Jy4fcYHE3XR5SyQG70qJT5TUoxb9CNJYC+t0CR3OfUoHZC8rs
         E6c4dH6d0w+F1qJtwWYBEB/CcC5W3HNJX7FnvpPCnyInNAGhlOH0SIP//VpsIjl+lFVn
         T+K48V5QOR0XjpF+Zd3o7lffRt3FxgB8/MFLZl9y58eJzWzZYPPuO0CH4tDjHm09dUju
         AT8Q==
X-Gm-Message-State: APjAAAV6j57XaQpEHCiYYWNGHRIqk3wUnP6vSKa4pVlFdS9yFZb1+DHY
	PaV9amXMvuHCMrl5DILpy70C0g==
X-Google-Smtp-Source: APXvYqwf4iVZp03BX78Fy5ezKUKc0oj+TStEy17ep291SxD/1qwlFzQBSjPCZnLJ97UypCJiwTSxBQ==
X-Received: by 2002:aa7:956d:: with SMTP id x13mr7863044pfq.132.1563917352419;
        Tue, 23 Jul 2019 14:29:12 -0700 (PDT)
Date: Tue, 23 Jul 2019 14:29:10 -0700
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Stephen Kitt <steve@sk2.org>, Nitin Gote <nitin.r.gote@intel.com>,
	jannh@google.com, kernel-hardening@lists.openwall.com,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
Message-ID: <201907231428.51E52AD6A@keescook>
References: <cover.1563841972.git.joe@perches.com>
 <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
 <20190722213527.18deeaf07ae036cce57035ea@linux-foundation.org>
 <24bcbaee40a4174cb5d9fa876f88b2a1869a4870.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24bcbaee40a4174cb5d9fa876f88b2a1869a4870.camel@perches.com>

On Mon, Jul 22, 2019 at 09:42:51PM -0700, Joe Perches wrote:
> On Mon, 2019-07-22 at 21:35 -0700, Andrew Morton wrote:
> > On Mon, 22 Jul 2019 17:38:15 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > Several uses of strlcpy and strscpy have had defects because the
> > > last argument of each function is misused or typoed.
> > > 
> > > Add macro mechanisms to avoid this defect.
> > > 
> > > stracpy (copy a string to a string array) must have a string
> > > array as the first argument (to) and uses sizeof(to) as the
> > > size.
> > > 
> > > These mechanisms verify that the to argument is an array of
> > > char or other compatible types like u8 or unsigned char.
> > > 
> > > A BUILD_BUG is emitted when the type of to is not compatible.
> > > 
> > 
> > It would be nice to include some conversions.  To demonstrate the need,
> > to test the code, etc.
> 
> How about all the kernel/ ?
> ---
>  kernel/acct.c                  | 2 +-
>  kernel/cgroup/cgroup-v1.c      | 3 +--
>  kernel/debug/gdbstub.c         | 4 ++--
>  kernel/debug/kdb/kdb_support.c | 2 +-
>  kernel/events/core.c           | 4 ++--
>  kernel/module.c                | 2 +-
>  kernel/printk/printk.c         | 2 +-
>  kernel/time/clocksource.c      | 2 +-
>  8 files changed, 10 insertions(+), 11 deletions(-)

I think that's a good start. I still think we could just give Linus a
Coccinelle script too, for the next merge window...

-Kees

> 
> diff --git a/kernel/acct.c b/kernel/acct.c
> index 81f9831a7859..5ad29248b654 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -425,7 +425,7 @@ static void fill_ac(acct_t *ac)
>  	memset(ac, 0, sizeof(acct_t));
>  
>  	ac->ac_version = ACCT_VERSION | ACCT_BYTEORDER;
> -	strlcpy(ac->ac_comm, current->comm, sizeof(ac->ac_comm));
> +	stracpy(ac->ac_comm, current->comm);
>  
>  	/* calculate run_time in nsec*/
>  	run_time = ktime_get_ns();
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index 88006be40ea3..dd4f041e4179 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -571,8 +571,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
>  	if (!cgrp)
>  		return -ENODEV;
>  	spin_lock(&release_agent_path_lock);
> -	strlcpy(cgrp->root->release_agent_path, strstrip(buf),
> -		sizeof(cgrp->root->release_agent_path));
> +	stracpy(cgrp->root->release_agent_path, strstrip(buf));
>  	spin_unlock(&release_agent_path_lock);
>  	cgroup_kn_unlock(of->kn);
>  	return nbytes;
> diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
> index 4b280fc7dd67..a263f27f51ad 100644
> --- a/kernel/debug/gdbstub.c
> +++ b/kernel/debug/gdbstub.c
> @@ -1095,10 +1095,10 @@ int gdbstub_state(struct kgdb_state *ks, char *cmd)
>  		return error;
>  	case 's':
>  	case 'c':
> -		strscpy(remcom_in_buffer, cmd, sizeof(remcom_in_buffer));
> +		stracpy(remcom_in_buffer, cmd);
>  		return 0;
>  	case '$':
> -		strscpy(remcom_in_buffer, cmd, sizeof(remcom_in_buffer));
> +		stracpy(remcom_in_buffer, cmd);
>  		gdbstub_use_prev_in_buf = strlen(remcom_in_buffer);
>  		gdbstub_prev_in_buf_pos = 0;
>  		return 0;
> diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
> index b8e6306e7e13..b49b6c3976c7 100644
> --- a/kernel/debug/kdb/kdb_support.c
> +++ b/kernel/debug/kdb/kdb_support.c
> @@ -192,7 +192,7 @@ int kallsyms_symbol_complete(char *prefix_name, int max_len)
>  
>  	while ((name = kdb_walk_kallsyms(&pos))) {
>  		if (strncmp(name, prefix_name, prefix_len) == 0) {
> -			strscpy(ks_namebuf, name, sizeof(ks_namebuf));
> +			stracpy(ks_namebuf, name);
>  			/* Work out the longest name that matches the prefix */
>  			if (++number == 1) {
>  				prev_len = min_t(int, max_len-1,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 026a14541a38..25bd8c777270 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7049,7 +7049,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
>  	unsigned int size;
>  
>  	memset(comm, 0, sizeof(comm));
> -	strlcpy(comm, comm_event->task->comm, sizeof(comm));
> +	stracpy(comm, comm_event->task->comm);
>  	size = ALIGN(strlen(comm)+1, sizeof(u64));
>  
>  	comm_event->comm = comm;
> @@ -7394,7 +7394,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>  	}
>  
>  cpy_name:
> -	strlcpy(tmp, name, sizeof(tmp));
> +	stracpy(tmp, name);
>  	name = tmp;
>  got_name:
>  	/*
> diff --git a/kernel/module.c b/kernel/module.c
> index 5933395af9a0..39384b0c90b8 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1021,7 +1021,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  	async_synchronize_full();
>  
>  	/* Store the name of the last unloaded module for diagnostic purposes */
> -	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
> +	stracpy(last_unloaded_module, mod->name);
>  
>  	free_module(mod);
>  	return 0;
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 424abf802f02..029633052be4 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2127,7 +2127,7 @@ static int __add_preferred_console(char *name, int idx, char *options,
>  		return -E2BIG;
>  	if (!brl_options)
>  		preferred_console = i;
> -	strlcpy(c->name, name, sizeof(c->name));
> +	stracpy(c->name, name);
>  	c->options = options;
>  	braille_set_options(c, brl_options);
>  
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index fff5f64981c6..f0c833d89ace 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -1203,7 +1203,7 @@ static int __init boot_override_clocksource(char* str)
>  {
>  	mutex_lock(&clocksource_mutex);
>  	if (str)
> -		strlcpy(override_name, str, sizeof(override_name));
> +		stracpy(override_name, str);
>  	mutex_unlock(&clocksource_mutex);
>  	return 1;
>  }
> 
> 

-- 
Kees Cook
