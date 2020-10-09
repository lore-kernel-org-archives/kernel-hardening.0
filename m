Return-Path: <SRS0=fMaS=DQ=lists.openwall.com=kernel-hardening-return-20165-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B5DC433E7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 23:39:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 48F4022245
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 23:39:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48F4022245
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20165-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5447 invoked by uid 550); 9 Oct 2020 23:38:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5413 invoked from network); 9 Oct 2020 23:38:58 -0000
Date: Fri, 9 Oct 2020 19:38:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, Kees
 Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 00/29] Add support for Clang LTO
Message-ID: <20201009193759.13043836@oasis.local.home>
In-Reply-To: <20201009210548.GB1448445@google.com>
References: <20201009161338.657380-1-samitolvanen@google.com>
	<20201009153512.1546446a@gandalf.local.home>
	<20201009210548.GB1448445@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Oct 2020 14:05:48 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> Ah yes, X86_DECODER_SELFTEST seems to be broken in tip/master. If you
> prefer, I have these patches on top of mainline here:
> 
>   https://github.com/samitolvanen/linux/tree/clang-lto
> 
> Testing your config with LTO on this tree, it does build and boot for
> me, although I saw a couple of new objtool warnings, and with LLVM=1,
> one warning from llvm-objdump.

Thanks, I disabled X86_DECODER_SELFTEST and it now builds.

I forced the objdump mcount logic with the below patch, which produces:

CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_OBJTOOL=y

But I don't see the __mcount_loc sections being created.

I applied patches 1 - 6.

-- Steve

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 89263210ab26..3042619e21b7 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -606,7 +606,7 @@ config FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
 
 config FTRACE_MCOUNT_USE_CC
 	def_bool y
-	depends on $(cc-option,-mrecord-mcount)
+	depends on $(cc-option,-mrecord-mcount1)
 	depends on !FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
 	depends on FTRACE_MCOUNT_RECORD
 
