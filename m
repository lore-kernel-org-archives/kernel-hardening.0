Return-Path: <SRS0=fNiW=FN=lists.openwall.com=kernel-hardening-return-20554-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B10C433FE
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 12:36:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 68F9723AFD
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Dec 2020 12:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68F9723AFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20554-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17623 invoked by uid 550); 9 Dec 2020 12:36:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17599 invoked from network); 9 Dec 2020 12:36:24 -0000
X-Gm-Message-State: AOAM5324QeOLoownlq8bXYnroXdi6IVGPu3e6HwTiqdiUuBKniTlG1Pd
	vSpKPqXIqTmIbMNudKisalV3/HuL99mRcZmRvNQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1607517371;
	bh=dVBkGQUoTPNqVA5YcFV16WWbYR7ZgobhVlfqccPyMMM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QMe8TgyKwG5RwbJWODTsjgFzwi7is/hUW972TN+CJAC8OlmQTclwY4t4o3NpXBDen
	 G0FZuP+wTgQyvKgL79TEeCn1xOpdP8R8eG9kiwnhftkhAUWq2DeAENsJ/WJCalSLmX
	 6cYxEmgX1SFU23nljhFb8v34P9oCzJdB7O0pfYlFcNm09dy3tMYMu5b+nJNemYg5Sz
	 N7hPMfIRDgpX2Vf/yRRJs7pwXzkUocC+4s1HqFvwpZN6Pp6qIDvgykV8o5KmXOZbzW
	 jmOKI+zRp3XRk3yA4qFqD3H9SW9YHyARfxSDwYAuQREW1ncN6x1r02319tc+Dk+0gL
	 A9YLQ1OTuXCgg==
X-Google-Smtp-Source: ABdhPJxvu8VJ4GLgSxlL8PXYZCRvk4pfoOrnmTaMOFmBWsnewmHehKYFMo7e2TQQj/VWUA2w/j4fFIk9/YjD+eZwBUs=
X-Received: by 2002:a9d:be1:: with SMTP id 88mr1530396oth.210.1607517370870;
 Wed, 09 Dec 2020 04:36:10 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com> <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
In-Reply-To: <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
From: Arnd Bergmann <arnd@kernel.org>
Date: Wed, 9 Dec 2020 13:35:54 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2DYDCjkqf7oqWFfBT_=rjyJGgnh6kBzUkR8GyvxsB6uQ@mail.gmail.com>
Message-ID: <CAK8P3a2DYDCjkqf7oqWFfBT_=rjyJGgnh6kBzUkR8GyvxsB6uQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 8, 2020 at 1:15 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> - one build seems to have dropped all symbols the string operations
> from vmlinux,
>   so while the link goes through, modules cannot be loaded:
>  ERROR: modpost: "memmove" [drivers/media/rc/rc-core.ko] undefined!
>  ERROR: modpost: "memcpy" [net/wireless/cfg80211.ko] undefined!
>  ERROR: modpost: "memcpy" [net/8021q/8021q.ko] undefined!
>  ERROR: modpost: "memset" [net/8021q/8021q.ko] undefined!
>  ERROR: modpost: "memcpy" [net/unix/unix.ko] undefined!
>  ERROR: modpost: "memset" [net/sched/cls_u32.ko] undefined!
>  ERROR: modpost: "memcpy" [net/sched/cls_u32.ko] undefined!
>  ERROR: modpost: "memset" [net/sched/sch_skbprio.ko] undefined!
>  ERROR: modpost: "memcpy" [net/802/garp.ko] undefined!
>  I first thought this was related to a clang-12 bug I saw the other day, but
>  this also happens with clang-11

It seems to happen because of CONFIG_TRIM_UNUSED_KSYMS,
which is a shame, since I think that is an option we'd always want to
have enabled with LTO, to allow more dead code to be eliminated.

       Arnd
