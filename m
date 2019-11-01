Return-Path: <SRS0=tP5X=YZ=lists.openwall.com=kernel-hardening-return-17214-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7898CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:53:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADBD32083E
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:53:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gWLZxKI+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADBD32083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17214-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24320 invoked by uid 550); 1 Nov 2019 03:52:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24298 invoked from network); 1 Nov 2019 03:52:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gpLAkkycQDbDSOC/PvJc50WAQNQl23mAQ5YOyKoCOKQ=;
        b=gWLZxKI+6uMuqF40oThzg5PiQfqKMClcPLLmmIBAaR/wDZwWjVijkJEPF2sNBmIV9i
         nbhYZRcBYedLAs1ObXvZI/Okuk9JFPb0HVSronSamG3Tn5t+wO/JGam+3rhKDB6IcVCm
         h3TDS+boW/VYKcZb32f4zY+kqosE4Bztz0cUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gpLAkkycQDbDSOC/PvJc50WAQNQl23mAQ5YOyKoCOKQ=;
        b=ui+PRwAsyfpfn8o7Ln/W7UvCaVg/t0acm/HO7fv9v8ynElcG1fFNZzAJMdc1xZpoJl
         ozjkLFEJhYXld1l82yXn583en14SU2GAHMH+b4u5Z4y4b+j9aOj38J9rx0xmn3X5eYHU
         qQZm4BMy+vP6Izxw5p5cAb6GCykR8+NpVW4xaQU0AqIO1HTDBJm1qTiLtiFPAWuMoYKQ
         JiiCWws0iZlxb8nrLwRAQUAmo8tiWHfeb6y/kERkJlQI0u1OKXh7CsZIAbJb8t4iANNd
         kOaZeHTeDXHU7OWSbZQv1Fz7TKof5DzlGTwxz1FqGjdxhhj/am6XuqQHakRJTzykuT+0
         q+VA==
X-Gm-Message-State: APjAAAWloK6w4GAwVJdwYqREi5iiPocCAfV60uouV+0GSTBeQcOXlqMi
	R2hRwBTCDCMbY3SEEGwIbHrkuA==
X-Google-Smtp-Source: APXvYqw6XqTv8yGHR0KsVVwCNMe9mcWfZe/TNMu5crisql/X0YT5TGuvZ2U2c5cD7WTUXY1GQs1CEA==
X-Received: by 2002:a17:902:b604:: with SMTP id b4mr10080726pls.219.1572580366145;
        Thu, 31 Oct 2019 20:52:46 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:52:44 -0700
From: Kees Cook <keescook@chromium.org>
To: samitolvanen@google.com
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/17] scs: add accounting
Message-ID: <201910312052.0ADF21F@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-7-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-7-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:26AM -0700, samitolvanen@google.com wrote:
> This change adds accounting for the memory allocated for shadow stacks.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

A nice bit of stats to have.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/base/node.c    |  6 ++++++
>  fs/proc/meminfo.c      |  4 ++++
>  include/linux/mmzone.h |  3 +++
>  kernel/scs.c           | 19 +++++++++++++++++++
>  mm/page_alloc.c        |  6 ++++++
>  mm/vmstat.c            |  3 +++
>  6 files changed, 41 insertions(+)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 296546ffed6c..111e58ec231e 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -415,6 +415,9 @@ static ssize_t node_read_meminfo(struct device *dev,
>  		       "Node %d AnonPages:      %8lu kB\n"
>  		       "Node %d Shmem:          %8lu kB\n"
>  		       "Node %d KernelStack:    %8lu kB\n"
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +		       "Node %d ShadowCallStack:%8lu kB\n"
> +#endif
>  		       "Node %d PageTables:     %8lu kB\n"
>  		       "Node %d NFS_Unstable:   %8lu kB\n"
>  		       "Node %d Bounce:         %8lu kB\n"
> @@ -438,6 +441,9 @@ static ssize_t node_read_meminfo(struct device *dev,
>  		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
>  		       nid, K(i.sharedram),
>  		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK_KB),
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +		       nid, sum_zone_node_page_state(nid, NR_KERNEL_SCS_BYTES) / 1024,
> +#endif
>  		       nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
>  		       nid, K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
>  		       nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 8c1f1bb1a5ce..49768005a79e 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -103,6 +103,10 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  	show_val_kb(m, "SUnreclaim:     ", sunreclaim);
>  	seq_printf(m, "KernelStack:    %8lu kB\n",
>  		   global_zone_page_state(NR_KERNEL_STACK_KB));
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	seq_printf(m, "ShadowCallStack:%8lu kB\n",
> +		   global_zone_page_state(NR_KERNEL_SCS_BYTES) / 1024);
> +#endif
>  	show_val_kb(m, "PageTables:     ",
>  		    global_zone_page_state(NR_PAGETABLE));
>  
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index bda20282746b..fcb8c1708f9e 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -200,6 +200,9 @@ enum zone_stat_item {
>  	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
>  	NR_PAGETABLE,		/* used for pagetables */
>  	NR_KERNEL_STACK_KB,	/* measured in KiB */
> +#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
> +	NR_KERNEL_SCS_BYTES,	/* measured in bytes */
> +#endif
>  	/* Second 128 byte cacheline */
>  	NR_BOUNCE,
>  #if IS_ENABLED(CONFIG_ZSMALLOC)
> diff --git a/kernel/scs.c b/kernel/scs.c
> index 7c1a40020754..7780fc4e29ac 100644
> --- a/kernel/scs.c
> +++ b/kernel/scs.c
> @@ -11,6 +11,7 @@
>  #include <linux/scs.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <linux/vmstat.h>
>  #include <asm/scs.h>
>  
>  static inline void *__scs_base(struct task_struct *tsk)
> @@ -74,6 +75,11 @@ static void scs_free(void *s)
>  	vfree_atomic(s);
>  }
>  
> +static struct page *__scs_page(struct task_struct *tsk)
> +{
> +	return vmalloc_to_page(__scs_base(tsk));
> +}
> +
>  static int scs_cleanup(unsigned int cpu)
>  {
>  	int i;
> @@ -107,6 +113,11 @@ static inline void scs_free(void *s)
>  	kmem_cache_free(scs_cache, s);
>  }
>  
> +static struct page *__scs_page(struct task_struct *tsk)
> +{
> +	return virt_to_page(__scs_base(tsk));
> +}
> +
>  void __init scs_init(void)
>  {
>  	scs_cache = kmem_cache_create("scs_cache", SCS_SIZE, SCS_SIZE,
> @@ -135,6 +146,12 @@ void scs_task_reset(struct task_struct *tsk)
>  	task_set_scs(tsk, __scs_base(tsk));
>  }
>  
> +static void scs_account(struct task_struct *tsk, int account)
> +{
> +	mod_zone_page_state(page_zone(__scs_page(tsk)), NR_KERNEL_SCS_BYTES,
> +		account * SCS_SIZE);
> +}
> +
>  int scs_prepare(struct task_struct *tsk, int node)
>  {
>  	void *s;
> @@ -145,6 +162,7 @@ int scs_prepare(struct task_struct *tsk, int node)
>  
>  	task_set_scs(tsk, s);
>  	scs_set_magic(tsk);
> +	scs_account(tsk, 1);
>  
>  	return 0;
>  }
> @@ -164,6 +182,7 @@ void scs_release(struct task_struct *tsk)
>  
>  	WARN_ON(scs_corrupted(tsk));
>  
> +	scs_account(tsk, -1);
>  	task_set_scs(tsk, NULL);
>  	scs_free(s);
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ecc3dbad606b..fe17d69d98a7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5361,6 +5361,9 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>  			" managed:%lukB"
>  			" mlocked:%lukB"
>  			" kernel_stack:%lukB"
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +			" shadow_call_stack:%lukB"
> +#endif
>  			" pagetables:%lukB"
>  			" bounce:%lukB"
>  			" free_pcp:%lukB"
> @@ -5382,6 +5385,9 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>  			K(zone_managed_pages(zone)),
>  			K(zone_page_state(zone, NR_MLOCK)),
>  			zone_page_state(zone, NR_KERNEL_STACK_KB),
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +			zone_page_state(zone, NR_KERNEL_SCS_BYTES) / 1024,
> +#endif
>  			K(zone_page_state(zone, NR_PAGETABLE)),
>  			K(zone_page_state(zone, NR_BOUNCE)),
>  			K(free_pcp),
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 6afc892a148a..9fe4afe670fe 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1118,6 +1118,9 @@ const char * const vmstat_text[] = {
>  	"nr_mlock",
>  	"nr_page_table_pages",
>  	"nr_kernel_stack",
> +#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
> +	"nr_shadow_call_stack_bytes",
> +#endif
>  	"nr_bounce",
>  #if IS_ENABLED(CONFIG_ZSMALLOC)
>  	"nr_zspages",
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
