Return-Path: <SRS0=JFug=BN=lists.openwall.com=kernel-hardening-return-19545-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B670DC433DF
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 19:41:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB94022C9F
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Aug 2020 19:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RrRBh6Ug"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB94022C9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19545-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12069 invoked by uid 550); 3 Aug 2020 19:41:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11482 invoked from network); 3 Aug 2020 19:39:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596483538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KwaJzAuhKp0eMDKUyFcMapFzk1bqmh48WPQrufCV124=;
	b=RrRBh6UgHcD019r+czIwpUmisJzF5qytwTCkTGlTa75kBrco3FLA+Isi3sVG9nGVuG8GUr
	qCUSJnt7aKs6z/bbW4I0cX9OYAqoOZOjeAw/HxmwYzbaB5eu495sArBemuNlb0JAWLUgQA
	ZgL6TNrw2iDL+KiLvKQ/CnEINp+OpMA=
X-MC-Unique: POlseAWyM4uGgMhDrzYE7A-1
Date: Mon, 3 Aug 2020 15:38:37 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Kees Cook <keescook@chromium.org>,
	Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
	Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200803193837.GB30810@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

Hi -

> > While this does seem to be the right solution for the extant problem, I
> > do want to take a moment and ask if the function sections need to be
> > exposed at all? What tools use this information, and do they just want
> > to see the bounds of the code region? (i.e. the start/end of all the
> > .text* sections) Perhaps .text.* could be excluded from the sysfs
> > section list?

> [[cc += FChE, see [0] for Evgenii's full mail ]]

Thanks!

> It looks like debugging tools like systemtap [1], gdb [2] and its
> add-symbol-file cmd, etc. peek at the /sys/module/<MOD>/section/ info.
> But yeah, it would be preferable if we didn't export a long sysfs
> representation if nobody actually needs it.

Systemtap needs to know base addresses of loaded text & data sections,
in order to perform relocation of probe point PCs and context data
addresses.  It uses /sys/module/...., kind of under protest, because
there seems to exist no MODULE_EXPORT'd API to get at that information
some other way.

- FChE

