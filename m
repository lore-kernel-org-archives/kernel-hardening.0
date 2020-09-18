Return-Path: <SRS0=OqQr=C3=lists.openwall.com=kernel-hardening-return-19952-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A689CC43463
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 21:35:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BD91320663
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 21:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Qm/FmtT5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD91320663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19952-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24329 invoked by uid 550); 18 Sep 2020 21:35:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24306 invoked from network); 18 Sep 2020 21:35:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OsXO9Vng0uZ8zdPlCQEPUkvMN685QAvewZuZv3id6Vk=;
        b=Qm/FmtT5Dnyrxf4BCgQpgqbDw7sS/zTtWsVgCPYD/Z8fGcfQ5xbRlGReuouD+SHCd9
         dZJK4vmeSlLB9LbvCFrufdgXKAOEcR0Sj+Z6M4GjiMmOMsAqZazgwvwTj14O7ZQgEo98
         fFyktTytinUg2oHTwmTXsDyGhM3irl/3gs0Oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OsXO9Vng0uZ8zdPlCQEPUkvMN685QAvewZuZv3id6Vk=;
        b=lusUni+qkZ3AmodEA3Cq9ON2htGjmEzzZofulV0L/c2SUm9pKVoaxt7dnSniC7LKlR
         /dKcasizsHYmHiJS/NIAWa8QR10IkjNnYiDmnwmyFwVmbdIZ2+UJVZ7cZXwj6UlG1uC6
         iku9KixJDldn55WFJkMwYTFINkNXj5HK8u6tFtNBx+kaEJZlSKCOrD99XVFb5fXsPgyT
         ua4VIyKL7xoQ8JfyRZ/khNdGDdX05dTL49Df3JZqxXbFvKdz1Cng3iH1pLyepNJZMFBt
         kgY471gyx3Yc43EjIZlC8OikcYJSMfKa9kzyXv52lYV+o3GrYZyVtxGH2L4DMOZhDXUv
         5StQ==
X-Gm-Message-State: AOAM533j30oXz6iAgFlh51rpNRoBznD4M/FlONtTq4jMHgUgDlfHeAmc
	F4zUdh7sCktEuYc9AWoajDN82Q==
X-Google-Smtp-Source: ABdhPJyK4NrndRd3u8+tWx5b+nRCti5n/xaxbJJsCKhy+21AIJjWUWUQo+BNLBjVu3tDwrR5itradw==
X-Received: by 2002:a17:90a:156:: with SMTP id z22mr14965929pje.140.1600464914535;
        Fri, 18 Sep 2020 14:35:14 -0700 (PDT)
Date: Fri, 18 Sep 2020 14:35:12 -0700
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>,
	Matthew Wilcox <willy@infradead.org>,
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
Message-ID: <202009181433.EAF237C36@keescook>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-7-keescook@chromium.org>
 <202009101649.2A0BF95@keescook>
 <20200918152116.GB3229@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918152116.GB3229@ubuntu>

On Fri, Sep 18, 2020 at 06:02:16PM +0200, John Wood wrote:
> On Thu, Sep 10, 2020 at 04:56:19PM -0700, Kees Cook wrote:
> > On Thu, Sep 10, 2020 at 01:21:07PM -0700, Kees Cook wrote:
> > > +		pr_warn("fbfam: Offending process with PID %d killed\n",
> > > +			p->pid);
> >
> > I'd make this ratelimited (along with Jann's suggestions).
> 
> Sorry, but I don't understand what you mean with "make this ratelimited".
> A clarification would be greatly appreciated.

Ah! Yes, sorry for not being more clear. There are ratelimit helpers for
the pr_*() family of functions, e.g.:

	pr_warn_ratelimited("brute: Offending process with PID...

-- 
Kees Cook
