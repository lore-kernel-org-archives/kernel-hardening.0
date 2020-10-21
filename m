Return-Path: <SRS0=kR2e=D4=lists.openwall.com=kernel-hardening-return-20239-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB6DC56202
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:08:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CF6D821D7B
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rtIa9spk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF6D821D7B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20239-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3583 invoked by uid 550); 21 Oct 2020 09:08:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3558 invoked from network); 21 Oct 2020 09:08:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eb1OL+P4JmUK1jhG+vTVWpbKbq0qkyHl8thry52FTQA=; b=rtIa9spk+eGaALa7gNwT0CJsKK
	NjlQ0TaZClui6FNLaSH6sH410ckUEAUgWngz6KlxlBPFXfRsleXkZnz6ehdTlmAjGEDZ54LCQKjzW
	mVkO6Qrz9t1ONh71M5vaOQ5etGEYUyqKkVWOoiOoxp1OWMTTQymeYA9Bq+58R1K92TY9eQDNJBhMo
	j3j5B91C/arUdOUsfw/WJeofsIebuUbqnXHmWhjxv5BqEQh/x/dq8CROgLXRvJ7hEs8U3WUEjTr3U
	sxRZjkXGtDIhLFLuspHPnxp/ilX5Zbg6Dkuh7PJ6uq/ocHYjHiAPX19862wtZObxjvIsngNw8WzZa
	ycCtxeZA==;
Date: Wed, 21 Oct 2020 11:08:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201021090817.GU2651@hirez.programming.kicks-ass.net>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
 <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021085606.GZ2628@hirez.programming.kicks-ass.net>

On Wed, Oct 21, 2020 at 10:56:06AM +0200, Peter Zijlstra wrote:

> The "falls through to next function" seems to be limited to things like:
> 
>   warning: objtool: setup_vq() falls through to next function setup_vq.cold()
>   warning: objtool: e1000_xmit_frame() falls through to next function e1000_xmit_frame.cold()
> 
> So something's weird with the .cold thing on vmlinux.o runs.

Shiny, check this:

$ nm defconfig-build/vmlinux.o | grep setup_vq
00000000004d33a0 t setup_vq
00000000004d4c20 t setup_vq
000000000001edcc t setup_vq.cold
000000000001ee31 t setup_vq.cold
00000000004d3dc0 t vp_setup_vq

$ nm defconfig-build/vmlinux.o | grep e1000_xmit_frame
0000000000741490 t e1000_xmit_frame
0000000000763620 t e1000_xmit_frame
000000000002f579 t e1000_xmit_frame.cold
0000000000032b6e t e1000_xmit_frame.cold

$ nm defconfig-build/vmlinux.o | grep e1000_diag_test
000000000074c220 t e1000_diag_test
000000000075eb70 t e1000_diag_test
000000000002fc2a t e1000_diag_test.cold
0000000000030880 t e1000_diag_test.cold

I guess objtool goes sideways when there's multiple symbols with the
same name in a single object file. This obvously never happens on single
TU .o files.

Not sure what to do about that.
