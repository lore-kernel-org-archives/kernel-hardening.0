Return-Path: <SRS0=wDfi=YP=lists.openwall.com=kernel-hardening-return-17090-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E51CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 16:31:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ED98E214B2
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 16:31:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cCDDMZX0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED98E214B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17090-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1531 invoked by uid 550); 22 Oct 2019 16:31:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1510 invoked from network); 22 Oct 2019 16:31:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9VocBe87yk1uP4ALav5qYjXAzabfv0t7mZSWKaL+grs=;
        b=cCDDMZX0Jb2x10Ffc7B0hkZ/5rVJCIBvVRh+a3P1Z1H4X1pBo5MR6tNWJt0xVPzO24
         HshZq9Bj75NQmwJiHJTlcyjhNcexCdiCBasoYdcaHpoLfCkaieILhHGw5KUeR9u/QAKh
         9357+QmmIdmNEZVpouxbQBX8ie718Utq8dSVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9VocBe87yk1uP4ALav5qYjXAzabfv0t7mZSWKaL+grs=;
        b=GDEqUdaPuTiP8Px8ceykBEUTk9sTOVpX0hNJY5hK0Fm+kk64dcf1kpiRX096NJtyQh
         BreWSlm2+hLa3MFj1aUcBCcOumF0xg2PUu0su0jBwYyiQuoGasI8Q+1R4EU2wzdTI1Xq
         YBAA+L8nYjcUAEcmqVeIdyTfPtrBRq6gv00h0yksDyDWloTYrxNDdJmzleP0tq4g8mYf
         u5Xm5MmMI8pFFGnuSe4Yj+n+oBfE6g2QaQt4qOfZJoxxJHgd+vKoAKBalsRW0Z7KlUkN
         EiBFH2+X2YnjH/M6AQHKiAtIlYK5Yghdgj5cjyVY/oqyxOz1EMIJdRsuOScaH4jEBqmj
         tbMA==
X-Gm-Message-State: APjAAAVTE5zTDsQWW2hSkWo7bnzi7XaCyByzxofYPGuv0u9O43o0F7Es
	ty8bwYrYRe2cglYliBO3xRo1OQ==
X-Google-Smtp-Source: APXvYqwQTN+ovisoniBa1n9E3Frz5MHhvSc1BSk0yKuMv/BUOTRh21Gh2G29DkEAvhwb3Gv+V36/7A==
X-Received: by 2002:aa7:95b9:: with SMTP id a25mr5109950pfk.181.1571761855535;
        Tue, 22 Oct 2019 09:30:55 -0700 (PDT)
Date: Tue, 22 Oct 2019 09:30:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <201910220929.ADF807CC@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com>
 <20191022162826.GC699@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022162826.GC699@lakrids.cambridge.arm.com>

On Tue, Oct 22, 2019 at 05:28:27PM +0100, Mark Rutland wrote:
> On Fri, Oct 18, 2019 at 09:10:21AM -0700, Sami Tolvanen wrote:
> > This change adds generic support for Clang's Shadow Call Stack, which
> > uses a shadow stack to protect return addresses from being overwritten
> > by an attacker. Details are available here:
> > 
> >   https://clang.llvm.org/docs/ShadowCallStack.html
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  Makefile                       |   6 ++
> >  arch/Kconfig                   |  39 ++++++++
> >  include/linux/compiler-clang.h |   2 +
> >  include/linux/compiler_types.h |   4 +
> >  include/linux/scs.h            |  88 ++++++++++++++++++
> >  init/init_task.c               |   6 ++
> >  init/main.c                    |   3 +
> >  kernel/Makefile                |   1 +
> >  kernel/fork.c                  |   9 ++
> >  kernel/sched/core.c            |   2 +
> >  kernel/sched/sched.h           |   1 +
> >  kernel/scs.c                   | 162 +++++++++++++++++++++++++++++++++
> >  12 files changed, 323 insertions(+)
> >  create mode 100644 include/linux/scs.h
> >  create mode 100644 kernel/scs.c
> > 
> > diff --git a/Makefile b/Makefile
> > index ffd7a912fc46..e401fa500f62 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -846,6 +846,12 @@ ifdef CONFIG_LIVEPATCH
> >  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
> >  endif
> >  
> > +ifdef CONFIG_SHADOW_CALL_STACK
> > +KBUILD_CFLAGS	+= -fsanitize=shadow-call-stack
> > +DISABLE_SCS	:= -fno-sanitize=shadow-call-stack
> > +export DISABLE_SCS
> > +endif
> 
> I think it would be preferable to follow the example of CC_FLAGS_FTRACE
> so that this can be filtered out, e.g.
> 
> ifdef CONFIG_SHADOW_CALL_STACK
> CFLAGS_SCS := -fsanitize=shadow-call-stack
  ^^^ was this meant to be CC_FLAGS_SCS here

> KBUILD_CFLAGS += $(CFLAGS_SCS)
                     ^^^ and here?

> export CC_FLAGS_SCS
> endif
> 
> ... with removal being:
> 
> CFLAGS_REMOVE := $(CC_FLAGS_SCS)
> 
> ... or:
> 
> CFLAGS_REMOVE_obj.o := $(CC_FLAGS_SCS)
> 
> That way you only need to define the flags once, so the enable and
> disable falgs remain in sync by construction.
> 
> [...]

-- 
Kees Cook
