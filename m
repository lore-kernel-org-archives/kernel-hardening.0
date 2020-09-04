Return-Path: <SRS0=EAZm=CN=lists.openwall.com=kernel-hardening-return-19781-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96684C43461
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 07:14:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E1B4A20722
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 07:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pVN64zaL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1B4A20722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19781-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2029 invoked by uid 550); 4 Sep 2020 07:14:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1997 invoked from network); 4 Sep 2020 07:14:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GSiu7q5INNKgwni6kCKdhOc96uZE70+2Wp8nmvDrTrM=;
        b=pVN64zaLQdVkm9y++BHIgl9U2HYy1ga2ItqCVhDAXoHtDKlW3qke2dVxHARuY9RHA4
         JUXg1v+XjSIPkvHaPAES954FDBnkDthsJ07QWrZWlLC1Yxvts+zg+VSZ71Jr7bMf4H18
         u+0x8AbJlY06zTXVdXCVAaZkz0P58VhuZ3vIqnnqn+1RHth8aDaaHihuQTu2cTuGP5+3
         QKjsFfOhUxNBDB2GrG5Sk14VIWkDiRKKFbRsv4Q0YKTpBWjSdZYERZUvbfkCq0u2TeU0
         bLUvSo40kyTW0CnRezsekbOBqmkwZv+n8+E0AQy8h84U4iMnz0lUwHSZcy5P0MrB+ESd
         R2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GSiu7q5INNKgwni6kCKdhOc96uZE70+2Wp8nmvDrTrM=;
        b=dIJzDIyxci00/gJhX1VPlgEQxahoQg7JArrNJawC4SBjRjyWz456Bl6uoHIG2WTMnr
         vXnKLVa49i4j0kb8Kys4PhiIug9ByZK33BrcyJ04DWsiY6+oF1M5H9fA7CyrsZjn3rSB
         xnN+p3eDTieBi5EHiMvmf1Ni8ZEqn92YdEaQNp9sIvyvq4HTSH9tn/1cwKhiAE3NUIqw
         S6/ByEe5wdycicKqfLZxmGhkvaT7gXNNWjGEqs0XS1LlWOLtJG7q1BGCYqTD/f3t+E8K
         pldugiDmr740VHRM4QC31rFdwUXDvtV7AHWpfEErf27KGA+TcEcs2qpsNdRHvhTIecAL
         ZwHg==
X-Gm-Message-State: AOAM53198pTEaHe8eAc/96/ZlaRFqvHUGdvBfwciTBCJJSfHvts6GZPV
	x5+BogTd8m4Hyqj4RN19hSY=
X-Google-Smtp-Source: ABdhPJyxhXjoiuUHJ8yHqedEnX8rmWvhjD+7ADa6DmR56ksBmgeSMROQzmrkQSZxIIn6pfwVxB0aYA==
X-Received: by 2002:aed:2c63:: with SMTP id f90mr7360733qtd.262.1599203653880;
        Fri, 04 Sep 2020 00:14:13 -0700 (PDT)
Date: Fri, 4 Sep 2020 00:14:11 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 01/28] x86/boot/compressed: Disable relocation
 relaxation
Message-ID: <20200904071411.GA1712031@ubuntu-n2-xlarge-x86>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-2-samitolvanen@google.com>
 <202009031444.F2ECA89E@keescook>
 <20200903234215.GA106172@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903234215.GA106172@rani.riverdale.lan>

On Thu, Sep 03, 2020 at 07:42:15PM -0400, Arvind Sankar wrote:
> On Thu, Sep 03, 2020 at 02:44:41PM -0700, Kees Cook wrote:
> > On Thu, Sep 03, 2020 at 01:30:26PM -0700, Sami Tolvanen wrote:
> > > From: Arvind Sankar <nivedita@alum.mit.edu>
> > > 
> > > Patch series [4] is a solution to allow the compressed kernel to be
> > > linked with -pie unconditionally, but even if merged is unlikely to be
> > > backported. As a simple solution that can be applied to stable as well,
> > > prevent the assembler from generating the relaxed relocation types using
> > > the -mrelax-relocations=no option. For ease of backporting, do this
> > > unconditionally.
> > > 
> > > [0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
> > > [1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
> > > [2] https://github.com/ClangBuiltLinux/linux/issues/1121
> > > [3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
> > > [4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/
> > > 
> > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > 
> > -- 
> > Kees Cook
> 
> Note that since [4] is now in tip, assuming it doesn't get dropped for
> some reason, this patch isn't necessary unless you need to backport this
> LTO series to 5.9 or below.
> 
> Thanks.

It is still necessary for tip of tree LLVM to work properly
(specifically clang and ld.lld) regardless of whether or not LTO is
used.

[4] also fixes it but I don't think it can be backported to stable so it
would still be nice to get it picked up so that it can be sent back
there. We have been carrying it in our CI for a decent amount of time...

Cheers,
Nathan
