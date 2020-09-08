Return-Path: <SRS0=YlhT=CR=lists.openwall.com=kernel-hardening-return-19829-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C124C433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 23:29:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F36A2080C
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 23:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E/YiH9PD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F36A2080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19829-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3124 invoked by uid 550); 8 Sep 2020 23:28:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3092 invoked from network); 8 Sep 2020 23:28:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jUriBxBgOoiBsn5aO7jNWcqqf+vaiVxUYWRnLqNR1jM=;
        b=E/YiH9PD3ihV0IVAR5rz+kH+b53wXLSIKmpoiOzCUGIjKpPkUvepTJzZ9+NUfPet6f
         GjaxzmgrBjNjqjo0f2ixc8d1ESWRgiXmk3RC5UCTuoEZePHlVeleHkJJVCXbHB4Iy0lP
         zLqt5AipHKpsckEr1GfvlWy6tszT/wsVnsbnykJcDboXcXvM/ADW0EnFJR3kQ6JqRDJF
         dSHe06Qm/HcGK8ogoctsoW5WtSXiP+swQULLf66N1XBjDhEHsTBRP9zhxOTsHLpYe4Th
         9lAz0y/0D5FyUST+gVXhf1nWDMBty0024ty3DlA3ziBDE0uWDvAZu1LLk2dJzbpawFdm
         KS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jUriBxBgOoiBsn5aO7jNWcqqf+vaiVxUYWRnLqNR1jM=;
        b=kAgI6u1wP6Kz03BwYZnSC/N9RBiZ+0tjZPmLoBr6XoMWN1W7LGz1dfccUIku7+7Lip
         SVN+NPa97UIPyL3HQuqpUVytVhG5zN8opEJQDCS2PHiBVPxU4/7YPEQlAvB3/GZNKwHB
         422vmfic4SA4wW+2Ij/bH3Hq06oM3nsAKLbSQSAVPBe2kNJV8QxCq+QNnRBoIG/gFIvr
         h1s4nDcSj6ERdNEBEvnyeaZKrZ6n6KTKZA1kdBmY9HKFPARoLQFWpM2OXfpvpzM5tOiD
         PmfaDOL+Ix3TmqypqJ8qXxlIpLdxgArZs5GS+W36G4Ipa+Qhu+NaSQmJPvRBmT+bi/vM
         tGBg==
X-Gm-Message-State: AOAM5329/dOd1ebXTfDCtq5DiFqGRPrpIupx5pc7hCe1erz89jTsJyz5
	UphKhTSG5PsLK8yV05VxSyq08A==
X-Google-Smtp-Source: ABdhPJxtrczatAsJe/2asERi0zZusFb9ssrn7lKjqOGwCxb8YO5oCcKiBSLXYms184w0IymH7gdSoA==
X-Received: by 2002:a17:902:b108:b029:d0:cbe1:e770 with SMTP id q8-20020a170902b108b02900d0cbe1e770mr1342847plr.23.1599607722874;
        Tue, 08 Sep 2020 16:28:42 -0700 (PDT)
Date: Tue, 8 Sep 2020 16:28:35 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v2 27/28] x86, relocs: Ignore L4_PAGE_OFFSET relocations
Message-ID: <20200908232835.GE1060586@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-28-samitolvanen@google.com>
 <202009031546.4854633F7@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009031546.4854633F7@keescook>

On Thu, Sep 03, 2020 at 03:47:32PM -0700, Kees Cook wrote:
> On Thu, Sep 03, 2020 at 01:30:52PM -0700, Sami Tolvanen wrote:
> > L4_PAGE_OFFSET is a constant value, so don't warn about absolute
> > relocations.
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> 
> Any other details on this? I assume this is an ld.lld-ism. Any idea why
> this is only a problem under LTO? (Or is this an LLVM integrated
> assembler-ism?) Regardless, yes, let's nail it down:

With the LTO v1 series, LLD generated this relocation somewhere in the
.init.data section, but only with LTO:

  $ arch/x86/tools/relocs --abs-relocs vmlinux
  WARNING: Absolute relocations present
  Offset     Info     Type     Sym.Value Sym.Name
  ffffffff828e7fe0 0000000100000001 R_X86_64_64 0000000000000111
  L4_PAGE_OFFSET

It actually looks like this might not be a problem anymore with the
current ToT kernel and the v2 series, but I'll do some more testing to
confirm this and drop the patch from v3 if it's no longer needed.

Sami
