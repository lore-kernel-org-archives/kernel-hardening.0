Return-Path: <SRS0=KTvD=Y4=lists.openwall.com=kernel-hardening-return-17262-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197E3CA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 16:45:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 60ED5214B2
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 16:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qEkD0RxP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60ED5214B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17262-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18103 invoked by uid 550); 4 Nov 2019 16:45:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18080 invoked from network); 4 Nov 2019 16:45:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q70jm26u9XZ544CMir5SgVhhn3tMv2fVqzMb9N7sOwo=;
        b=qEkD0RxP0JDg+iMZcotgM/qHTN7at2kFFBokdWdXqjYduM5zyOwEzb2TF5aPwnGyJ3
         GT34egYWkFkybFCyXjpeUOgGUtHsLdMnwR3r/tcosjVnk2TPjaMxbZ3zqxLuzq3Q0RRF
         Oh6wfgCq2rIMgP+jt++OGpp1ISqo7UHu30guV7cm5uCCX+H4r4MBigW/CgWaNmLW9VJq
         2/gTPJkjrgjcGtP0nhe7qgw9AbOTU6CTmiss7csboTA+BTH/G63RbPHj+XXDW3dCA7n6
         TjIEjff1vDHSp3oHMOdERptntr71iuv2O2Oj7Sgb9b+R9FJV11RdWSg+4F/Tl4xy3wDJ
         TjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q70jm26u9XZ544CMir5SgVhhn3tMv2fVqzMb9N7sOwo=;
        b=Z517I6V+3cwjZjHB4YPavbzolTNOG/NcRMgU/TaOzOMw8DYvkGvh8vDjwyA4YZDrvE
         zt1M937QkD1zy942ijVA8ZVnFVtu1GjK6N5qEb63rQzbxOqt7M4Ry1olqnbSwgZmIDEH
         c4VlwQqfMMW2zlmrpKbzlxTrRrsTHUpXtJvBrYxAOKcMc8LWfuEH2TzwIl6IPlGXPHLH
         4F1bNDlhu8YAxwc2nAY8UkM4OM+wnuMOkiPMaFWR3NQn+miFbMlK/q95RIKRbspD0UKM
         spMya0J5w6nux4MdGetfTLgaIUaEO9ynvst5d+zYuVFF4EcTseyUfqOIUjGmYz3HVcaJ
         J5ng==
X-Gm-Message-State: APjAAAXStxJ1gOgmkS3wX5kgiDPqiQxrTZmKZWwJORw21i/iZvL/zvzx
	ypjPXxUeAVEhtJtCHq2UyI1Uz1phuHMcgRj8Rk/yjw==
X-Google-Smtp-Source: APXvYqz99RRfqGSGz1y7Naug/FRS2hfuYbKBvPPaSvNiJXzefuD28R3923vYy3sTY07Eql7i/9jWqya1BNOh2XyJLNc=
X-Received: by 2002:a05:6102:2041:: with SMTP id q1mr13051687vsr.15.1572885891823;
 Mon, 04 Nov 2019 08:44:51 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-5-samitolvanen@google.com>
 <20191104113929.GA45140@lakrids.cambridge.arm.com>
In-Reply-To: <20191104113929.GA45140@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 08:44:40 -0800
Message-ID: <CABCJKueiLpJTB3Vv7EpuQc5mn-n5k2x12dyXsuBdvbp7dDYm=Q@mail.gmail.com>
Subject: Re: [PATCH v4 04/17] arm64: kernel: avoid x18 __cpu_soft_restart
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

On Mon, Nov 4, 2019 at 3:39 AM Mark Rutland <mark.rutland@arm.com> wrote:
> Trivial nit, but the commit title is missing "in" between x18 and
> __cpu_soft_restart.

Oops, thanks for pointing that out. I'll fix this in v5.

Sami
