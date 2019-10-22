Return-Path: <SRS0=1Z1U=YP=lists.openwall.com=kernel-hardening-return-17093-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD22ECA9EA0
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 19:26:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 07A16218AE
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 19:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BdV4+MNe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07A16218AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17093-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20286 invoked by uid 550); 22 Oct 2019 19:26:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20268 invoked from network); 22 Oct 2019 19:26:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NTGK4hML4ErU1yKOstvLOpiuT4DQy76v/C1+bofd9Cw=;
        b=BdV4+MNeQ9Io6FliaBVrpzdd/Nr1h8xWmmKPqLZavn/hHAkGLeJ2uet5e2jLmOj9uw
         02VQSR42rlo3yyUxFWTBfUTG3kVtJp3J8w5R83ssOsenjeWTSoQZInKliiV+bqAG6hAA
         Cr0weCMeiEXT18hJy2vPqHUUe6n/7iKNV049vCXj2gJk8nyiep6jgB1jyPz0y6wDHnrH
         rp0x4DaWxgo9yWNjpZs5w6HMi+jVBQ6IUSdEhuv49ICHNrBPrHc5lLVdYfbNEBO09Rzu
         SMDk455vF04OVHUuXspa8XLEm5+OmO4KDEHRSmANl4blw+d+0MpTjuEcoQ56sSkWU7a6
         4HCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NTGK4hML4ErU1yKOstvLOpiuT4DQy76v/C1+bofd9Cw=;
        b=e+zcIJDVB5gKsjJR3zA7EYQoXYrT0Onlu6/9BEkj78CyhayDGIeAD/X/YDHbwQePp4
         42TUJkIXDlptewtGAAs22Ez1Oo1g3ZN+Qmx3z2jU41ov5d/7qJ/CTjMLrg/RqtjGmE6c
         EYDE8UJz3R/Sh7H58eNAWagkn/BU4N/q0Ctg2iFpjPnS1MBpr/oTlB4UjqSzZKGQEcDl
         YGVkHFtchVkG2BN+jn7KuhOCAMbZCwShk9i4TtbdjGHIuG9A0DumMyyYa2OT/Etup080
         raPRhMiqoA3OsfRyikjJzTttpSbpHw/8x+S/T5B8rtJYc5ZHTMK7oq7LGvpaw1EyomX/
         RdMA==
X-Gm-Message-State: APjAAAXENZ00eSX2YFVk1vN5GHrkC6fu5kGhB5HEVPfBBUezwYBkTD5j
	lgmLo4AIOfIH6aM3A/NeT8fmRFuDUqYV+PZxXwZX+g==
X-Google-Smtp-Source: APXvYqyhEGmciM5Qsci/BRxLCe2CZGxby7wB0F2s67O2j0nanCSBoYG8VKU/rHobm0lJBKjWBGnRu61RnSLD1gIaItA=
X-Received: by 2002:ab0:5981:: with SMTP id g1mr2987226uad.98.1571772374889;
 Tue, 22 Oct 2019 12:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <20191022162826.GC699@lakrids.cambridge.arm.com>
In-Reply-To: <20191022162826.GC699@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 22 Oct 2019 12:26:02 -0700
Message-ID: <CABCJKudxvS9Eehr0dEFUR4H44K-PUULbjrh0i=pP_r5MGrKptA@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 22, 2019 at 9:28 AM Mark Rutland <mark.rutland@arm.com> wrote:
> I think it would be preferable to follow the example of CC_FLAGS_FTRACE
> so that this can be filtered out, e.g.
>
> ifdef CONFIG_SHADOW_CALL_STACK
> CFLAGS_SCS := -fsanitize=shadow-call-stack
> KBUILD_CFLAGS += $(CFLAGS_SCS)
> export CC_FLAGS_SCS
> endif

Sure, SGTM.

> > +choice
> > +     prompt "Return-oriented programming (ROP) protection"
> > +     default ROP_PROTECTION_NONE
> > +     help
> > +       This option controls kernel protections against return-oriented
> > +       programming (ROP) attacks.
>
> Are we expecting more options here in future?

Yes, I believe we'd be interested in seeing PAC support too once
hardware is more readily available.

> I think it would be better to ./make that depend on !SHADOW_CALL_STACK, as
> it's plausible that we can add a different ROP protection mechanism that
> is compatible with kretprobes.

OK, I can change that and remove the choice. We can always add it back
when other alternatives are added.

> > +config SHADOW_CALL_STACK
> > +     bool "Clang Shadow Call Stack"
> > +     depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
> > +     depends on CC_IS_CLANG && CLANG_VERSION >= 70000
>
> Is there a reason for an explicit version check rather than a
> CC_HAS_<feature> check? e.g. was this available but broken in prior
> versions of clang?

No, this feature was added in Clang 7. However,
-fsanitize=shadow-call-stack might require architecture-specific
flags, so a simple $(cc-option, -fsanitize=shadow-call-stack) in
arch/Kconfig is not going to work. I could add something like this to
arch/arm64/Kconfig though:

select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
...
config CC_HAVE_SHADOW_CALL_STACK
       def_bool $(cc-option, -fsanitize=shadow-call-stack -ffixed-x18)

And then drop CC_IS_CLANG and version check entirely. Thoughts?

> > +#define SCS_GFP                      (GFP_KERNEL | __GFP_ZERO)
>
> Normally GFP_ is a prefix. For consistency, GFP_SCS would be preferable.

Ack.

> > +extern unsigned long init_shadow_call_stack[];
>
> Do we need this exposed here? IIUC this is only assigned by assembly in
> arch code.

True, it's not needed.

> [...]
>
> > +void scs_set_init_magic(struct task_struct *tsk)
> > +{
> > +     scs_save(tsk);
> > +     scs_set_magic(tsk);
> > +     scs_load(tsk);
> > +}
>
> Can we initialize this at compile time instead?

We can. I'll change this and drop the function.


Sami
