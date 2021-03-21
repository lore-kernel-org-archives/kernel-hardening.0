Return-Path: <SRS0=Shmv=IT=lists.openwall.com=kernel-hardening-return-21026-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4237FC433C1
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 18:01:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1598661939
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 18:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1598661939
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21026-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1185 invoked by uid 550); 21 Mar 2021 18:01:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1153 invoked from network); 21 Mar 2021 18:01:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iBrKCN7co0fN6DQ3Z7oVF42ggkUDpYbjPmhV3o6bWXE=;
        b=cCKPMhwksUZ+yG1vaCu6wa8LkufPS1iF7vvliCffs1hluULxo1HADGt4q9mvtjBqIR
         U1ubZko3f81D30hNlvfAjNKNIaI/FvSlsAfUF32Cr2jNM/Z3Uvzr6yN9spxjY+SqBjwB
         ZW++v4cMTbXPBele8dErnlXmZCdJPemi1xzbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iBrKCN7co0fN6DQ3Z7oVF42ggkUDpYbjPmhV3o6bWXE=;
        b=RVM1IUAHR1Hg5CAgv781n9hV3ejdyAyh8TJFbbtQ4qajnqAMy3T2ka0WQ1Hr5FyReO
         VpjAqxpQ6pqH7jEcsoJxxq5fkxPr9u4iEVh4T+bF1G1OqHrFOZZqulFrKp0xTw6xrTmS
         EMcGpkwwKxh8P2fJb5FMB8n29z72zo7bdKWYeTltI7+gsoEQzHFf1yLqrSmCEcY1/rZ8
         NWyPNQ4U6p+3Lty+SRQZpf1yoUmhpOBcxmvEDsmlE5DhFMGPrNlmVN7iB0tzbkAjlHGx
         RT7ixD106+WMR3iwZK912VDtq+K2QMYa5eHYr1IQOTazUEazQUv4pYvhWuHunl7yaSwV
         iTKw==
X-Gm-Message-State: AOAM532GmxHcK0JDcamk2u7iCEePxNF4oQ9RZLsW15IMpZn63lHp8r+V
	AYwRR7QcdGxJdXs+yo9dKG7ajw==
X-Google-Smtp-Source: ABdhPJzKcyFhLu+VVYrkrgFkX1seObKVaaqxd2+uvQ/k/gufXuSV0xwmK/GIaFl5VVtZ13L/Yakkaw==
X-Received: by 2002:a17:90b:116:: with SMTP id p22mr9044261pjz.161.1616349664842;
        Sun, 21 Mar 2021 11:01:04 -0700 (PDT)
Date: Sun, 21 Mar 2021 11:01:03 -0700
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
Subject: Re: [PATCH v6 4/8] security/brute: Fine tuning the attack detection
Message-ID: <202103211038.99C87F12@keescook>
References: <20210307113031.11671-1-john.wood@gmx.com>
 <20210307113031.11671-5-john.wood@gmx.com>
 <202103171957.16C0560D@keescook>
 <20210320154648.GC3023@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320154648.GC3023@ubuntu>

On Sat, Mar 20, 2021 at 04:46:48PM +0100, John Wood wrote:
> On Wed, Mar 17, 2021 at 09:00:51PM -0700, Kees Cook wrote:
> > On Sun, Mar 07, 2021 at 12:30:27PM +0100, John Wood wrote:
> > > +/**
> > > + * brute_reset_stats() - Reset the statistical data.
> > > + * @stats: Statistics to be reset.
> > > + * @is_setid: The executable file has the setid flags set.
> > > + *
> > > + * Reset the faults and period and set the last crash timestamp to now. This
> > > + * way, it is possible to compute the application crash period at the next
> > > + * fault. Also, save the credentials of the current task and update the
> > > + * bounds_crossed flag based on a previous network activity and the is_setid
> > > + * parameter.
> > > + *
> > > + * The statistics to be reset cannot be NULL.
> > > + *
> > > + * Context: Must be called with interrupts disabled and brute_stats_ptr_lock
> > > + *          and brute_stats::lock held.
> > > + */
> > > +static void brute_reset_stats(struct brute_stats *stats, bool is_setid)
> > > +{
> > > +	const struct cred *cred = current_cred();
> > > +
> > > +	stats->faults = 0;
> > > +	stats->jiffies = get_jiffies_64();
> > > +	stats->period = 0;
> > > +	stats->saved_cred.uid = cred->uid;
> > > +	stats->saved_cred.gid = cred->gid;
> > > +	stats->saved_cred.suid = cred->suid;
> > > +	stats->saved_cred.sgid = cred->sgid;
> > > +	stats->saved_cred.euid = cred->euid;
> > > +	stats->saved_cred.egid = cred->egid;
> > > +	stats->saved_cred.fsuid = cred->fsuid;
> > > +	stats->saved_cred.fsgid = cred->fsgid;
> > > +	stats->bounds_crossed = stats->network || is_setid;
> > > +}
> >
> > I would include brute_reset_stats() in the first patch (and add to it as
> > needed). To that end, it can start with a memset(stats, 0, sizeof(*stats));
> 
> So, need all the struct fields to be introduced in the initial patch?
> Even if they are not needed in the initial patch? I'm confused.

No, I meant try to introduce as much infrastructure as possible early in
the series. In this case, I was suggesting having introduced
brute_reset_stats() at the start, so that in this patch you'd just be
adding the new fields to the function. (Instead of both adding new
fields and changing the execution pattern.)

> > > +/**
> > > + * brute_network() - Target for the socket_sock_rcv_skb hook.
> > > + * @sk: Contains the sock (not socket) associated with the incoming sk_buff.
> > > + * @skb: Contains the incoming network data.
> > > + *
> > > + * A previous step to detect that a network to local boundary has been crossed
> > > + * is to detect if there is network activity. To do this, it is only necessary
> > > + * to check if there are data packets received from a network device other than
> > > + * loopback.
> > > + *
> > > + * It's mandatory to disable interrupts before acquiring brute_stats_ptr_lock
> > > + * and brute_stats::lock since the task_free hook can be called from an IRQ
> > > + * context during the execution of the socket_sock_rcv_skb hook.
> > > + *
> > > + * Return: -EFAULT if the current task doesn't have statistical data. Zero
> > > + *         otherwise.
> > > + */
> > > +static int brute_network(struct sock *sk, struct sk_buff *skb)
> > > +{
> > > +	struct brute_stats **stats;
> > > +	unsigned long flags;
> > > +
> > > +	if (!skb->dev || (skb->dev->flags & IFF_LOOPBACK))
> > > +		return 0;

I wonder if you need to also ignore netlink, unix sockets, etc, or does
the IFF_LOOPBACK cover those too?

> > > +
> > > +	stats = brute_stats_ptr(current);
> >
> > Uhh, is "current" valid here? I actually don't know this hook very well.
> 
> I think so, but I will try to study it. Thanks for noted this.

I think you might need to track the mapping of task to sock via
security_socket_post_create(), security_socket_accept(),
and/or security_socket_connect()?

Perhaps just mark it once with security_socket_post_create(), instead of
running a hook on every incoming network packet, too?

-Kees

> > > +	read_lock_irqsave(&brute_stats_ptr_lock, flags);
> > > +
> > > +	if (!*stats) {
> > > +		read_unlock_irqrestore(&brute_stats_ptr_lock, flags);
> > > +		return -EFAULT;
> > > +	}
> > > +
> > > +	spin_lock(&(*stats)->lock);
> > > +	(*stats)->network = true;
> > > +	spin_unlock(&(*stats)->lock);
> > > +	read_unlock_irqrestore(&brute_stats_ptr_lock, flags);
> > > +	return 0;
> > > +}
> 
> Thanks,
> John Wood

-- 
Kees Cook
