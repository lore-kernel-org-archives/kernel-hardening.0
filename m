Return-Path: <SRS0=F6jF=6H=lists.openwall.com=kernel-hardening-return-18617-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49181C54FD0
	for <kernel-hardening@archiver.kernel.org>; Thu, 23 Apr 2020 18:09:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A099320767
	for <kernel-hardening@archiver.kernel.org>; Thu, 23 Apr 2020 18:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CdFotNnq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A099320767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18617-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29922 invoked by uid 550); 23 Apr 2020 18:09:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29899 invoked from network); 23 Apr 2020 18:09:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KWVTVR9QPt8YpEnS6+rG3cx9IAZdQ2Peqca4Ud6UmSY=;
        b=CdFotNnqSpurMKkIu6CgBx6OkkmuS4dmePbH5JYO6Yb24rHfaG6bv/j6W3gwVuvGlR
         64PbSSNPaH8ceQMVqvMs5BZdL4WabMg/+3TPoVNadaUwZ1CIY5Ft1srs/S6AInLWxtLR
         iKNcf7yWw+tp7Mv+in+N3g014ylhLnJOJ++nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KWVTVR9QPt8YpEnS6+rG3cx9IAZdQ2Peqca4Ud6UmSY=;
        b=ir3weRnMdd2l51/hoLsEkRkJAhsnHjio/jPIhsp2h/ab6VF4h3WgqAOCYIlNZrm3V9
         XHswJ8SRdsR1bxv//QFWRBa1Yd9C52hioPa9y6YCdB1qXCcGNcfXcv75BYRhLzUUwZNa
         ObdJsvrYy+AT7bWgUl9NRV/arT3Zl+sDA8FRzunlnSguzFqdtc2UbLoMTMNQdZAXMYOF
         6Gcm22aEskmm3ZEkESomoPOSIIvS6hMD5cXXN78X7B0kkrTQzmZEjGjX4I3JAa8RkL89
         NJFV+Tf43b/iOjoJNibxamYtGCX0hU/tSO3pd0hsboAcTbnbxwL6Zl9WekcbKAI8phh0
         bZUg==
X-Gm-Message-State: AGi0PuZn49RROPquj5DYTYeCYY+JuDpiFgIxRjeMrzQQ21IO41sNdNuE
	lt+fY/t2QjJlTTALFFTHyZ6ybQ==
X-Google-Smtp-Source: APiQypLMPu77yfYvTCVDe2sNxmi176/dfhJmzHOmLBk67EV18fTOD0x11gPSr7XgMYCWAsHYZmXLuw==
X-Received: by 2002:a63:5c01:: with SMTP id q1mr4899728pgb.177.1587665367464;
        Thu, 23 Apr 2020 11:09:27 -0700 (PDT)
Date: Thu, 23 Apr 2020 11:09:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
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
Message-ID: <202004231108.1AC704F609@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200421021453.198187-1-samitolvanen@google.com>
 <20200421021453.198187-2-samitolvanen@google.com>
 <202004221052.489CCFEBC@keescook>
 <20200422180040.GC3121@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422180040.GC3121@willie-the-truck>

On Wed, Apr 22, 2020 at 07:00:40PM +0100, Will Deacon wrote:
> On Wed, Apr 22, 2020 at 10:54:45AM -0700, Kees Cook wrote:
> > On Mon, Apr 20, 2020 at 07:14:42PM -0700, Sami Tolvanen wrote:
> > > +void scs_release(struct task_struct *tsk)
> > > +{
> > > +	void *s;
> > > +
> > > +	s = __scs_base(tsk);
> > > +	if (!s)
> > > +		return;
> > > +
> > > +	WARN_ON(scs_corrupted(tsk));
> > > +
> > 
> > I'd like to have task_set_scs(tsk, NULL) retained here, to avoid need to
> > depend on the released task memory getting scrubbed at a later time.
> 
> Hmm, doesn't it get zeroed almost immediately by kmem_cache_free() if
> INIT_ON_FREE_DEFAULT_ON is set? That seems much better than special-casing
> SCS, as there's a tonne of other useful stuff kicking around in the
> task_struct and treating this specially feels odd to me.

That's going to be an uncommon config except for the most paranoid of
system builders. :) Having this get wiped particular thing wiped is just
a decent best practice for what is otherwise treated as a "secret", just
like crypto routines wipe their secrets before free().

-- 
Kees Cook
