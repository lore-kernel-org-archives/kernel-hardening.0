Return-Path: <SRS0=Ds+w=Y4=lists.openwall.com=kernel-hardening-return-17280-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75279CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 23:45:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BE6A4214E0
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 23:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XWr7kryZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE6A4214E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17280-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3933 invoked by uid 550); 4 Nov 2019 23:45:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3907 invoked from network); 4 Nov 2019 23:45:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SpNwJfSJO9MidRCrn2p9uupIwuhjvEPSgYuh9TBYZuw=;
        b=XWr7kryZXstmsXgYE4dBJ4NrnDur3s/AC0seExuiGF6z4UGQCwWfIPFNeY7JeVwPM3
         wnP1G5A/K76IWU2DyV/IUlCtYDCgPO0n/bDVtTP4pu+zHCoH+fei6dyO2OcLB2gsC6W7
         yHM2c0/FUmsEcEYZY0y9ta70pnWbez+C+rMSFS+aiM6DHbB5OA98h3MrtmOeV6q9EDtK
         bw1zfaHUujqN+zHGVRnnbiam+tcW3d2rc3/Pvust522b4CCrQ9v9kAdVmg3Axk3wD37y
         xqCPcphfjtbZ+wkJQy35r/dA4lS8knkpiqdmkjVq1MbYxp8Jbw1P5SRRjv/N4BJhioPs
         zRZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SpNwJfSJO9MidRCrn2p9uupIwuhjvEPSgYuh9TBYZuw=;
        b=dYoO31ZJURDZtbIxvCvcF9dGwFV4P2HVvycggNV0f3Ylwf07QfG/NIdrmPg8Ia+yc7
         iSUcn96CzLq9/Bj+tqToUWNSoWxbf7+/vnNL1ZsM/+fwjwcCL85M2GYcL9U7mlcd2eZz
         /dwhhvne/oYMv6uJSprEcUiwuo7CRs5TcM4vGwK65/tpxILn0zC/ntnM7zpqVlIeCO8D
         f3Yh/qGLGsaEyqNU+Jw7eoJrP5uJL/pKtCrQiScpijVhjNmYXMNs6Km6maRgXf6mZRpi
         MxtzlcAkwzGq9PASjWQAqKVz6c05bQ7Ee/yq7REb7t/jMy+Ufv7jp/CQqtwUoD3r2tZA
         +YLg==
X-Gm-Message-State: APjAAAXGFCWRdbdNBNmsiI7AjqvwQgrNPNr8Y1sPRXp+4iinuFKicBze
	kwx8Klhxb1oT2X3B7+dFnofZeLLrbCtuFqqqOmdS/g==
X-Google-Smtp-Source: APXvYqwMrHXnmCbhr/Nl5pMJrYHuxKP6Lu2UQKV7ItSK55vLCW1x6A4Use4SMcLe4G85I9Dvt99c2soxGNjz4r8rNRQ=
X-Received: by 2002:ab0:4587:: with SMTP id u7mr3850575uau.67.1572911090684;
 Mon, 04 Nov 2019 15:44:50 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-12-samitolvanen@google.com>
 <20191104171132.GB2024@lakrids.cambridge.arm.com>
In-Reply-To: <20191104171132.GB2024@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 15:44:39 -0800
Message-ID: <CABCJKufDnLjP9vA-wSW0gSY05Cbr=NOpJ-WCh-bdj2ZNq7VNXw@mail.gmail.com>
Subject: Re: [PATCH v4 11/17] arm64: disable function graph tracing with SCS
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 4, 2019 at 9:11 AM Mark Rutland <mark.rutland@arm.com> wrote:
> Can you please elaborate on _how_ this is incompatible in the commit
> message?
>
> For example, it's not clear to me if you mean that's functionally
> incompatible, or if you're trying to remove return-altering gadgets.
>
> If there's a functional incompatibility, please spell that out a bit
> more clearly. Likewise if this is about minimizing the set of places
> that can mess with control-flow outside of usual function conventions.

Sure, I'll add a better description in v5. In this case, the return
address is modified in the kernel stack, which means the changes are
ignored with SCS.

Sami
