Return-Path: <SRS0=PO+V=DQ=lists.openwall.com=kernel-hardening-return-20164-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD881C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 21:06:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A4E8A222C3
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 21:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JoSdKxNw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4E8A222C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20164-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8098 invoked by uid 550); 9 Oct 2020 21:06:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8066 invoked from network); 9 Oct 2020 21:06:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QXQaBaNS7A6eVo/ydORo8r5bdU1C9Le836RTdHwCBbM=;
        b=JoSdKxNwxsMfI2U0CjlTc5BwvhqCy714WkSi+WKKGJVkSxeS4A84NzKevK6CPn9KXt
         luyi7jDs6nQbVyyVPeYM9mQUjAAefT+ScUKjFnKzQLP7hS1caTnxv6LwwjUOs1sG613o
         Z1mfBp8CiisbR4rWjXF/lItpg0T+9m58kSN6ymcBrb9qx1Q5pE6/8rfEwDSOFoHPmLeK
         ZOhU9su8JfRbkCsj5wTlpzUcuguhQKLNKVmqQEdIiT1RZKGFUwDcT20B3P+mB4B8pmtl
         zOKoiM+eB3smbcYTz3v4uqlSVWDNijwAFgnLDRm8ha9grVnXIpZsyUDrdJ34aNugK5Zh
         t79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QXQaBaNS7A6eVo/ydORo8r5bdU1C9Le836RTdHwCBbM=;
        b=pfTpblH1kKsy7S6Zop1DBQIH5Oy+2pDDmammB4CZ0WHEXLoW8GBqwWVrIfTs7VuUqo
         R8E08M7WjnegtPEgIqOxJvlY254L5pRzPMSdKmVqAZ3oLGrZQLtNSVdpcJHt8QdQne7a
         Ek+CfnfRHYrmulf/kuXzJxXS/mvNkDs57HBxOcEqTa4D+D67LFdMgpYNSdbN4vdpkDut
         gR0tbJdflYQzNdKRhO4xG8EwtzdSxVHXaWhF2RGfwlW/fIlmH0CxiEeLu4PyiM08rBve
         e9/G/9htiGAj0/YlQlL3zUwL2qsqTvB1AvFm2SP1E7OU+A9F0rL1HfTP3G0/g7MLN2b3
         klRA==
X-Gm-Message-State: AOAM533/S+TTFewvZ/X9m9SnNTSxeXDczm3MAcYlmzwpn15YCi2ILUod
	JBGzOHUvWReuAKiPxFx0L54qQA==
X-Google-Smtp-Source: ABdhPJxjzJ92vFbxcRcoQJ+j6aZ4ui51r5YFp2dBuqEKUdI8vRCJOM24sn81H3xCAiwt33ZPrcU5Mg==
X-Received: by 2002:a65:64cc:: with SMTP id t12mr5047545pgv.106.1602277555126;
        Fri, 09 Oct 2020 14:05:55 -0700 (PDT)
Date: Fri, 9 Oct 2020 14:05:48 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v5 00/29] Add support for Clang LTO
Message-ID: <20201009210548.GB1448445@google.com>
References: <20201009161338.657380-1-samitolvanen@google.com>
 <20201009153512.1546446a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009153512.1546446a@gandalf.local.home>

On Fri, Oct 09, 2020 at 03:35:12PM -0400, Steven Rostedt wrote:
> On Fri,  9 Oct 2020 09:13:09 -0700
> Sami Tolvanen <samitolvanen@google.com> wrote:
> 
> > This patch series adds support for building x86_64 and arm64 kernels
> > with Clang's Link Time Optimization (LTO).
> > 
> > In addition to performance, the primary motivation for LTO is
> > to allow Clang's Control-Flow Integrity (CFI) to be used in the
> > kernel. Google has shipped millions of Pixel devices running three
> > major kernel versions with LTO+CFI since 2018.
> > 
> > Most of the patches are build system changes for handling LLVM
> > bitcode, which Clang produces with LTO instead of ELF object files,
> > postponing ELF processing until a later stage, and ensuring initcall
> > ordering.
> > 
> > Note that this version is based on tip/master to reduce the number
> > of prerequisite patches, and to make it easier to manage changes to
> > objtool. Patch 1 is from Masahiro's kbuild tree, and while it's not
> > directly related to LTO, it makes the module linker script changes
> > cleaner.
> > 
> 
> I went to test this, but it appears that the latest tip/master fails to
> build for me. This error is on tip/master, before I even applied a single
> patch.
> 
> (config attached)

Ah yes, X86_DECODER_SELFTEST seems to be broken in tip/master. If you
prefer, I have these patches on top of mainline here:

  https://github.com/samitolvanen/linux/tree/clang-lto

Testing your config with LTO on this tree, it does build and boot for
me, although I saw a couple of new objtool warnings, and with LLVM=1,
one warning from llvm-objdump.

Sami
