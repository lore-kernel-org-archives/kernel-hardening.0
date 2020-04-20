Return-Path: <SRS0=KBZo=6E=lists.openwall.com=kernel-hardening-return-18580-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14F2C54FCC
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 22:24:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4CD3B206DD
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 22:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ubLDLsXE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CD3B206DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18580-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30353 invoked by uid 550); 20 Apr 2020 22:24:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30327 invoked from network); 20 Apr 2020 22:24:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DV6jlkNA0aYuGGTHJFqAlVIWbRQ6V/i9e8cl7YrriE0=;
        b=ubLDLsXEcS+gRy7NCuBS0U8hRfvDH8rbExG4hDMZ/UPB3Z0OlbN5956SCN9w+6vt4s
         i83qKMAoJ8s6PECVYrrc48ILh1tnEurqEwv6c7qI9bHt4RPg/ZBGxoaZyy/j42XiO4dZ
         szcTBlYZ8evRbhYds+7lmWbRUWuouJm359n2RL7FTpFj1Nv1nKihW9WTUcwiDozzD5WY
         y79OD8sZ5VE5Gw8TQs24EtaXvjyqhd4U03u/RPmN+nWebpW7jIQxR6i14XX2UtNodQmJ
         G8FQ1K1xAaTx89lJDQ/zwRRShkgammuw55ZrtUzq7jvDzTQEV7jKgg9hy2uo610Rayz4
         c41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DV6jlkNA0aYuGGTHJFqAlVIWbRQ6V/i9e8cl7YrriE0=;
        b=F/l/hj/XBE5jj7q9tg5j/7ITg3sSoVKwN9rD9xGjDF4Fz4k+iXv5FTQBuAu8q8C7Fm
         N9keS0WKG/wFcd7UPXijpSHGkptpbd2847Br+cmUFh+1z2gylijDUhp8m7q3Mof1iu/O
         eGIVDgjjN6TAmQOQ7OR28+CSCjsYxi9/3zGzH6LMbNnmJp67CZ+rDsuDKnUdDnBgPfn2
         I7Gk5ypJ/oGZTy0ChW9Qn6Cex56bkn4QneNhbqfnRfapMZxl770z274mRlQsNSvlVWvp
         GOzuy1iO4JELk2ZmVpmkbXxWp2Y/jwSg0Vgx0uu4VXQ76pXvFuxLjAQIpPpf2PYmm3Ah
         makw==
X-Gm-Message-State: AGi0PuahEF7gZg+QimxzrtWL1pns6Pa8XXaBtNBd3CDK9SD8Q99nhnop
	Mz0B8Q0s+AOm+7SL00pyZYM2uw==
X-Google-Smtp-Source: APiQypK3lXJJ8OnZ7ClIxD0BeYEB6XEfm/pjTCKJqF60XnIqxkjWXsIItatZa73ZW9cYSXO2hPmHIw==
X-Received: by 2002:a63:df0a:: with SMTP id u10mr18587666pgg.79.1587421475507;
        Mon, 20 Apr 2020 15:24:35 -0700 (PDT)
Date: Mon, 20 Apr 2020 15:24:28 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 03/12] scs: add support for stack usage debugging
Message-ID: <20200420222428.GB77284@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-4-samitolvanen@google.com>
 <20200420171741.GC24386@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420171741.GC24386@willie-the-truck>

On Mon, Apr 20, 2020 at 06:17:42PM +0100, Will Deacon wrote:
> > +#ifdef CONFIG_DEBUG_STACK_USAGE
> > +static inline unsigned long scs_used(struct task_struct *tsk)
> > +{
> > +	unsigned long *p = __scs_base(tsk);
> > +	unsigned long *end = scs_magic(p);
> > +	unsigned long s = (unsigned long)p;
> > +
> > +	while (p < end && READ_ONCE_NOCHECK(*p))
> > +		p++;
> 
> I think the expectation is that the caller has already checked that the
> stack is not corrupted, so I'd probably throw a couple of underscores
> in front of the function name, along with a comment.

Correct. I'll do that.

> Also, is tsk ever != current?

This is only called from scs_release(), so tsk is never current.

> > +static void scs_check_usage(struct task_struct *tsk)
> > +{
> > +	static DEFINE_SPINLOCK(lock);
> > +	static unsigned long highest;
> > +	unsigned long used = scs_used(tsk);
> > +
> > +	if (used <= highest)
> > +		return;
> > +
> > +	spin_lock(&lock);
> > +
> > +	if (used > highest) {
> > +		pr_info("%s (%d): highest shadow stack usage: %lu bytes\n",
> > +			tsk->comm, task_pid_nr(tsk), used);
> > +		highest = used;
> > +	}
> > +
> > +	spin_unlock(&lock);
> 
> Do you really need this lock? I'd have thought you could cmpxchg()
> highest instead.

This is similar to check_stack_usage in kernel/exit.c, but yes, I can
change this to a cmpxchg() loop instead.

Sami
