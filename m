Return-Path: <SRS0=35Pn=ZT=lists.openwall.com=kernel-hardening-return-17443-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD8CC432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 19:01:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8321120715
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 19:01:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Y/58F3q4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8321120715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17443-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21762 invoked by uid 550); 27 Nov 2019 19:01:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21706 invoked from network); 27 Nov 2019 19:01:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eAnHFgyJiPx1fiIRfzMvTGcNXS0KAsf3uk+CKAYZmOQ=;
        b=Y/58F3q4kFg6bgZ+GKBOeyRth14K4XJaXSaX7j0JV73eKg0WGAUKypXjTwmXkCuJGb
         r79Yfdh5ucPuwARv+OZi99p7jqBkeE4mULwsXqr0scuuJje9msDNz+2ZP6/WXYgDLZ7N
         8cilwxePecUuN3ps77W903OmEQJG6xCFo5zKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eAnHFgyJiPx1fiIRfzMvTGcNXS0KAsf3uk+CKAYZmOQ=;
        b=JC77BdP0KTAqYMXb7HBbhsgDxpCbTzhPwnpjooYUb0chBvv6bhjelgaC4TvBElQSiH
         2nsYHPdTXLwIjYcDp/mPikfT7frngNpqReajucn686W5RV0cpUO8hysi9d8spj9lR9I9
         zS2lvKF22yRepxs4gMCeTCH7QUxmnEdsJr/Fc0AS/1m/itWRLKT2pdyAFK2M3XQhfWPg
         EaVs/cxA6mSj7IHVsZo/GPPdhGzrBsNErono6o75x8meSwO0V8vrktI4OF/Io/r4ddZ5
         JMu+aDN5drlmGIw38OMxdtiyVMwyn5LllREAttKWTPkfJw2ZdhXrzKbRtWq8mcWiujFh
         j2Fg==
X-Gm-Message-State: APjAAAXwCVASA2zfc1WDp5x1nwTvvyP5Ff7bd5nOxX4/dqsggpaKkEKM
	PtWCN5gLkYiq4QdpyQFfUI/dpQ==
X-Google-Smtp-Source: APXvYqy79iv7PnhQlqmrqNVJxtIPIP4rBMv3lsjmDCXDY39LKJHn0NP4iNUzzX1iuf6k+2TtPWhpuQ==
X-Received: by 2002:a17:902:6b45:: with SMTP id g5mr375764plt.159.1574881277136;
        Wed, 27 Nov 2019 11:01:17 -0800 (PST)
Date: Wed, 27 Nov 2019 11:01:15 -0800
From: Kees Cook <keescook@chromium.org>
To: "Shiyunming (Seth, RTOS)" <shiyunming@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lizi (D)" <lizi4@huawei.com>, "Sunke (SK)" <sunke09@huawei.com>,
	Jiangyangyang <jiangyangyang@huawei.com>,
	Linzichang <linzichang@huawei.com>,
	kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: Questions about "security functions" and "suppression of
 compilation alarms".
Message-ID: <201911271013.38BA7015C6@keescook>
References: <18FA40DC4B7A9742B8E58FC4CDA67429AFC83C55@dggeml526-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18FA40DC4B7A9742B8E58FC4CDA67429AFC83C55@dggeml526-mbx.china.huawei.com>

On Wed, Nov 27, 2019 at 01:11:50PM +0000, Shiyunming (Seth, RTOS) wrote:
> During the use of Linux, I found lots of C standard functions such
> as memcpy and strcpy etc. These functions did not check the size of
> the target buffer and easily introduced the security vulnerability of
> buffer overflow.

See CONFIG_FORTIFY_SOURCE (which enables such bounds checking):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/string.h#n262
and the plans for improvement: https://github.com/KSPP/linux/issues/6

> And some compilation options are enabled to suppress compilation alarms,
> for example (Wno-format-security Wno-pointer-sign Wno-frame-address
> Wno-maybe-uninitialized Wno-format-overflow Wno-int-in-bool-context),
> which may bring potential security problems.

Each of these needs to be handled on a case-by-case basis. Kernel builds
are expected to build without warnings, so before a new compiler flag
can be added to the global build, all the instances need to be
addressed. (Flags are regularly turned off because they are enabled by
default in newer compiler versions but this causes too many warnings.)
See the "W=1", "W=2", etc build options for enabling these:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/scripts/Makefile.extrawarn

Once all instances of a warning are eliminated, these warnings can be
moved to the top-level Makefile. Arnd Bergmann does a lot of this work
and might be able to speak more coherently about this. :) For example,
here is enabling of -Wmaybe-uninitialized back in the v4.10 kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4324cb23f4569edcf76e637cdb3c1dfe8e8a85e4

Speaking specifically to your list:

-Wformat-security
  This has tons of false positives, and likely requires fixing the
  compiler.

-Wpointer-sign
  Lots of things in the kernel pass pointers around in weird ways. This
  is disabled to allow normal operation (which, combined with
  -fwrapv-pointer and -fwrapv via -fno-strict-overflow) means signed
  things and pointers behave without "undefined behavior". A lot of work
  would be needed all over the kernel to enable this warning (and part
  of that would be incrementally removing unexpected overflows of both
  unsigned and signed arithmetic).

-Wframe-address
  __builtin_frame_address() gets used in "safe" places on the
  architectures where the limitations are understood, so adding this
  warning doesn't gain anything because it's already rare and gets
  some scrutiny.

-Wmaybe-uninitialized
  And linked above, this is enabled by default since v4.10.

-Wformat-overflow
  See https://git.kernel.org/linus/bd664f6b3e376a8ef4990f87d08271cc2d01ba9a
  for details. Eliminating these warnings (there were 1500) needs to
  happen before they can be turned back on. Any help here is very
  welcome!

-Wint-in-bool-context
  See https://git.kernel.org/linus/a3bc88645e9293f5aaac9c05a185d9f1c0594c6c
  where it was enabled again in v5.2 after Arnd cleaned up the associated
  warnings.

> In response to these circumstances, my question is:
> (1) Does the kernel community think that using these functions and
> compiling alarm suppression have security problems?

Generally speaking, yes, of course, if we have tools that provide the
code base with better security (or more specifically, a reduction in all
bugs, not just those that may have security implications), we want to
use them. However, such things need to have a false positive rate that is
close to zero. If it has a high false positive rate, then there needs to
be a strong indication that the true positives are very serious problems
and some mechanism can be implemented to silence the false positives.

>     If it is considered as a problem, will the developer be promoted
> to fix it?

Warnings seen from newly introduced code get fixed very quickly, yes.
Problems that were already existing and are surfaced by new warnings
tend to get less direct attention by maintainers since it creates a
large amount of work where it is hard to measure the benefit. However,
people contributing changes in these areas tend to be very well received.
For example, Gustavo A. R. Silva did a huge amount of work to enable
-Wimplicit-fallthrough: https://lwn.net/Articles/794944/

>     If it is not considered as a problem, what is the reason?

Hopefully I've explained the nuances in this email. :)

> (2) The C11 specification contains security enhancement functions. What
> is the policy of the community about them? Is there any plan to use
> these functions?

Which do you mean specifically? Generally speaking, the community is
open to anything that can be reasonably maintained. :)

Are there any features you've tried to enable and you'd be interested in
submitting patches to fix?

Thanks for the questions!

-- 
Kees Cook
