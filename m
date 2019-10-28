Return-Path: <SRS0=XpEX=YV=lists.openwall.com=kernel-hardening-return-17137-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFC6CA9EC0
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Oct 2019 16:15:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C4B0E208C0
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Oct 2019 16:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cRlJ8go8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4B0E208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17137-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7931 invoked by uid 550); 28 Oct 2019 16:15:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7913 invoked from network); 28 Oct 2019 16:15:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NAeDGv4mmTdcJjmFC/Y5EqwPqrlxkNMDKmTxGtNGkZY=;
        b=cRlJ8go8Gwg5sHkB7ZS3FAbbXtnMD/tbE+zSlh/I1r1/OC/G4k2GVu3K4ZQIVtSesK
         qWj5vEzyZr/kwqbQ/BTQz27rlFGtYiadnB4BjwV9Aanq9y6mIcNlZgE0TDCUZmzdfMAK
         pYXldXOHSP6bQqOp2tqseN1pN+uwLR+zn/EQU53d0ejxptXvTV4EloD/dPmL0glR+KIS
         nM5OLYggHmVr1GJPpWaCLHPpHehzf5Xxk2CL48eRGzuTedh2dhf7I58eB/9um9Q2ykj/
         fH8V56DN6X6u8meTksQpmCSDkwZZFwfBU/9m+m5LLJy37fUNh5yE52TZE9xDBcF8G6ck
         eKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NAeDGv4mmTdcJjmFC/Y5EqwPqrlxkNMDKmTxGtNGkZY=;
        b=RnOAzu2Qsah3uwse3aqnOsy7sxSy8Oo7whhvVd2ZtdgOPevAYl6gWqqVnRtuiaTwyO
         nyQt8FSZ4lEvYooy/ueWsO4fSOKBTpCjbavASXa/JYe5+OOX5QXOh6sG8WYBbNsC36Rp
         3wJuAGe5T9dQi7jgv2rK1xmqjP9VDj+S/Yb2Fz6iJulsyMTkEQCpQlGC9r8KbBFzGlks
         rax74IoNoLKo2AajrAArYWvz8KpBEfJv2rR0x2J5NBKzwng4KH0tGfHA5uwdXcwg/TsQ
         ZpJFINtFUSGfytRZa8J7r5ON44zBqkmfbxAjuIo5s1oFknJc5NUUlKB9zt2kGh62LCQQ
         lSKA==
X-Gm-Message-State: APjAAAV7X6EN/xPnfCX07C2vWQjN0WehQKq//+RYAvkLhFF1c8VrquLN
	6fnXX/xuQAkSF4wo8QSiKEWmWdCiinjHYnb+WDJgdg==
X-Google-Smtp-Source: APXvYqyErnDNeReEYHXLOlOQvJxZB1LCeRqzFRFTtzuu+yjPbfij2oddf0msvyrSOjimXhfQmIZ/10I+XmQJOMeVmmI=
X-Received: by 2002:a67:ffc7:: with SMTP id w7mr9278938vsq.15.1572279312128;
 Mon, 28 Oct 2019 09:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com> <20191024225132.13410-6-samitolvanen@google.com>
 <2c13c39acb55df5dbb0d40c806bb1d7dc4bde2ae.camel@perches.com>
 <CABCJKucUR=reCaOh_n8XGSZixmsckNtFXoaq_NOdB+iw-5UxMA@mail.gmail.com> <CANiq72n4o16TB53s6nLLrLCw6v0Brn8GAhKvdzzN7v1tNontCQ@mail.gmail.com>
In-Reply-To: <CANiq72n4o16TB53s6nLLrLCw6v0Brn8GAhKvdzzN7v1tNontCQ@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 28 Oct 2019 09:15:00 -0700
Message-ID: <CABCJKuexT3-AMiziJdDjKgW2iBW-aBuBJCTRFLK71wvpBkZ5Qg@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Dave Martin <Dave.Martin@arm.com>, Jann Horn <jannh@google.com>, Joe Perches <joe@perches.com>, 
	Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 28, 2019 at 8:31 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> We decided to do it like that when I introduced compiler_attributes.h.
>
> Given it is hidden behind a definition, we don't care about which one we use internally; therefore the idea was to avoid clashes as much as possible with other names/definitions/etc.
>
> The syntax is supported in the compilers we care about (for docs on attributes, the best reference is GCC's by the way).

Got it, thank you for explaining. I'll change this to __no_sanitize__
in v3 since Clang seems to be happy with either version.

Sami
