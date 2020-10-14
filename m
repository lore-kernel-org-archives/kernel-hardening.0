Return-Path: <SRS0=jB4M=DV=lists.openwall.com=kernel-hardening-return-20200-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E14C433E7
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 16:50:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AC341214D8
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 16:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q+bPhxgY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC341214D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20200-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12187 invoked by uid 550); 14 Oct 2020 16:50:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12167 invoked from network); 14 Oct 2020 16:50:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+kKooy8y3/ieceX7ZqDJ+1+nZaa9FZpK4qlfOAJ4xg4=;
        b=q+bPhxgYA+ZTPkLdf43AbfDU/NVUXp5l+vHvOvwwCnu8EDI0ZTBBe5x7CS7iqFgW6U
         RPKNLv5TazIRXEB8zpXJfYYNIb0vbS++16n0Vl70eRtBPcT0r/UwvHw/ZjW87DDaUfSx
         +Xd0/NTf1ApzUVFxGl+8MloHTritdnRiWIjqML6JVm6nZY9VgaoijQM+t1N7K/GhHURP
         NkTvh6uJwsD2wsYWhoNFsSwxTukwKXmEPyAzgpia3QQ/t+EzYmGkVMjooaxT9iBZyUhX
         VeofVZViwdeEOym4e9lpV9fWnoiFgWXqxdPZT/fx4VJS8nzxptdXq5xzDzIorjQDqzDq
         iifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+kKooy8y3/ieceX7ZqDJ+1+nZaa9FZpK4qlfOAJ4xg4=;
        b=iiBVctanoj+8pSkKfG2Qb3nMFNDNjKjxKsRYUAlHKbzW95nAgyIAdAGN8XB5bFC9zc
         JtR++WB0vaYYGlhVDJppnNSIEDAxEfWOz7PU1wbJc5Bte/LCr7WkE32fiMfhncPY7Z+I
         PpSePrZlel0KBav8diQojPcWetQPdOCCQJdAEO1Tl+z6OQm6Fm2HGVWdoAz/f73a9eb1
         b30Fy/fTJ0AYhuPdKHilLb46LLQpkqMj5AvMSn51/k+GbFQshCc4iRsAF/TJ8occHRbA
         eLU1Tq/78N+jl5OhVAyii5M1hpDT6GvVSZfA4cLrSqC/tgX6lo5207NFDVDJv0ykS22B
         miaQ==
X-Gm-Message-State: AOAM5323vBCzi4OvgfWVG91H/emUdNpewrgRIBbhBDtJ7nKRaHiBzptq
	oEnn+XBJmb73tLMY+AndRnA=
X-Google-Smtp-Source: ABdhPJxnZz/JvSQgt+bP4GraqaDvLe+xrlEutFj8lORQJcvNdI3kXKHdjhRXRnIr61+pk7L2rCm3hg==
X-Received: by 2002:a17:907:43ed:: with SMTP id ol21mr6121680ejb.279.1602694207048;
        Wed, 14 Oct 2020 09:50:07 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 14 Oct 2020 18:50:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v6 02/25] objtool: Add a pass for generating __mcount_loc
Message-ID: <20201014165004.GA3593121@gmail.com>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-3-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013003203.4168817-3-samitolvanen@google.com>


* Sami Tolvanen <samitolvanen@google.com> wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> Add the --mcount option for generating __mcount_loc sections
> needed for dynamic ftrace. Using this pass requires the kernel to
> be compiled with -mfentry and CC_USING_NOP_MCOUNT to be defined
> in Makefile.
> 
> Link: https://lore.kernel.org/lkml/20200625200235.GQ4781@hirez.programming.kicks-ass.net/
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> [Sami: rebased, dropped config changes, fixed to actually use --mcount,
>        and wrote a commit message.]
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  tools/objtool/builtin-check.c |  3 +-
>  tools/objtool/builtin.h       |  2 +-
>  tools/objtool/check.c         | 82 +++++++++++++++++++++++++++++++++++
>  tools/objtool/check.h         |  1 +
>  tools/objtool/objtool.c       |  1 +
>  tools/objtool/objtool.h       |  1 +
>  6 files changed, 88 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
> index c6d199bfd0ae..e92e76f69176 100644
> --- a/tools/objtool/builtin-check.c
> +++ b/tools/objtool/builtin-check.c
> @@ -18,7 +18,7 @@
>  #include "builtin.h"
>  #include "objtool.h"
>  
> -bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux;
> +bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount;
>  
>  static const char * const check_usage[] = {
>  	"objtool check [<options>] file.o",
> @@ -35,6 +35,7 @@ const struct option check_options[] = {
>  	OPT_BOOLEAN('s', "stats", &stats, "print statistics"),
>  	OPT_BOOLEAN('d', "duplicate", &validate_dup, "duplicate validation for vmlinux.o"),
>  	OPT_BOOLEAN('l', "vmlinux", &vmlinux, "vmlinux.o validation"),
> +	OPT_BOOLEAN('M', "mcount", &mcount, "generate __mcount_loc"),
>  	OPT_END(),
>  };

Meh, adding --mcount as an option to 'objtool check' was a valid hack for a 
prototype patchset, but please turn this into a proper subcommand, just 
like 'objtool orc' is.

'objtool check' should ... keep checking. :-)

Thanks,

	Ingo
