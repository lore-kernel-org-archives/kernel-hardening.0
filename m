Return-Path: <SRS0=fTW3=YW=lists.openwall.com=kernel-hardening-return-17151-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C073CA9EAE
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 20:36:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4483B208E3
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 20:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XRKGIdWY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4483B208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17151-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21588 invoked by uid 550); 29 Oct 2019 20:36:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21570 invoked from network); 29 Oct 2019 20:36:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=weRnPR6zYa479NAUpF9JwnzdoXArAq5BeasxBvL84nU=;
        b=XRKGIdWYXO3m1hY8XbcF6besNQxUfY5HowLorvgI06Il0r949+pXWQMiusqg7NW4bL
         n2NNmRL5tJyfSXfLwXr7irLEBpOMOdlwG+QXG7l00owKxPoCqxcVFS0Co7+QZnEhVhrx
         8hiqpPhiSobeO+7koU+UUdkIE7/OsB5eKgyfPEVzdKPlXsOqaBn4iJSkUSLvWYoQRQxk
         Si4ZeOrG1j0q/fl6GMEuuIYbz7P9KayVlQXJtPP+aorYT7EgrEvU87GvMYFOphF00Zmr
         DOXx0aTrS6kWE9mtAAA1s6aRq1rObI7RobGaMi6KzHKBxk/qXKTL4MMQ3U1t5+oBZe1Y
         +2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=weRnPR6zYa479NAUpF9JwnzdoXArAq5BeasxBvL84nU=;
        b=EWARHbiDYvgVT9TcaeB7W/MHITiE/uqCUk6o1xIVE6aTmahlEso+alBrAjqDcnLdjM
         eM2R6qOre2RzGiOnguOgVj/kO5c2h9eDhDWChI08fvmmhycPZqNTKGwY8k84J+DFP27Y
         5aIK622rIZXySVP/eZ66ejB4fvgKB93w2lKz1UNh4z+cVQ2ReJBwaD6t5iNGv1Y2cmvr
         2cMjRUY/uEPw5M5cJIuy/a50NxhaWwQ0TIlZEAQ2o3NZjbk9SfclwT3Kkopuhch5WM9m
         4Ehl4FLuLRSb6d0p1L+p+voiRRDaYcPCAl0R/AjV5MPDrAdsmoJdo1CdBaMukGFFX+kk
         kqeQ==
X-Gm-Message-State: APjAAAVcdczyg/JEH/8qeOpSjbnJr7y3UBN/eITL7CbrUTszisorcos2
	vhGHXOsO8du71SYZhhc5/yPUTypYsUzKLnDHFnpNJg==
X-Google-Smtp-Source: APXvYqw1QuYaZCWaZyhSYUpbUd82Cb158qMxFhGB8aJGfza75ZBKXzYxqXPG4i32Epk41OS84e6p4SgzgoHmtzZc06g=
X-Received: by 2002:a17:902:9b83:: with SMTP id y3mr579601plp.179.1572381353386;
 Tue, 29 Oct 2019 13:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com> <20191024225132.13410-10-samitolvanen@google.com>
 <20191025110313.GE40270@lakrids.cambridge.arm.com> <CABCJKud1xYEx_GVgfBHUuwNGKMxX+uVaE5TR6DEqo7CoSJJnNA@mail.gmail.com>
In-Reply-To: <CABCJKud1xYEx_GVgfBHUuwNGKMxX+uVaE5TR6DEqo7CoSJJnNA@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 29 Oct 2019 13:35:40 -0700
Message-ID: <CAKwvOdkxrYB=HTmtQ6sejPmWZh-mwJ-gyWRGgtZDrUOjBMftzg@mail.gmail.com>
Subject: Re: [PATCH v2 09/17] arm64: disable function graph tracing with SCS
To: Mark Rutland <mark.rutland@arm.com>, Kristof Beyls <Kristof.Beyls@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 29, 2019 at 10:45 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Fri, Oct 25, 2019 at 4:03 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > We have a similar issue with pointer authentication, and we're solving
> > that with -fpatchable-function-entry, which allows us to hook the
> > callsite before it does anything with the return address. IIUC we could
> > use the same mechanism here (and avoid introducing a third).
> >
> > Are there plans to implement -fpatchable-function-entry on the clang
> > side?
>
> I'm not sure if there are plans at the moment, but if this feature is
> needed for PAC, adding it to clang shouldn't be a problem. Nick, did
> you have any thoughts on this?

I didn't see anything explicitly in LLVM's issue tracker.  I also
didn't see -fpatchable-function-entry currently in -next other than
under arch/parisc.  Are there patches I can look at?

Has ARM's kernel team expressed the need to ARM's LLVM team?
-- 
Thanks,
~Nick Desaulniers
