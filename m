Return-Path: <SRS0=P7Ng=6G=lists.openwall.com=kernel-hardening-return-18608-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31CAC54FCB
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 18:01:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 477012082E
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 18:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bIWTCp0/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 477012082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18608-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10204 invoked by uid 550); 22 Apr 2020 18:01:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10176 invoked from network); 22 Apr 2020 18:00:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587578447;
	bh=NABYNKvs9sdWR1s9Ukqb7xA7e+KXEGWr4qmakQtX2oQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bIWTCp0/uGUSMGuwWVLFng26QFFNEEyjpTIYnEYtTtH7rdtaX57uIzFs/BzvdR9ni
	 ePP+N0LiLAOGVfPbD9BA0ZOSUWHgZJ8tEHTtYdx82R6CSL4NLvVuWj/VZ9123jk92Y
	 AcNNFlBLukBMtR23rMiE1xDoXYGQUyefGhPfX8hc=
Date: Wed, 22 Apr 2020 19:00:40 +0100
From: Will Deacon <will@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 01/12] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20200422180040.GC3121@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200421021453.198187-1-samitolvanen@google.com>
 <20200421021453.198187-2-samitolvanen@google.com>
 <202004221052.489CCFEBC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202004221052.489CCFEBC@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Apr 22, 2020 at 10:54:45AM -0700, Kees Cook wrote:
> On Mon, Apr 20, 2020 at 07:14:42PM -0700, Sami Tolvanen wrote:
> > +void scs_release(struct task_struct *tsk)
> > +{
> > +	void *s;
> > +
> > +	s = __scs_base(tsk);
> > +	if (!s)
> > +		return;
> > +
> > +	WARN_ON(scs_corrupted(tsk));
> > +
> 
> I'd like to have task_set_scs(tsk, NULL) retained here, to avoid need to
> depend on the released task memory getting scrubbed at a later time.

Hmm, doesn't it get zeroed almost immediately by kmem_cache_free() if
INIT_ON_FREE_DEFAULT_ON is set? That seems much better than special-casing
SCS, as there's a tonne of other useful stuff kicking around in the
task_struct and treating this specially feels odd to me.

Will
