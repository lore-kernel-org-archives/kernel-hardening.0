Return-Path: <SRS0=aOKM=32=lists.openwall.com=kernel-hardening-return-17700-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B218C2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:06:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DB57E20730
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:06:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NeZA00Zg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB57E20730
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17700-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16209 invoked by uid 550); 6 Feb 2020 12:06:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16183 invoked from network); 6 Feb 2020 12:06:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YOaPcVEE5NfGq9wvnq0/vJzrPpGVkSOEyM+hIny1xiQ=;
        b=NeZA00ZgkpYbb57jZICxPQwzEkO47PnrZTJc74accDmoslXdCg9Y9+DDYQf85OELqc
         lM4Z7OJJMutdJRHHEeXLZhqvP/cJfQggycs1Ntn64XJm3iZNaCua1c1VTPNlxnc1/8MC
         KIcZ5PKTsO8DuOObuGbYqhYjNbgIGt5wFXzQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YOaPcVEE5NfGq9wvnq0/vJzrPpGVkSOEyM+hIny1xiQ=;
        b=gss4zoanQhxuxDIdJzPbUuS19B6X9CMtsgLjL43QIT74A5bevewuOrbYK3tOu6f4Lm
         inHdFcaKeDbPLn9xZ7JUa5NJ7zQaGAWG7MKeQOprIOXjuKFxSTjB7t2kIbcwmnIlyDqg
         DjdTLxxGp76kKSKbXMWxmkFqsgrV/aIrY2Pu5gZMahfg9u2270Pvu0Rym/HPBOqU6Ao5
         84M0XJ+Lxpe2ESD7N4vIfTp6TWvcNoenLLcn/AWHSjrECbypqQhNDJrIYmXxwZtdcqFk
         xQbT4fpqY7uUE+Dw+tKdYIBTQYDK3dufVjxCVIZVjNjLKtF9EAm2TdNqNScpDq6YBCcv
         lIGw==
X-Gm-Message-State: APjAAAUDbMaSiB8KS6xQIsglxXdZcCQ2hxGsoxEjgJtbBB150p9qUDQd
	vrbl/x/7CkoLRwEoWcehl/cvHQ==
X-Google-Smtp-Source: APXvYqxsX0xPKqXQ7FVbpOoF15/VUVG/NtfVZJQgYeMcBk/FwIaTRc4RuSWgy1tRMM+d4SxNSL/VDA==
X-Received: by 2002:a9d:6290:: with SMTP id x16mr29107620otk.343.1580990779855;
        Thu, 06 Feb 2020 04:06:19 -0800 (PST)
Date: Thu, 6 Feb 2020 04:06:17 -0800
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
Message-ID: <202002060356.BDFEEEFB6C@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-9-kristen@linux.intel.com>
 <20200206103830.GW14879@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206103830.GW14879@hirez.programming.kicks-ass.net>

On Thu, Feb 06, 2020 at 11:38:30AM +0100, Peter Zijlstra wrote:
> On Wed, Feb 05, 2020 at 02:39:47PM -0800, Kristen Carlson Accardi wrote:
> > +static long __start___ex_table_addr;
> > +static long __stop___ex_table_addr;
> > +static long _stext;
> > +static long _etext;
> > +static long _sinittext;
> > +static long _einittext;
> 
> Should you not also adjust __jump_table, __mcount_loc,
> __kprobe_blacklist and possibly others that include text addresses?

These don't appear to be sorted at build time. AIUI, the problem with
ex_table and kallsyms is that they're preprocessed at build time and
opaque to the linker's relocation generation.

For example, looking at __jump_table, it gets sorted at runtime:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/jump_label.c#n474

As you're likely aware, we have a number of "special"
sections like this, currently collected manually, see *_TEXT:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/vmlinux.lds.S#n128

I think we can actually add (most of) these to fg-kaslr's awareness (at
which point their order will be shuffled respective to other sections,
but with their content order unchanged), but it'll require a bit of
linker work. I'll mention this series's dependency on the linker's
orphaned section handling in another thread...

-- 
Kees Cook
