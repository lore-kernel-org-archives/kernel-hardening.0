Return-Path: <SRS0=Dp66=CR=lists.openwall.com=kernel-hardening-return-19826-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2847C433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 21:08:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 081F120659
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 21:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a7GjBHoh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 081F120659
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19826-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9314 invoked by uid 550); 8 Sep 2020 21:08:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9277 invoked from network); 8 Sep 2020 21:08:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wm1YZJP5IHcZuymW2XEKoD0pUveQe7CoNm7r9bi/W1k=;
        b=a7GjBHohAGSJ4PnMwooOuv5ACDnGE0C26cMuDHZo5+wvUiXv0xO8J2AUkV5JHb2FOP
         ldjjgjbqwFWCWq9Zw5W0LDK9PPh+xyYdY8hA2Wm743DJYsOoYFFThh9hJZBSdXRUCfFd
         cvOqVo7OMhMtAPX/2sp6Mz72uNjnDoYA9p//eZpjffoGYl/RG2xg8YzDi7C2OcRP5Eml
         H1IcomixFJ6jH0HEQSWDpcx4jVmZUZKnlbr7q8YvW0FORqPMCHn3losN4VKggIRBYbX6
         PtF8QxirnS7Espc0n9SSG2KH2rmz6/CIoNi2jCnfqCKNNgM5GJGJNXvMfd4DY5Oii+fR
         uTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wm1YZJP5IHcZuymW2XEKoD0pUveQe7CoNm7r9bi/W1k=;
        b=fJrcNXJ9ZH0/1V1VFdAEe8Z+LLiggo6c4gR2+c6SqytR/SgGE8X4KfvZonjWHuCIuX
         jsSjUKbkcb/TJ/II3CeYFfWFdJhpYsPSEZCwHsEfGvTPY9NzYt01OA3yKzX/BV5XAl2j
         VnFxV+v41LBjJrp329dnrvXG7gAeCZIbKw+WbbZOj18/K1Q5xo3vRhtLpPIER5ed83+p
         qrYOqNWrFjfKJGF9hbPBHwy8Qzf0buDDY0wmiMZQO8w4lH4kfFyU9JqCPuhVVd14y6+5
         hBkT54+PV2idFQ1VF5lUd9jDlxVaCz3TJpmRi1PAObC3igDA9L4aamADKP9aJT1WETN6
         cPYQ==
X-Gm-Message-State: AOAM531Qgk7H9xdzyOnWnKS/Gd5MbFVzO/bgOS99wYT09XMrOufo/qOY
	fCTR2o/aJKEGtBOZH4jiPC1dMg==
X-Google-Smtp-Source: ABdhPJz6/bLvTnKJTjhD++qFUgr8FkqyQitq4tmijOh19Mp/UXDDqyF/xILPr1db4moWKg5d5d7hXA==
X-Received: by 2002:a17:902:c38a:: with SMTP id g10mr511116plg.23.1599599275319;
        Tue, 08 Sep 2020 14:07:55 -0700 (PDT)
Date: Tue, 8 Sep 2020 14:07:48 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 13/28] kbuild: lto: merge module sections
Message-ID: <20200908210748.GB1060586@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-14-samitolvanen@google.com>
 <CAK7LNARnh-7a8Lq-y2u72cnk2uxSuWxjaZ8Y-JHCYu5gwt7Ekg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNARnh-7a8Lq-y2u72cnk2uxSuWxjaZ8Y-JHCYu5gwt7Ekg@mail.gmail.com>

On Tue, Sep 08, 2020 at 12:25:54AM +0900, Masahiro Yamada wrote:
> On Fri, Sep 4, 2020 at 5:31 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > LLD always splits sections with LTO, which increases module sizes. This
> > change adds a linker script that merges the split sections in the final
> > module.
> >
> > Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  Makefile               |  2 ++
> >  scripts/module-lto.lds | 26 ++++++++++++++++++++++++++
> >  2 files changed, 28 insertions(+)
> >  create mode 100644 scripts/module-lto.lds
> >
> > diff --git a/Makefile b/Makefile
> > index c69e07bd506a..bb82a4323f1d 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -921,6 +921,8 @@ CC_FLAGS_LTO_CLANG += -fvisibility=default
> >  # Limit inlining across translation units to reduce binary size
> >  LD_FLAGS_LTO_CLANG := -mllvm -import-instr-limit=5
> >  KBUILD_LDFLAGS += $(LD_FLAGS_LTO_CLANG)
> > +
> > +KBUILD_LDS_MODULE += $(srctree)/scripts/module-lto.lds
> >  endif
> >
> >  ifdef CONFIG_LTO
> > diff --git a/scripts/module-lto.lds b/scripts/module-lto.lds
> > new file mode 100644
> > index 000000000000..cbb11dc3639a
> > --- /dev/null
> > +++ b/scripts/module-lto.lds
> > @@ -0,0 +1,26 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
> > + * -ffunction-sections, which increases the size of the final module.
> > + * Merge the split sections in the final binary.
> > + */
> > +SECTIONS {
> > +       __patchable_function_entries : { *(__patchable_function_entries) }
> > +
> > +       .bss : {
> > +               *(.bss .bss.[0-9a-zA-Z_]*)
> > +               *(.bss..L*)
> > +       }
> > +
> > +       .data : {
> > +               *(.data .data.[0-9a-zA-Z_]*)
> > +               *(.data..L*)
> > +       }
> > +
> > +       .rodata : {
> > +               *(.rodata .rodata.[0-9a-zA-Z_]*)
> > +               *(.rodata..L*)
> > +       }
> > +
> > +       .text : { *(.text .text.[0-9a-zA-Z_]*) }
> > +}
> > --
> > 2.28.0.402.g5ffc5be6b7-goog
> >
> 
> 
> After I apply https://patchwork.kernel.org/patch/11757323/,
> is it possible to do like this ?
> 
> 
> #ifdef CONFIG_LTO
> SECTIONS {
>      ...
> };
> #endif
> 
> in scripts/module.lds.S

Yes, that should work. I'll change this in v3 after your change is
applied.

Sami
