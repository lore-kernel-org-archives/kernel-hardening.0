Return-Path: <SRS0=cCHP=YS=lists.openwall.com=kernel-hardening-return-17132-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569F7CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 20:51:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A053C21872
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 20:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OMpIHy66"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A053C21872
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17132-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21691 invoked by uid 550); 25 Oct 2019 20:51:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21673 invoked from network); 25 Oct 2019 20:51:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SOwCMPM2O4ZOlwd3DBrA7iEvzDojcSJWVcNWTrD2V3A=;
        b=OMpIHy666PHw9erjn8xDTPpke8xQntbqoetTb755EO9PeDOpXuqP6XhDAI7uUr5fO2
         xmVL8gs1k0UTMM90x7YH/5ifo3akIvmtUP3P99Y8UkXss+I/VMnYl83cvTyhYTBE+xXo
         cZnJNJr5EGcHbCKDOw5qzZmWgscClEDk8K70pc2sU5/7TsNOz3qMBup0ghahhpvfFUWg
         vkZUy83KnTruoWWThCWKQaNjwulexQFfxNHsd7rgNtxCf3BUJ3Swu+Hls5xYOIdyzbqN
         pTUp3jauqQWIFYhE31Un5fjVTn41lvbrOA703W64zMOhKqcxNHtTJHVm5pwg8QOK9PnF
         Ba7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SOwCMPM2O4ZOlwd3DBrA7iEvzDojcSJWVcNWTrD2V3A=;
        b=r1qh50fTbSAMDHj6SghNm/GZgnYdJ6JPifI85uxnmOfF1kcXC8BcyQNrA8rePBfm2Y
         fVxYNyu7eCG1Z8L6KoYhxkW42m/pW4tSovbFKwYc1X6tVrSC3SvTX6ikYYGXPIcA1Nax
         4Z1WoTW8i92ZKKceZAmub8KNoH1rfZ5bIPfgqNPud+LMdM/qaxjNym8zprcUriskmsTg
         AAwyBBg/OMQRAeyXYSSCnyLkmggQ7AXMvB2VeRuCgmafr4/hlE9wEUM2WklkD9gwQSy9
         eXoBo2Nn1DBkBXYL3tXGNtuQQObFOnODLhES6LM9bEm4PAkUAJE9anXZwy2FrQPYm/Zx
         iikQ==
X-Gm-Message-State: APjAAAX+XQSBmZ8nrLO705R2JPrgP3KFHBEJyItnLOmJjfF6RYrJxwQS
	J1h3A+hZmguXIVFiLF08J9LYE9y5C14mpJ7L8nRF1w==
X-Google-Smtp-Source: APXvYqwitHy/uW9BgFO85xlL31gu4CkfssJm5Y58pk3pu/OFECEhzo8ZcmTg1xeRhUyxbxF5+qEX2qRHXCg/5F+6CB8=
X-Received: by 2002:a67:ed8b:: with SMTP id d11mr3107850vsp.104.1572036693631;
 Fri, 25 Oct 2019 13:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com> <20191024225132.13410-6-samitolvanen@google.com>
 <CAKwvOdmfXbnWf0dPN4EGCBVvppVRhuc=eq-pbfmotCCBaRN-Cw@mail.gmail.com>
In-Reply-To: <CAKwvOdmfXbnWf0dPN4EGCBVvppVRhuc=eq-pbfmotCCBaRN-Cw@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 25 Oct 2019 13:51:22 -0700
Message-ID: <CABCJKufR04dmzj3-7Uw0QkcHXvNd6h8XMPVV-hZ-AyOX-CJcjA@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 25, 2019 at 9:22 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> > +static void scs_free(void *s)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < SCS_CACHE_SIZE; i++) {
> > +               if (this_cpu_cmpxchg(scs_cache[i], 0, s) != 0)
> > +                       continue;
> > +
> > +               return;
> > +       }
>
> prefer:
>
> for ...:
>   if foo() == 0:
>     return
>
> to:
>
> for ...:
>   if foo() != 0:
>     continue
>   return

This was essentially copied from free_thread_stack in kernel/fork.c,
but I agree, your way is cleaner. I'll change this in the next
version. Thanks!

Sami
