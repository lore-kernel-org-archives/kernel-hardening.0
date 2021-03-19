Return-Path: <SRS0=npdC=IR=lists.openwall.com=kernel-hardening-return-20992-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE132C433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 18:40:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C640661976
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 18:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C640661976
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20992-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15543 invoked by uid 550); 19 Mar 2021 18:40:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15523 invoked from network); 19 Mar 2021 18:40:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3u9mAxNEw9z6za6KFcOo+uHqgiwiwZM5DCTyyspgn/o=;
        b=Yg6m4KOAXpRmtJyRDoH2yl2CHKC+3drp9u+T3OirmqRro1Mir6CpDUGmJiH6P/z7Kv
         6KqrLz2fDgze6egHZS4RwPVSKmftmVpcaI/zzQassSY0Au1qSOniGyFwnlpaKbGukS1B
         5ia9D9yVB+s3iHhoKPejUMLE1dxUY8uW3AgWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3u9mAxNEw9z6za6KFcOo+uHqgiwiwZM5DCTyyspgn/o=;
        b=F88J7TvasnxIWVTKNI3twGaXYJgHXGHtNtDcxnVqHnvKV8miTqMP1cgTJ/8b9Rda5J
         9GdyBmToixRa4BkdWweRqCVpwIeMrBjFOGOLlkr+bm40L7f2NuGwxcO0SpDBdFdbO+aF
         yCtfFcwFku0MtaWuKs+9Jlq6JkUzGRx1WhPI34iO50mlLka3mqvvwYYMCOazi21v8wFj
         10IktwNzKIjqdDDtRQMFQMGnsn5sGqVaeO10sc6OP/5I95ZaP6ZewsgYG7iAL3wihbn9
         5mTXdv1J884sQKcVeR9WEZr8gKPSmvs/poibvOzg/m+aR1W2G7jp9uAdfogWanpt9ZAR
         Aq7g==
X-Gm-Message-State: AOAM5336eLNiSZquCT4li3isoED4atsfnsRmg1XdVsI290s7HAV4tVPs
	IAOtm05jHEuG9+VegxQoVusUMA==
X-Google-Smtp-Source: ABdhPJw6vg1JHhR2dRDHudF/k8t7iI2PJ2EYrpqaNdHYFuKnjDOkJMrYPpYmCpqtqBVqRL+QAvirUw==
X-Received: by 2002:a17:902:ea0e:b029:e4:81d4:ddae with SMTP id s14-20020a170902ea0eb02900e481d4ddaemr15830817plg.12.1616179221292;
        Fri, 19 Mar 2021 11:40:21 -0700 (PDT)
Date: Fri, 19 Mar 2021 11:40:19 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v30 02/12] landlock: Add ruleset and domain management
Message-ID: <202103191114.C87C5E2B69@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-3-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316204252.427806-3-mic@digikod.net>

On Tue, Mar 16, 2021 at 09:42:42PM +0100, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> A Landlock ruleset is mainly a red-black tree with Landlock rules as
> nodes.  This enables quick update and lookup to match a requested
> access, e.g. to a file.  A ruleset is usable through a dedicated file
> descriptor (cf. following commit implementing syscalls) which enables a
> process to create and populate a ruleset with new rules.
> 
> A domain is a ruleset tied to a set of processes.  This group of rules
> defines the security policy enforced on these processes and their future
> children.  A domain can transition to a new domain which is the
> intersection of all its constraints and those of a ruleset provided by
> the current process.  This modification only impact the current process.
> This means that a process can only gain more constraints (i.e. lose
> accesses) over time.
> 
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Link: https://lore.kernel.org/r/20210316204252.427806-3-mic@digikod.net

(Aside: you appear to be self-adding your Link: tags -- AIUI, this is
normally done by whoever pulls your series. I've only seen Link: tags
added when needing to refer to something else not included in the
series.)

> [...]
> +static void put_rule(struct landlock_rule *const rule)
> +{
> +	might_sleep();
> +	if (!rule)
> +		return;
> +	landlock_put_object(rule->object);
> +	kfree(rule);
> +}

I'd expect this to be named "release" rather than "put" since it doesn't
do any lifetime reference counting.

> +static void build_check_ruleset(void)
> +{
> +	const struct landlock_ruleset ruleset = {
> +		.num_rules = ~0,
> +		.num_layers = ~0,
> +	};
> +
> +	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
> +	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
> +}

This is checking that the largest possible stored value is correctly
within the LANDLOCK_MAX_* macro value?

> [...]

The locking all looks right, and given your test coverage and syzkaller
work, it's hard for me to think of ways to prove it out any better. :)

Reviewed-by: Kees Cook <keescook@chromium.org>


-- 
Kees Cook
