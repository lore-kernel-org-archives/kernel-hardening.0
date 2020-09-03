Return-Path: <SRS0=fqTl=CM=lists.openwall.com=kernel-hardening-return-19756-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74BEC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:04:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0870A20716
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KSOF4MSb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0870A20716
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19756-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20216 invoked by uid 550); 3 Sep 2020 22:03:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20182 invoked from network); 3 Sep 2020 22:03:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qVIO+W41RwcDMaSobjfrJM37v+XlNEpsXghdOpMJtkI=;
        b=KSOF4MSbX4S87IQK+in03uGEn+ytQl9cZGyW6vDNozCbdjEAgInLMiYQKelxpagMl5
         df9b/zV8SpGeA2iaUig0Q+MwFtCPZ28+WIKxq9eXlq/Wqd7GExFDfcGlLp8y1mAoy6te
         zS6jijDRaye7xBQSACfoereqL7Lz3JDY21FkaYI+Fw7k67Kt0rdnapLXNgJhXsHyhm7Y
         hlEeZ4lRpKgWRNSwYIyS0ZNPVsv/wZ3NStKIflMJS4q4+n12JbEG9GPG0Q5FVCgUqH5k
         1+abDI3c1WFNhWHsCv2v/A8XJ1YBYFMlewBw3NbKj1gZ1Og8okZuumffy5glY7Vb2XSt
         +iTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qVIO+W41RwcDMaSobjfrJM37v+XlNEpsXghdOpMJtkI=;
        b=bnwcrmoISxgnc7ZXxu/LFcASpS6IfsgXqsCsiVaVSf3aixjarNdOKpoou/gaz8oL+V
         7wOVNJpwLVCYa91HVrWi62FAOWhIlSDS4XQS7Qb0tBp34wyKjOuuvrC3KW65ogyH/6nK
         CCH0H8ZGcr0DIMmfRYwyWZb7GbDay9NQspDiuTNyhCNO5UW0KxUFMrYv3wKbD7BRHMnd
         BZ/v3Zcs/2J6dB8oxordtDcinIDp6N90tgtur28uPVwYvDhjpGcHHgDis3gXVk5vQbxo
         hYPoDNUWjxRr8NZs+gJxWw4SdBcg8w4Dv+MER388lQxo0Em55KxLSPDacO0yJWE1rorj
         v5lw==
X-Gm-Message-State: AOAM530Prkn6qNVmShQWDOfPCgmFbpAvKW8JBCd9SBphRBr0oInID2ZI
	YpLmt230z1afu697Yc92I7nTYufWT7/rX3G6yAgZtw==
X-Google-Smtp-Source: ABdhPJz8wZUegnpJXZZBut1xff7mQk50TpWZj/RnJoIZEh3bEYGVn9VJa+mmP5IBGCFzg96FVhHvLJwNs9ID1NpA3wM=
X-Received: by 2002:a50:e004:: with SMTP id e4mr5429575edl.114.1599170621796;
 Thu, 03 Sep 2020 15:03:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com> <20200903203053.3411268-6-samitolvanen@google.com>
 <202009031450.31C71DB@keescook>
In-Reply-To: <202009031450.31C71DB@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 3 Sep 2020 15:03:30 -0700
Message-ID: <CABCJKueF1RbpOKHsA8yS_yMujzHi8dzAVz8APwpMJyMTTGhmDA@mail.gmail.com>
Subject: Re: [PATCH v2 05/28] objtool: Add a pass for generating __mcount_loc
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 3, 2020 at 2:51 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Sep 03, 2020 at 01:30:30PM -0700, Sami Tolvanen wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> >
> > Add the --mcount option for generating __mcount_loc sections
> > needed for dynamic ftrace. Using this pass requires the kernel to
> > be compiled with -mfentry and CC_USING_NOP_MCOUNT to be defined
> > in Makefile.
> >
> > Link: https://lore.kernel.org/lkml/20200625200235.GQ4781@hirez.programming.kicks-ass.net/
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>
> Hmm, I'm not sure why this hasn't gotten picked up yet. Is this expected
> to go through -tip or something else?

Note that I picked up this patch from Peter's original email, to which
I included a link in the commit message, but it wasn't officially
submitted as a patch. However, the previous discussion seems to have
died, so I included the patch in this series, as it cleanly solves the
problem of whitelisting non-call references to __fentry__. I was
hoping for Peter and Steven to comment on how they prefer to proceed
here.

Sami
