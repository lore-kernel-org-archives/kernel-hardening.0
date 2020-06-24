Return-Path: <SRS0=TlgU=AF=lists.openwall.com=kernel-hardening-return-19143-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A86C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:31:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 30B3B207FC
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="km0rbdas"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30B3B207FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19143-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1222 invoked by uid 550); 24 Jun 2020 21:31:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1190 invoked from network); 24 Jun 2020 21:31:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/O3ShsYHI31KeAbcJImqBKhK7RmR1YrkXinaLdbS2cc=;
        b=km0rbdasUCx++8x0lRTpl9dRVPlkvvgXmXH5VDqn1z/oWbZzfjocNBIe3ZynP1hSKb
         KVFJqPSTAVKH6Bv/v1uTTgpFU33rli2X3C/m74frA2+rWkygENBnngQ6aWJvCvtTwisK
         ZbNyudsS3PRLC9fuaxb8wpD7eLdi56OzlUX+Ro85RkehRMCJuUd9kGrUaJVjx1Rm6zjq
         OX9MIPdaaEsCkipcX4Eh8R80M8kBtbcIH8WUg2cLSf9HDDLe4n46v5madSBqNDFMNyys
         VlZ3/ZtSFkzDrwh90gPCorp7EeMVtZmCvszFtKxrIAgZiR2lx7HkBAL7Cd84LfmKQ6Hq
         Sr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/O3ShsYHI31KeAbcJImqBKhK7RmR1YrkXinaLdbS2cc=;
        b=gTmT9raNkGAdPZAzYD3s/te4O3VEd78zcngCpc7qSOmMdzL4UK2MqZJKmuY6Uo9/B9
         P3un4Pf2nn43KYIB+B8TMzOa1tWaeF7oE6Fu5xqboIrAF13/bOYVBhcYrYoBIqn1OHaE
         L5ThhUzVzTEdhRRMaaJygCqEX8MS47zic7lWIDnrmlYBZzRXTgq3NiVXkidW6tz1oy1W
         S7eEcr42lla6Ayq+nsoYGgPFwIWroipEQ6J75lJWrcBbwt6GKRa/Laz/CsqKFe5UaExq
         FGiGEZhFsF3TJzA/wdkDlK/AgwLp/mxNFU8yS1+6Xv14p+bQJIM4CC3SM5ZtUD55HT+v
         hH8w==
X-Gm-Message-State: AOAM533RwimAXBIy6nf3uUoZFnY+0rG+N98AdKgFBoRj07zRPohLnfmw
	jnwwTU6zfeNdMSZNBqJIHmdDfg==
X-Google-Smtp-Source: ABdhPJzL1k5l4bBaYzFfIDW/jK3TA6LlmzQ3rQievoHb7W2HsUj9qo9LTDOdsz8oDhdojeg/j6HFOw==
X-Received: by 2002:a17:90a:4ecb:: with SMTP id v11mr29922206pjl.75.1593034294906;
        Wed, 24 Jun 2020 14:31:34 -0700 (PDT)
Date: Wed, 24 Jun 2020 14:31:29 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 07/22] kbuild: lto: merge module sections
Message-ID: <20200624213129.GC26253@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-8-samitolvanen@google.com>
 <CAKwvOdkY2M9+BgA5FELK+7bjv1sZYMuTmVOztCYijas_OHfVDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkY2M9+BgA5FELK+7bjv1sZYMuTmVOztCYijas_OHfVDQ@mail.gmail.com>

On Wed, Jun 24, 2020 at 02:01:59PM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > LLD always splits sections with LTO, which increases module sizes. This
> > change adds a linker script that merges the split sections in the final
> > module and discards the .eh_frame section that LLD may generate.
> 
> For discarding .eh_frame, Kees is currently fighting with a series
> that I would really like to see land that enables warnings on orphan
> section placement.  I don't see any new flags to inhibit .eh_frame
> generation, or discard it in the linker script, so I'd expect it to be
> treated as an orphan section and kept.  Was that missed, or should
> that be removed from the commit message?

It should be removed from the commit message, thanks for pointing it
out.

Sami
