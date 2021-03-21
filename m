Return-Path: <SRS0=OZRb=IT=lists.openwall.com=kernel-hardening-return-21027-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2304DC433DB
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 18:07:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 357FE61937
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 18:07:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 357FE61937
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21027-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3588 invoked by uid 550); 21 Mar 2021 18:07:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3553 invoked from network); 21 Mar 2021 18:07:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GQKgsW9PSdNVPIehSolNc4zFTAKkCmZGwQWUb20126U=;
        b=I0PKXyTMkIEt+LniN9TDiR4PCxmqN6nDda6NF8aRRqORq412FXzDgofgs7FTdzKEph
         vtaZ9FoaIP3Bo4WolyFquZvViXjHm4OBIhWkdNdl9gsNA4/raot78SoLh3nBZ2vRd+Cu
         i8rt+lblIxqxP3fW9eBvzDKw6lp2xA6hNKM3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQKgsW9PSdNVPIehSolNc4zFTAKkCmZGwQWUb20126U=;
        b=ZRth7BNdQTkJjZIx1DWzaToQMMZXK4wf3DWD8TeDeRLZxJU/NhrrjXCIg60ZJsCzlW
         5fM/mxa4bHiZ/6UMrK84tyUk6DNgsvVBnXz86wpJSF4dtmZh9KKYjEJs88dztzgXYqrG
         ucItDVsvGuN4w2dqgMG52E4FtKkR2LgSR55YueLy0+68sGPNSLprLoD5sbI0WFQhN0vg
         RP643T317F8hQqErTqrRLkB9c3urP5U9w87U5KO7aDIW1z2C3ctcbAazZPoKngNe+aku
         GYq6RemqK6ncnw85pGCfXl+cYjUPPpBtZpcbFQ5UBU5JsJ/YNr/igVkMQkY3QeC8TZdz
         D1Rw==
X-Gm-Message-State: AOAM533sShl9VUvNn+VmvGB2akK99HOq0rAFRygV1YdR6ocZ3Y50gJFT
	B3vtllgfyUV6JdmCtHuPyCn9ZQ==
X-Google-Smtp-Source: ABdhPJwaCJxQVGsaQYkSzRn4/xLdt/W/sHHH5c87r+rTURI2OY10XACg+Pnz+H2j9RROjlYdd/UVjA==
X-Received: by 2002:a63:4753:: with SMTP id w19mr19247458pgk.394.1616350018234;
        Sun, 21 Mar 2021 11:06:58 -0700 (PDT)
Date: Sun, 21 Mar 2021 11:06:56 -0700
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: Jann Horn <jannh@google.com>, Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	kernel test robot <oliver.sang@intel.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 5/8] security/brute: Mitigate a brute force attack
Message-ID: <202103211101.F3CD3A84@keescook>
References: <20210307113031.11671-1-john.wood@gmx.com>
 <20210307113031.11671-6-john.wood@gmx.com>
 <202103172102.03F172613@keescook>
 <20210320154847.GD3023@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320154847.GD3023@ubuntu>

On Sat, Mar 20, 2021 at 04:48:47PM +0100, John Wood wrote:
> On Wed, Mar 17, 2021 at 09:04:15PM -0700, Kees Cook wrote:
> > On Sun, Mar 07, 2021 at 12:30:28PM +0100, John Wood wrote:
> > > +/**
> > > + * brute_kill_offending_tasks() - Kill the offending tasks.
> > > + * @attack_type: Brute force attack type.
> > > + * @stats: Statistical data shared by all the fork hierarchy processes.
> > > + *
> > > + * When a brute force attack is detected all the offending tasks involved in the
> > > + * attack must be killed. In other words, it is necessary to kill all the tasks
> > > + * that share the same statistical data. Moreover, if the attack happens through
> > > + * the fork system call, the processes that have the same group_leader that the
> > > + * current task must be avoided since they are in the path to be killed.
> > > + *
> > > + * When the SIGKILL signal is sent to the offending tasks, this function will be
> > > + * called again from the task_fatal_signal hook due to a small crash period. So,
> > > + * to avoid kill again the same tasks due to a recursive call of this function,
> > > + * it is necessary to disable the attack detection for this fork hierarchy.
> >
> > Hah. Interesting. I wonder if there is a better way to handle this. Hmm.
> 
> If your comment is related to disable the detection:
> 
> I think it's no problematic to disable the attack detection for this fork
> hierarchy since all theirs tasks will be removed. Also, I think that the disable
> mark can help in the path to use the wait*() functions to notify userspace that
> a task has been killed by the brute mitigation. Is a work in progress now.
> 
> If your comment is related to kill all the tasks:
> 
> In the previous version I have a useful discussion with Andi Kleen where a
> proposal to block the fork system call during a time was made. He explains me
> the cons of this method and proposes that if the mitigation works as now we can
> use the wait*() functions to notify userspace that the tasks has been killed
> by the brute mitigation. This way other problems related with the supervisors
> and respawned processes could be handled.
> 
> Anyway, new points of view are also welcome.

I was just amused by my realizing that the brute mitigation could
trigger itself. I was just glad you had a comment about the
situation -- I hadn't thought about that case yet. :)

> 
> > > + *
> > > + * The statistical data shared by all the fork hierarchy processes cannot be
> > > + * NULL.
> > > + *
> > > + * It's mandatory to disable interrupts before acquiring the brute_stats::lock
> > > + * since the task_free hook can be called from an IRQ context during the
> > > + * execution of the task_fatal_signal hook.
> > > + *
> > > + * Context: Must be called with interrupts disabled and tasklist_lock and
> > > + *          brute_stats_ptr_lock held.
> > > + */
> > > +static void brute_kill_offending_tasks(enum brute_attack_type attack_type,
> > > +				       struct brute_stats *stats)
> > > +{
> > > +	struct task_struct *p;
> > > +	struct brute_stats **p_stats;
> > > +
> > > +	spin_lock(&stats->lock);
> > > +
> > > +	if (attack_type == BRUTE_ATTACK_TYPE_FORK &&
> > > +	    refcount_read(&stats->refc) == 1) {
> > > +		spin_unlock(&stats->lock);
> > > +		return;
> > > +	}
> >
> > refcount_read() isn't a safe way to check that there is only 1
> > reference. What's this trying to do?
> 
> If a fork brute force attack has been detected is due to a new fatal crash.
> Under this scenario, if there is only one reference of these stats, it is
> not necessary to kill any other tasks since the stats are not shared with
> another process. Moreover, if this task has failed in a fatal way, is in
> the path to be killed. So, no action is required.
> 
> How can I make this check in a safe way?

I think you can just skip the optimization -- killing off threads isn't
going to be a fast path.

-Kees

> 
> > > +
> > > +	brute_disable(stats);
> > > +	spin_unlock(&stats->lock);
> > > +
> > > +	for_each_process(p) {
> > > +		if (attack_type == BRUTE_ATTACK_TYPE_FORK &&
> > > +		    p->group_leader == current->group_leader)
> > > +			continue;
> > > +
> > > +		p_stats = brute_stats_ptr(p);
> > > +		if (*p_stats != stats)
> > > +			continue;
> > > +
> > > +		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_PID);
> > > +		pr_warn_ratelimited("Offending process %d [%s] killed\n",
> > > +				    p->pid, p->comm);
> > > +	}
> > > +}
> 
> Thanks,
> John Wood

-- 
Kees Cook
