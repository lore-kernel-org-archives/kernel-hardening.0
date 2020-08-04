Return-Path: <SRS0=9wgE=BO=lists.openwall.com=kernel-hardening-return-19550-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B21BC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  4 Aug 2020 11:45:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D35152075F
	for <kernel-hardening@archiver.kernel.org>; Tue,  4 Aug 2020 11:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TcvSJ7XZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D35152075F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19550-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28404 invoked by uid 550); 4 Aug 2020 11:45:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28103 invoked from network); 4 Aug 2020 00:48:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596502111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pni1o6aoiUKtw/3OfYS97iO3vEt5WV4q/1D+eS1+IJs=;
	b=TcvSJ7XZ/BwwDWzS4tntOJEvnfaZtkSCUPTPJkAmfHFT++9BPmycVGyN3nmIFe3SLct4M8
	3uwmlQA2QBrcGl0d8SPUTsohfqnx1Diq7euCgY1GJO2k4n2kjKFM4MoktnObUHN2ujm3AP
	Hf9Jr0wZOcz6FTNntPbCqwTAttUfXvg=
X-MC-Unique: Q5lytYKUP--GAurLnuzXlQ-1
Date: Mon, 3 Aug 2020 20:48:17 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
	Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200804004817.GD30810@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
 <20200803193837.GB30810@redhat.com>
 <202008031310.4F8DAA20@keescook>
 <20200803211228.GC30810@redhat.com>
 <202008031439.F1399A588@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008031439.F1399A588@keescook>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

Hi -

> > We have relocated based on sections, not some subset of function
> > symbols accessible that way, partly because DWARF line- and DIE- based
> > probes can map to addresses some way away from function symbols, into
> > function interiors, or cloned/moved bits of optimized code.  It would
> > take some work to prove that function-symbol based heuristic
> > arithmetic would have just as much reach.
> 
> Interesting. Do you have an example handy? 

No, I'm afraid I don't have one that I know cannot possibly be
expressed by reference to a function symbol only.  I'd look at
systemtap (4.3) probe point lists like:

% stap -vL 'kernel.statement("*@kernel/*verif*.c:*")'
% stap -vL 'module("amdgpu").statement("*@*execution*.c:*")'

which give an impression of computed PC addresses.

> It seems like something like that would reference the enclosing
> section, which means we can't just leave them out of the sysfs
> list... (but if such things never happen in the function-sections,
> then we *can* remove them...)

I'm not sure we can easily prove they can never happen there.

- FChE

