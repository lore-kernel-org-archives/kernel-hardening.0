Return-Path: <SRS0=WV3+=YZ=lists.openwall.com=kernel-hardening-return-17220-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F94CCA9EC9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:59:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AA242208CB
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 03:59:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LILcQjVb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA242208CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17220-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1736 invoked by uid 550); 1 Nov 2019 03:59:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1712 invoked from network); 1 Nov 2019 03:59:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jWbfirm5A7lClilm5TrxMUwFVETsZ0QZ3dgXNGgwJk0=;
        b=LILcQjVb+J77OLR0Wqh8wnQrNbg/1wbjTbvcWvcASlmFUoRhF+FiABYaQL4F6fbQbF
         uxzeSY91YoL9miij3Kit1NzjdfNC1KqoUlTChwS9qCXgWIlOVwAzcIYT52gA3K2PVO/8
         zI4nwynvLe0KA4Pq1Usu8zAit0zL/9zkfYAew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jWbfirm5A7lClilm5TrxMUwFVETsZ0QZ3dgXNGgwJk0=;
        b=GfYHrILE1r8yttPpk0kwlj+sgBP8RjvOrHfHji5uPjHnL6Slml51eH/OBB7IWoKajs
         HIpkM4cB/xIJehceU7q/YEcp3WI/dFo63YfZHXkJEMvdod852ICQE0uKKJ8Ec2AeHm6S
         e05fSWYUBJyF6uVd8t4qjW0oloPenlKCWnqnacBgXw4c3lZmDFSSocUGnNs4qEwwxZEB
         jUireutr3BeTnT+gflQc75UJXjViv3kMi4PZ2vftSD59mp+dzDsVjrjWERkdG9cUC1zi
         5bXI3l+y7w1mgmg+Gb6OeFg4+mb4dYY60s0YhfDLhpoKZyE/oKB3Oao6aCEUiUkTlXnx
         560w==
X-Gm-Message-State: APjAAAXhLJEtzUuXs0uL0ABcgu+xlN8cg/zK7PfF0E1C8bAAKgj+TqCB
	ABrma7WxnfrDJXz9SAY7XYPDwg==
X-Google-Smtp-Source: APXvYqy5NPe898RXSU+w1c0UaOFby31e22ngkYRTC9hJdLIA+7oZafTpdC/J3+7KdM9QjpM8htFvPw==
X-Received: by 2002:a63:ee48:: with SMTP id n8mr11288858pgk.374.1572580772699;
        Thu, 31 Oct 2019 20:59:32 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:59:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 13/17] arm64: preserve x18 when CPU is suspended
Message-ID: <201910312059.59F983B@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-14-samitolvanen@google.com>
 <CAKwvOd=kcPS1CU=AUjOPr7SAipPFhs-v_mXi=AbqW5Vp9XUaiw@mail.gmail.com>
 <CABCJKudb2_OH5CRFm64rxv-VVnuOrO-ZOrXRHg8hR98Vj+BzVw@mail.gmail.com>
 <CAKwvOd=dO2QjiRWegjCtnMmVguaJ2YHacJRP3SbVVy9jhx-BWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=dO2QjiRWegjCtnMmVguaJ2YHacJRP3SbVVy9jhx-BWw@mail.gmail.com>

On Thu, Oct 31, 2019 at 10:34:53AM -0700, Nick Desaulniers wrote:
> On Thu, Oct 31, 2019 at 10:27 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Thu, Oct 31, 2019 at 10:18 AM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > > > +#ifdef CONFIG_SHADOW_CALL_STACK
> > > > +       ldr     x18, [x0, #96]
> > > > +       str     xzr, [x0, #96]
> > >
> > > How come we zero out x0+#96, but not for other offsets? Is this str necessary?
> >
> > It clears the shadow stack pointer from the sleep state buffer, which
> > is not strictly speaking necessary, but leaves one fewer place to find
> > it.
> 
> That sounds like a good idea.  Consider adding comments or to the
> commit message so that the str doesn't get removed accidentally in the
> future.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Yeah, with the comment added:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
