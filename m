Return-Path: <SRS0=g9ls=AF=lists.openwall.com=kernel-hardening-return-19142-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33DDC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:30:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4238C2081A
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UTpKVD20"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4238C2081A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19142-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32108 invoked by uid 550); 24 Jun 2020 21:30:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32073 invoked from network); 24 Jun 2020 21:30:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BLAueZueQmLo+U3ff1yWRTxI4RTBZr5ie/D1r3LUxVk=;
        b=UTpKVD20ozvTdWMRMhXjRuDa7E6nhyfuuFzbPsLPOJkgDHZzpnipT7xh2/Wno0v2Oq
         jdpABPkcKmrg491zzfi9zOks98eQJaOLDTz406Z4w2MgG351GRHcHMzGWpNAyEJdLecz
         ji/dnLP69LQeXVwamBUI0SmjGSavdPaLzdKRaDqcWl5xT7zXOVfMtWSCERwyPWhmuC8a
         4KDq5FM9YdU0RrraXVR/hGh5TC7cw1r0O3lilGh9m2vHjgmv1WKElLUiabdJW2m76HZC
         7iRUNTtGTKyZS7schzBZuKhvkys5qQmNg4oE6XUh6jUFgmi+eFh4EE769mR4zWRz8YdS
         PQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BLAueZueQmLo+U3ff1yWRTxI4RTBZr5ie/D1r3LUxVk=;
        b=mzyIDdB+rWs2TGnVnG6K9dw9HZ7iG/zzBYKWD2XyjHfzZwljSPKvW28TOz0eTxn9/v
         hft5JvsI6W+Fb2BU/qaR7PIX6ZNibzpzm/eBhFQOzGp4aLTOrFbwu8QWg9DLNnUIBgOi
         xZ7BC/aLbNLdp8GwfgoHP0zn+xKGAoFgENfD9uJNEwBOc4PVU/e6+KK5N/Wc2lH7ugKf
         3VUXhD7SnYQS4qPsLuZJoUFPmTWpFnyN6V+UudpHCJL+lL+FlyJECsmeBJZaSOKXTC0U
         Efjm9dKYRlptYdkuvxAb0GXi+2x9+gnWW9ea28AvwjvOUe8Bxw/86sIk+ULcyFoY++es
         L5Qw==
X-Gm-Message-State: AOAM530vIE93IrqhHSViIbpd2IP5zQj/6X51HL4RHJrh9fUSnD/oeQz4
	ZMYAvs0LtxXd/W5mW5NBQO5h+A==
X-Google-Smtp-Source: ABdhPJxhxSeUIX3+whzU3DS6SVAWzNuff6r9HMO0IkuALFVi/g2AiuvayCKmK1FcYKc9xkjwmkX3MQ==
X-Received: by 2002:a65:6393:: with SMTP id h19mr6687231pgv.278.1593034221896;
        Wed, 24 Jun 2020 14:30:21 -0700 (PDT)
Date: Wed, 24 Jun 2020 14:30:14 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200624213014.GB26253@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624211540.GS4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624211540.GS4817@hirez.programming.kicks-ass.net>

On Wed, Jun 24, 2020 at 11:15:40PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 24, 2020 at 01:31:38PM -0700, Sami Tolvanen wrote:
> > This patch series adds support for building x86_64 and arm64 kernels
> > with Clang's Link Time Optimization (LTO).
> > 
> > In addition to performance, the primary motivation for LTO is to allow
> > Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
> > Pixel devices have shipped with LTO+CFI kernels since 2018.
> > 
> > Most of the patches are build system changes for handling LLVM bitcode,
> > which Clang produces with LTO instead of ELF object files, postponing
> > ELF processing until a later stage, and ensuring initcall ordering.
> > 
> > Note that first objtool patch in the series is already in linux-next,
> > but as it's needed with LTO, I'm including it also here to make testing
> > easier.
> 
> I'm very sad that yet again, memory ordering isn't addressed. LTO vastly
> increases the range of the optimizer to wreck things.

I believe Will has some thoughts about this, and patches, but I'll let
him talk about it.

Sami
