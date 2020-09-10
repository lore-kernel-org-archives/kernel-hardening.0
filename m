Return-Path: <SRS0=IHKI=CT=lists.openwall.com=kernel-hardening-return-19875-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD4DC43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 23:56:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9A3DC2065E
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 23:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZPH3m7HJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A3DC2065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19875-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10124 invoked by uid 550); 10 Sep 2020 23:56:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10095 invoked from network); 10 Sep 2020 23:56:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I+xVQ3jHlp2rB+8n2ea04vDE9/LZRk0HxGzt/QYk9uU=;
        b=ZPH3m7HJsHeP9aU6HPw0XBsvag8QOGw3a++omnj1GHb5mw8RF3UArs5bksb1naGOM1
         iTLGvw15UnS0AI8sN/Z5uy4PDmcPPZTw7YsLZZOENbC2gBGVjutxrDp2cBTTds4aWv6J
         Q/8Nm0Z/z616BSl13nAH9feXaUUfXqN1SaYfc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I+xVQ3jHlp2rB+8n2ea04vDE9/LZRk0HxGzt/QYk9uU=;
        b=fOseMOERmCsAZmwUyWkL1foJc9IuVOG0pq36YYd+p2J+AHTewLEhgLE/rI7Un9jyAR
         +alyPIqzQ/iSECDAWHpaeEmGKrDWADscMTet367c8NEwAGMpL6d42hoG+LXg9QJYq45k
         amWG9QCEugTDSBNCMbxpmTfDdannCwqKn9OUfOS1RjD55QU7WPHBDaMXxWYFThx12PFN
         zX+ObpipAhfHHYzSBYjX/QAbSVhmf8mybjPHdzxSAY141CwmDTqtjApdeThtz1VEcd0P
         ewi8CQ0rYDSwssQpgPpyuFzkoq35SR3jWTtPlmmDNj+CNngrNRajUEYXiIfoY1WWuPna
         Mc/A==
X-Gm-Message-State: AOAM533MBrlbbaT+wG8yucIZN7Q5v93TXGEOgRyexfR/pBTEZB+XuiVu
	65osr4FTRDCnA9Cf0+Og0iFafg==
X-Google-Smtp-Source: ABdhPJydbWiGrCKpTlKoflsP+LgdYjnoj/G6rzHkf1qn2cy7PUFDyFNpEmlGpKhYEK5PsVYx0dHNOA==
X-Received: by 2002:a05:6a00:788:: with SMTP id g8mr7349243pfu.89.1599782181559;
        Thu, 10 Sep 2020 16:56:21 -0700 (PDT)
Date: Thu, 10 Sep 2020 16:56:19 -0700
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
Subject: Re: [RFC PATCH 6/6] security/fbfam: Mitigate a fork brute force
 attack
Message-ID: <202009101649.2A0BF95@keescook>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-7-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910202107.3799376-7-keescook@chromium.org>

On Thu, Sep 10, 2020 at 01:21:07PM -0700, Kees Cook wrote:
> From: John Wood <john.wood@gmx.com>
> 
> In order to mitigate a fork brute force attack it is necessary to kill
> all the offending tasks. This tasks are all the ones that share the
> statistical data with the current task (the task that has crashed).
> 
> Since the attack detection is done in the function fbfam_handle_attack()
> that is called every time a core dump is triggered, only is needed to
> kill the others tasks that share the same statistical data, not the
> current one as this is in the path to be killed.
> 
> When the SIGKILL signal is sent to the offending tasks from the function
> fbfam_kill_tasks(), this one will be called again during the core dump
> due to the shared statistical data shows a quickly crashing rate. So, to
> avoid kill again the same tasks due to a recursive call of this
> function, it is necessary to disable the attack detection.
> 
> To disable this attack detection, add a condition in the function
> fbfam_handle_attack() to not compute the crashing rate when the jiffies
> stored in the statistical data are set to zero.
> 
> Signed-off-by: John Wood <john.wood@gmx.com>
> ---
>  security/fbfam/fbfam.c | 76 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 71 insertions(+), 5 deletions(-)
> 
> diff --git a/security/fbfam/fbfam.c b/security/fbfam/fbfam.c
> index 3aa669e4ea51..173a6122390f 100644
> --- a/security/fbfam/fbfam.c
> +++ b/security/fbfam/fbfam.c
> @@ -4,8 +4,11 @@
>  #include <linux/errno.h>
>  #include <linux/gfp.h>
>  #include <linux/jiffies.h>
> +#include <linux/pid.h>
>  #include <linux/printk.h>
> +#include <linux/rcupdate.h>
>  #include <linux/refcount.h>
> +#include <linux/sched/signal.h>
>  #include <linux/signal.h>
>  #include <linux/slab.h>
>  
> @@ -24,7 +27,8 @@ unsigned long sysctl_crashing_rate_threshold = 30000;
>   * struct fbfam_stats - Fork brute force attack mitigation statistics.
>   * @refc: Reference counter.
>   * @faults: Number of crashes since jiffies.
> - * @jiffies: First fork or execve timestamp.
> + * @jiffies: First fork or execve timestamp. If zero, the attack detection is
> + *           disabled.
>   *
>   * The purpose of this structure is to manage all the necessary information to
>   * compute the crashing rate of an application. So, it holds a first fork or
> @@ -175,13 +179,69 @@ int fbfam_exit(void)
>  }
>  
>  /**
> - * fbfam_handle_attack() - Fork brute force attack detection.
> + * fbfam_kill_tasks() - Kill the offending tasks
> + *
> + * When a fork brute force attack is detected it is necessary to kill all the
> + * offending tasks. Since this function is called from fbfam_handle_attack(),
> + * and so, every time a core dump is triggered, only is needed to kill the
> + * others tasks that share the same statistical data, not the current one as
> + * this is in the path to be killed.
> + *
> + * When the SIGKILL signal is sent to the offending tasks, this function will be
> + * called again during the core dump due to the shared statistical data shows a
> + * quickly crashing rate. So, to avoid kill again the same tasks due to a
> + * recursive call of this function, it is necessary to disable the attack
> + * detection setting the jiffies to zero.
> + *
> + * To improve the for_each_process loop it is possible to end it when all the
> + * tasks that shared the same statistics are found.
> + *
> + * Return: -EFAULT if the current task doesn't have statistical data. Zero
> + *         otherwise.
> + */
> +static int fbfam_kill_tasks(void)
> +{
> +	struct fbfam_stats *stats = current->fbfam_stats;
> +	struct task_struct *p;
> +	unsigned int to_kill, killed = 0;
> +
> +	if (!stats)
> +		return -EFAULT;
> +
> +	to_kill = refcount_read(&stats->refc) - 1;
> +	if (!to_kill)
> +		return 0;
> +
> +	/* Disable the attack detection */
> +	stats->jiffies = 0;
> +	rcu_read_lock();
> +
> +	for_each_process(p) {
> +		if (p == current || p->fbfam_stats != stats)
> +			continue;
> +
> +		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_PID);
> +		pr_warn("fbfam: Offending process with PID %d killed\n",
> +			p->pid);

I'd make this ratelimited (along with Jann's suggestions). Also, instead
of the explicit "fbfam:" prefix, use the regular prefixing method:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt


> +
> +		killed += 1;
> +		if (killed >= to_kill)
> +			break;
> +	}
> +
> +	rcu_read_unlock();

Can't newly created processes escape this RCU read lock? I think this
need alternate locking, or something in the task_alloc hook that will
block any new process from being created within the stats group.

> +	return 0;
> +}
> +
> +/**
> + * fbfam_handle_attack() - Fork brute force attack detection and mitigation.
>   * @signal: Signal number that causes the core dump.
>   *
>   * The crashing rate of an application is computed in milliseconds per fault in
>   * each crash. So, if this rate goes under a certain threshold there is a clear
>   * signal that the application is crashing quickly. At this moment, a fork brute
> - * force attack is happening.
> + * force attack is happening. Under this scenario it is necessary to kill all
> + * the offending tasks in order to mitigate the attack.
>   *
>   * Return: -EFAULT if the current task doesn't have statistical data. Zero
>   *         otherwise.
> @@ -195,6 +255,10 @@ int fbfam_handle_attack(int signal)
>  	if (!stats)
>  		return -EFAULT;
>  
> +	/* The attack detection is disabled */
> +	if (!stats->jiffies)
> +		return 0;
> +
>  	if (!(signal == SIGILL || signal == SIGBUS || signal == SIGKILL ||
>  	      signal == SIGSEGV || signal == SIGSYS))
>  		return 0;
> @@ -205,9 +269,11 @@ int fbfam_handle_attack(int signal)
>  	delta_time = jiffies64_to_msecs(delta_jiffies);
>  	crashing_rate = delta_time / (u64)stats->faults;
>  
> -	if (crashing_rate < (u64)sysctl_crashing_rate_threshold)
> -		pr_warn("fbfam: Fork brute force attack detected\n");
> +	if (crashing_rate >= (u64)sysctl_crashing_rate_threshold)
> +		return 0;
>  
> +	pr_warn("fbfam: Fork brute force attack detected\n");
> +	fbfam_kill_tasks();
>  	return 0;
>  }
>  
> -- 
> 2.25.1
> 

-- 
Kees Cook
