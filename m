Return-Path: <SRS0=cSaE=CT=lists.openwall.com=kernel-hardening-return-19873-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F322C43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 23:33:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 870FA208CA
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 23:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="N8GTm1Db"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 870FA208CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19873-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30607 invoked by uid 550); 10 Sep 2020 23:33:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30585 invoked from network); 10 Sep 2020 23:33:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4RBaH+SNtQZyszf95yfys9ev5YuersLuBj4oZ/8U4uI=;
        b=N8GTm1Dbn84HIt88mWsX44tIFWprbrc8Nc57ldNK0e9KxJ6Y7OPleZjHiHVfU+EuVR
         Nt6fd0ykv8WwDqUq/5E01PmMJR61Td7yjaCcLKAw3GmXUrIYA18yNyiRiHhfJIls1wi1
         iTfm3bQHDHv6CpIyM6R2MGv8nAKpsNuDdrCNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4RBaH+SNtQZyszf95yfys9ev5YuersLuBj4oZ/8U4uI=;
        b=PFlMu8BELlCAmc60qdTbekBPuiEErJPsNwI8TFt+72c1APu0qjo/xMpp09ie7YTdzn
         P1QMVDrOjFjjof+qfY4yhqBmZV6k80g1ZOuqsPkmqlXuQiv5RvMXCM5AEpmZe4fbghhg
         N49JcGSLNrMq1LuiVL6TaVJQjtlDMJ4c1V0+j6MjCdZYvlQzZKGim/Kiexy0N/HgY4le
         7DMtFCUOW2C1BAHD1C5GcSXbjioFaN7t7Wg1XcoVWHslAKkTgDmj3znT6l3sH1WHmb+V
         nDlQUBCpQTx4APg50nkTIBs/pYIBL6nkWvG3p4JkfZxChru1nhbyjkVAC9q8vkUBOw+9
         g46w==
X-Gm-Message-State: AOAM533sFJNUEX16O6bjSR7QJxJrMYoEAtI4CceM6BHLR30nstihfzTE
	24McmMlcsVutIEzITVloxzgn8Q==
X-Google-Smtp-Source: ABdhPJyofycYEK5HfnkOAbIa42Gr5C/nTGkv9iw512ddPj4Vz91LXsCiAIST2k+Ma2HQuPcKS1NFXA==
X-Received: by 2002:a17:902:9891:b029:d1:9bd3:6772 with SMTP id s17-20020a1709029891b02900d19bd36772mr985688plp.28.1599780820075;
        Thu, 10 Sep 2020 16:33:40 -0700 (PDT)
Date: Thu, 10 Sep 2020 16:33:38 -0700
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: John Wood <john.wood@gmx.com>, Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] security/fbfam: Use the api to manage statistics
Message-ID: <202009101625.0E3B6242@keescook>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910202107.3799376-4-keescook@chromium.org>

On Thu, Sep 10, 2020 at 01:21:04PM -0700, Kees Cook wrote:
> From: John Wood <john.wood@gmx.com>
> 
> Use the previous defined api to manage statistics calling it accordingly
> when a task forks, calls execve or exits.
> 
> Signed-off-by: John Wood <john.wood@gmx.com>
> ---
>  fs/exec.c     | 2 ++
>  kernel/exit.c | 2 ++
>  kernel/fork.c | 4 ++++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index a91003e28eaa..b30118674d32 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -71,6 +71,7 @@
>  #include "internal.h"
>  
>  #include <trace/events/sched.h>
> +#include <fbfam/fbfam.h>
>  
>  static int bprm_creds_from_file(struct linux_binprm *bprm);
>  
> @@ -1940,6 +1941,7 @@ static int bprm_execve(struct linux_binprm *bprm,
>  	task_numa_free(current, false);
>  	if (displaced)
>  		put_files_struct(displaced);
> +	fbfam_execve();

As mentioned in the other emails, I think this could trivially be
converted into an LSM: all the hooks are available AFAICT. If you only
want to introspect execve _happening_, you can use bprm_creds_for_exec
which is called a few lines above. Otherwise, my prior suggestion ("the
exec has happened" hook via brpm_cred_committing, etc).

>  	return retval;
>  
>  out:
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 733e80f334e7..39a6139dcf31 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -67,6 +67,7 @@
>  #include <linux/uaccess.h>
>  #include <asm/unistd.h>
>  #include <asm/mmu_context.h>
> +#include <fbfam/fbfam.h>
>  
>  static void __unhash_process(struct task_struct *p, bool group_dead)
>  {
> @@ -852,6 +853,7 @@ void __noreturn do_exit(long code)
>  		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
>  	exit_rcu();
>  	exit_tasks_rcu_finish();
> +	fbfam_exit();
>  
>  	lockdep_free_task(tsk);
>  	do_task_dead();

The place for this would be put_task_struct, and the LSM hook is
task_free. :) (The only caveat with task_free hook is that it may be
called in non-process context due to being freed during RCU, etc. In
practice, this is unlikely to cause problems.)

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 49677d668de4..c933838450a8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -107,6 +107,8 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/task.h>
>  
> +#include <fbfam/fbfam.h>
> +
>  /*
>   * Minimum number of threads to boot the kernel
>   */
> @@ -941,6 +943,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>  #ifdef CONFIG_MEMCG
>  	tsk->active_memcg = NULL;
>  #endif
> +
> +	fbfam_fork(tsk);
>  	return tsk;

Since you don't need "orig", this is also trivially an LSM hook.
dup_task_struct() is called by copy_process(), which will also call the
task_alloc LSM hook later on.

>  
>  free_stack:
> -- 
> 2.25.1
> 

-- 
Kees Cook
