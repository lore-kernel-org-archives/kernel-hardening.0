Return-Path: <SRS0=QkSI=ZT=lists.openwall.com=kernel-hardening-return-17444-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEAEC432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 20:08:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7BBE720661
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 20:08:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BBE720661
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17444-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17728 invoked by uid 550); 27 Nov 2019 20:08:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17694 invoked from network); 27 Nov 2019 20:08:21 -0000
X-Gm-Message-State: APjAAAV+o8rSrtmYW69mBZmQruXCmxpSUY7J/pZg3z9Vk03XGCfUllgh
	99veHXTcDXG3GnswMwn2v64AjBqLiffY8Mf2m/Q=
X-Google-Smtp-Source: APXvYqzcNVu3fO7i91gjwNcaV9OF6/CKyEXKbuREUw8EBcDiWjAHIfMXmGLuY9AakmO3RmUhj9WPcvhX6uYtvNag4BQ=
X-Received: by 2002:ae9:eb12:: with SMTP id b18mr6203027qkg.3.1574885288247;
 Wed, 27 Nov 2019 12:08:08 -0800 (PST)
MIME-Version: 1.0
References: <18FA40DC4B7A9742B8E58FC4CDA67429AFC83C55@dggeml526-mbx.china.huawei.com>
 <201911271013.38BA7015C6@keescook>
In-Reply-To: <201911271013.38BA7015C6@keescook>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 27 Nov 2019 21:07:51 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2ijLz0mtW5j9VamuQLdCOyLsr_wTVysi=X_XZyMGAOGw@mail.gmail.com>
Message-ID: <CAK8P3a2ijLz0mtW5j9VamuQLdCOyLsr_wTVysi=X_XZyMGAOGw@mail.gmail.com>
Subject: Re: Questions about "security functions" and "suppression of
 compilation alarms".
To: Kees Cook <keescook@chromium.org>
Cc: "Shiyunming (Seth, RTOS)" <shiyunming@huawei.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "lizi (D)" <lizi4@huawei.com>, 
	"Sunke (SK)" <sunke09@huawei.com>, Jiangyangyang <jiangyangyang@huawei.com>, 
	Linzichang <linzichang@huawei.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:hn+vC0lBjS89XgtCrdOWm8x1ncdj5wpRzCJxVao2VpoCzd43nrE
 sO3/uvqElIf+l/rex+Q9yZ7OmqePN738nldIrxP3KEJ/TeyDCCdTlSRaJv712vGAw0pjHM/
 ghXhj6xAwzbwh4XfucdWmUB2fWKTizXYyU0Km1hstYNMWjOg83x013skExn0jan+aMONGW1
 kKrpUKdupT0N2+OMsxgTw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YpjU34fH2jE=:xnlcSmOM1qs9NymzW/B5W8
 JpZBGzbvdfODVLIo1whsexE0l+Nq8HSHMMZjX4zYTjZnv+r597WSXtaur+VsXxFrixrbu9pbU
 KoyMTgmzow+/QBp+alCdRValIRUa/ldl1us449Ngl/nIAhLVXysLIgiKSOExsi5GQYEpgiisQ
 fqRSzbqDV4OoBnc4iwuwEPiVD8DsSDowLpFfhYpCOwuxtdlYvm3376UFhgAHYaoA8IS4lSPc/
 3ZJFgMGHfRo+i8K9NwmaX3OjjjFIupBdgl1qv8ju9w70LKBrr10TF9Nr6jKcova7ieE16FvJx
 2uXHQZ3thcvAtckLMdb2Hq+7s6uiIL+xOAta6wVaLxG0nucy0031sg5YswCOHdmPAsDSFvoUP
 NbwZGCY0VmJIhYPwo9Hb6aV6mHlpG0ae1Y6CsQpUiA7EoKt0vZNuWBu82GRoW4ZBtctGf3XwC
 IaMAZBS6I67e5ltG04/zmMyugKjNOi7N4+ixNPaVMy7A9I/SFNGDFIfx0WvQrDj2zqsJL1Y1t
 sHD707EUfU0opLlcF4O51Vtpv6c3O/7g+rRDWMYqYGQCFJeoAwxjMZWskveQAJjHHPsU5HWc5
 8PRmJUFpAEUX/JkjlSdX27lWKWAjfnsVDLaDKwFgUoIS8Th1ZdkbckyH3agfgwt3CP03GJlHW
 8MzDq/ioU4ugAwnBdb34xuIFv1iED5b68MUaO7eqDSSUA08AA3qLyshUCHUbcaY5SjEf3X1F4
 GvaiJ1UY3KJ9aZbcw8kQs1DP+NJ/cYoHwVe0f2tE+Y6rAuo/m/J2605/gozFQtAWxYBI39RTg
 8q8i/rBP2/xQP8crUsCcxqXvp0R1iqPyLdEpFmSGEVWHLac9g4muOvGRgkFElu/BTK8uu7g+d
 hO6Vf+TfySBG48Atzobg==

On Wed, Nov 27, 2019 at 8:01 PM Kees Cook <keescook@chromium.org> wrote:
> On Wed, Nov 27, 2019 at 01:11:50PM +0000, Shiyunming (Seth, RTOS) wrote:
> Each of these needs to be handled on a case-by-case basis. Kernel builds
> are expected to build without warnings, so before a new compiler flag
> can be added to the global build, all the instances need to be
> addressed. (Flags are regularly turned off because they are enabled by
> default in newer compiler versions but this causes too many warnings.)
> See the "W=1", "W=2", etc build options for enabling these:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/scripts/Makefile.extrawarn
>
> Once all instances of a warning are eliminated, these warnings can be
> moved to the top-level Makefile. Arnd Bergmann does a lot of this work
> and might be able to speak more coherently about this. :) For example,
> here is enabling of -Wmaybe-uninitialized back in the v4.10 kernel:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4324cb23f4569edcf76e637cdb3c1dfe8e8a85e4

Incidentally, I've worked on changing the way we handle warnings over
the past week, going through all ~700 warning options supported by
either clang or gcc to figure out how many instances we get and if
we are missing any important ones.

https://pastebin.com/wqG9QgHj has a list of the warnings that exist,
when they got added and how many I saw. I'll post this as proper
patches when I have integrated this into the build system better.

> Speaking specifically to your list:
>
> -Wformat-security
>   This has tons of false positives, and likely requires fixing the
>   compiler.

the only warning I see here is "warning: format not a string literal and
no format arguments", this seems useful at the W=1 or W=2
level, but I can't even think of how to change the compiler to
turn this on by default.

> -Wpointer-sign
>   Lots of things in the kernel pass pointers around in weird ways. This
>   is disabled to allow normal operation (which, combined with
>   -fwrapv-pointer and -fwrapv via -fno-strict-overflow) means signed
>   things and pointers behave without "undefined behavior". A lot of work
>   would be needed all over the kernel to enable this warning (and part
>   of that would be incrementally removing unexpected overflows of both
>   unsigned and signed arithmetic).

I have the suspicion that this would actually find some serious bugs,
but I also share your view that this is near-impossible to fix
throughout the kernel.

My experiments show around 3000 files that cause this warning,
though fixing the ones in shared header files would get us closer
to enabling it at W=1. Most of the output from this seems to be from
two header files.

> -Wframe-address
>   __builtin_frame_address() gets used in "safe" places on the
>   architectures where the limitations are understood, so adding this
>   warning doesn't gain anything because it's already rare and gets
>   some scrutiny.

This one could be enabled by default and then disabled locally
in functions that are known to be safe.

> -Wmaybe-uninitialized
>   And linked above, this is enabled by default since v4.10.
>
> -Wformat-overflow
>   See https://git.kernel.org/linus/bd664f6b3e376a8ef4990f87d08271cc2d01ba9a
>   for details. Eliminating these warnings (there were 1500) needs to
>   happen before they can be turned back on. Any help here is very
>   welcome!

In the current kernel, I see only around 100 files that produce this warning,
so this one is definitely in reach.

> Warnings seen from newly introduced code get fixed very quickly, yes.
> Problems that were already existing and are surfaced by new warnings
> tend to get less direct attention by maintainers since it creates a
> large amount of work where it is hard to measure the benefit. However,
> people contributing changes in these areas tend to be very well received.
> For example, Gustavo A. R. Silva did a huge amount of work to enable
> -Wimplicit-fallthrough: https://lwn.net/Articles/794944/

With the patch series I'm working on, we will be able to control the warning
level (W=1, W=12 etc) per file and per subsystem, which I hope should make
it easier to attack some of the hard problems by fixing a whole class
of warnings one subsystem at a time.

     Arnd
