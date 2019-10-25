Return-Path: <SRS0=XCNT=YS=lists.openwall.com=kernel-hardening-return-17102-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CC2CA9EAF
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 01:31:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B85D921928
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 01:31:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="0SIQXQwQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B85D921928
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=socionext.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17102-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15817 invoked by uid 550); 25 Oct 2019 01:31:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15794 invoked from network); 25 Oct 2019 01:31:03 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x9P1UOuA005932
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1571967025;
	bh=L3Fa2XZ1rR+ziFoIK9l+QqKH+QTJz16N605WBJKiQ08=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=0SIQXQwQhh1nG3Yqd6tmVflYOaoOlqAekjd0xdn6Zi07vZyEXkPxfO9g1uiACQUA+
	 BWBLUbGASk+gLmcvxQmbg9ZOVrucrOq7z2aS832+D/lzsVhfY9bNUcbdi6ltYVFh0G
	 xBK7golhkiOOugp5PYL5Ie3sVQ9XKa3hWicNYIKq44MJ/1fjvp2SqvffEg3ek0R0g9
	 JLS7VdsGskxwNX99/NJ9oWk/5p7NjGUq8uFUfVVqrJSzmnsnLUcda4W0Of7E/56M4G
	 ptlyiiZxGvQBBn3j3jtdjyVcqz004L45L6aeHV05k5/Hp/6DQYBi0xrWQjuI5e/nTZ
	 733+qVQVymwLg==
X-Nifty-SrcIP: [209.85.221.171]
X-Gm-Message-State: APjAAAX6W48+ezh8PhIOCAZz9RBucprH2Nd3yIjD7L856Ut3hYV8xfN7
	Df+Q45Obsn2ae3M8Vhf9AfTHR6nHCsHZ9vGi+oA=
X-Google-Smtp-Source: APXvYqwjXYQwp/yhTV3LIZTGMXzTyh2zYajp4PvTFqLtiYYGsakd4IU2B4U96c7jAzih1Ho+3+Qk2o5Gu0wN5fG4gLo=
X-Received: by 2002:a1f:18ca:: with SMTP id 193mr828852vky.66.1571967024170;
 Thu, 24 Oct 2019 18:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com> <20191024225132.13410-17-samitolvanen@google.com>
In-Reply-To: <20191024225132.13410-17-samitolvanen@google.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Fri, 25 Oct 2019 10:29:47 +0900
X-Gmail-Original-Message-ID: <CAK7LNATPpL-B0APPXFcWPCR6ZTSrXv-v_ZkdFqjKJ4pwUpcWug@mail.gmail.com>
Message-ID: <CAK7LNATPpL-B0APPXFcWPCR6ZTSrXv-v_ZkdFqjKJ4pwUpcWug@mail.gmail.com>
Subject: Re: [PATCH v2 16/17] arm64: disable SCS for hypervisor code
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jann Horn <jannh@google.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 25, 2019 at 7:52 AM <samitolvanen@google.com> wrote:
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/kvm/hyp/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index ea710f674cb6..8289ea086e5e 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -28,3 +28,6 @@ GCOV_PROFILE  := n
>  KASAN_SANITIZE := n
>  UBSAN_SANITIZE := n
>  KCOV_INSTRUMENT        := n
> +
> +ORIG_CFLAGS := $(KBUILD_CFLAGS)
> +KBUILD_CFLAGS = $(subst $(CC_FLAGS_SCS),,$(ORIG_CFLAGS))


$(subst ... ) is not the correct use here.

It works like sed,   s/$(CC_CFLAGS_SCS)//
instead of matching by word.




KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))

is more correct, and simpler.




-- 
Best Regards
Masahiro Yamada
