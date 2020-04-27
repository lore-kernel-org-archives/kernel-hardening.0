Return-Path: <SRS0=doBW=6L=lists.openwall.com=kernel-hardening-return-18650-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87B5C54FCB
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 17:02:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 11EC12076A
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 17:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNZ6aoSE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11EC12076A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18650-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25701 invoked by uid 550); 27 Apr 2020 17:02:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25673 invoked from network); 27 Apr 2020 17:02:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fz5fzGKUkYrlo1H6ujT5iT4E+OF3TxaMGxP6KIooVcQ=;
        b=dNZ6aoSEy7Lz5a9sDdJ7hoFwM3Ioe/buqvUh/XzcOLY+v/Lj94eIQWHMKCREcj9j0q
         VCEnS2J43l5VzkT6kYl5Lodvz+2yqryKx8JCo2k3IUPXzq9UL6+x1YRvrD55F0DkiUw6
         BWD6qzEghGEYP92HnzMEuDuwjNjpiqR6vQaXrrvJnSsqLbA4PltvdNA/bnVU3ZaxDzsa
         clII1ZYGWxtBmLwk7/Fts+qQwzHD6kf05CCyDbWN3aEoNbULRWN6lTw+CKZbeZCkwewA
         shL7BDdzLmw5o3aYNX8tt+Tr7sx4NJn08ejwFkm18Anpj9zq4Uf4rjnt8W1VFY+TVN0X
         qY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fz5fzGKUkYrlo1H6ujT5iT4E+OF3TxaMGxP6KIooVcQ=;
        b=Of1RyMalm2b79FSsqPvqGuQ9WZTGhvJWKIPsAkGnZr1AQijlBp+sls57q6kp1FfgH1
         GtjeSvF9O04sE2Fz/n/SMxO7OYUqyAkOuk47u2MQVQqxXydwz5aIGCzUYBd1wpt3EvxO
         ZNHnYRQeD29AfmhqGRFBkCoQgj18dgCEiXSyI/kgESB1muXXGmUBFhtZzBb32l5uI196
         W5PVfNpCtZ7E5PhKMiMXL6j8FYozh1RU7A/0kxehg+0GJ/RYbTqfMvZHjSGNl9N7yWoN
         vXwg1lw8coC1pDvv5bzqy8KVS/UsMCUn21GOkc1L3KjFSp+YArZ/BcBXjcy3s+O4PXCT
         TKXg==
X-Gm-Message-State: AGi0PuaywjN3NXAYLe9vHad0xg+XnMAOiKxWu6JdNcf21z90WKLygarr
	fBLp3hgVwUTuXtZvHkU8R4Fr2A==
X-Google-Smtp-Source: APiQypKpBJKrBpCU7oIXdhxhHbwoBTjqAi/2yT3gZcDS9xuBm1ijzttixQqfK4ktRUyLkm9P3o0Fcg==
X-Received: by 2002:a17:90a:9b82:: with SMTP id g2mr25145882pjp.72.1588006926605;
        Mon, 27 Apr 2020 10:02:06 -0700 (PDT)
Date: Mon, 27 Apr 2020 10:01:59 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Will Deacon <will@kernel.org>,
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
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 01/12] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20200427170159.GA236495@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200427160018.243569-1-samitolvanen@google.com>
 <20200427160018.243569-2-samitolvanen@google.com>
 <CANiq72=vvRcjWCON7zbaCTxLA2wP_-5zrnLyymR4g9b1gwc5kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72=vvRcjWCON7zbaCTxLA2wP_-5zrnLyymR4g9b1gwc5kg@mail.gmail.com>

On Mon, Apr 27, 2020 at 06:48:49PM +0200, Miguel Ojeda wrote:
> On Mon, Apr 27, 2020 at 6:00 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> > index 333a6695a918..18fc4d29ef27 100644
> > --- a/include/linux/compiler-clang.h
> > +++ b/include/linux/compiler-clang.h
> > @@ -42,3 +42,9 @@
> >   * compilers, like ICC.
> >   */
> >  #define barrier() __asm__ __volatile__("" : : : "memory")
> > +
> > +#if __has_feature(shadow_call_stack)
> > +# define __noscs       __attribute__((__no_sanitize__("shadow-call-stack")))
> > +#else
> > +# define __noscs
> > +#endif
> 
> Can we remove the `#else` branch? compiler_types.h [*] has to care
> anyway about that case for other compilers anyway, no?

Yes, it's unnecessary. I'll remove this in the next version. Thanks!

Sami
