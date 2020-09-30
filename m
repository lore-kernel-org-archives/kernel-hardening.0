Return-Path: <SRS0=tQDc=DH=lists.openwall.com=kernel-hardening-return-20063-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AE3C4727C
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 00:13:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F2BBA20739
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 00:13:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2BBA20739
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20063-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1318 invoked by uid 550); 30 Sep 2020 00:13:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1284 invoked from network); 30 Sep 2020 00:13:13 -0000
Date: Tue, 29 Sep 2020 20:12:57 -0400
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
Subject: Re: [PATCH v4 06/29] tracing: move function tracer options to
 Kconfig
Message-ID: <20200929201257.1570aadd@oasis.local.home>
In-Reply-To: <20200929214631.3516445-7-samitolvanen@google.com>
References: <20200929214631.3516445-1-samitolvanen@google.com>
	<20200929214631.3516445-7-samitolvanen@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 29 Sep 2020 14:46:08 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> +++ b/kernel/trace/Kconfig
> @@ -595,6 +595,22 @@ config FTRACE_MCOUNT_RECORD
>  	depends on DYNAMIC_FTRACE
>  	depends on HAVE_FTRACE_MCOUNT_RECORD
>  
> +config FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
> +	bool
> +	depends on FTRACE_MCOUNT_RECORD
> +
> +config FTRACE_MCOUNT_USE_CC
> +	def_bool y
> +	depends on $(cc-option,-mrecord-mcount)

Does the above get executed at every build? Or does a make *config need
to be done? If someone were to pass a .config to someone else that had
a compiler that didn't support this, would it be changed if the person
just did a make?

-- Steve


> +	depends on !FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
> +	depends on FTRACE_MCOUNT_RECORD
> +
> +config FTRACE_MCOUNT_USE_RECORDMCOUNT
> +	def_bool y
> +	depends on !FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
> +	depends on !FTRACE_MCOUNT_USE_CC
> +	depends on FTRACE_MCOUNT_RECORD
> +
>  config TRACING_MAP
>  	bool
>  	depends on ARCH_HAVE_NMI_SAFE_CMPXCHG
