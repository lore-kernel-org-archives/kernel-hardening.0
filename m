Return-Path: <SRS0=QwvU=HI=lists.openwall.com=kernel-hardening-return-20747-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E3CC433E0
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Feb 2021 11:54:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D050E64EBE
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Feb 2021 11:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D050E64EBE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20747-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4091 invoked by uid 550); 6 Feb 2021 11:54:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16234 invoked from network); 6 Feb 2021 10:45:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v7g6iYD4a+ldej/OxPdZv/D/jsDtfKWVskL7H6xJ7L8=;
        b=ZM+MIrBaMZDpFDE0Gjxs0SIg1PXAeHyZjLbzSwXSG9nqRU9vcb9EfYU8pMtWjDlylO
         BFck0Ub8PbEilo4FvdeWi//vADcwcGeUyDUsyiHKH8Fz9486bnSoKqVLpTLzTaScSV4D
         MC8RpDFFP0yb2FcPjBBJ4gJhkh9HVUGt/TO2P/p3aoTgBvT7v6GfmX8sL1uapVN/9FOl
         OuOCPmqEeMccarFnuMok5e6Ry4sorp+Nk2HTKEagJ8Dq/iGlNr2h6qlDXdY+sIfHAj2A
         Zv6TNEPg4lLu3lj0+uN81u903gZE7pebPqx7krtxLh4doVprIsARF+z6Uqvxr/F4+SrM
         dqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v7g6iYD4a+ldej/OxPdZv/D/jsDtfKWVskL7H6xJ7L8=;
        b=N5FfMXl5w0wyIsnjKwMTt9W7FgyMkKC/WI1/AgI2xnS99U89XTMF09U1lu/b/g8MBe
         +5lEKXJ6pANvEFhy5bP4X1RASv7sm5rSPUB98Tw1aTN7ni4AdgC6inwHKUqWB969AuJc
         p+UNFh9+ib7Gb8OYF/OLUuixZYiC779GdfwPvSpaTPnUXSNumrqLFRjMtgoK/kupW0gH
         dLMtU5YLZmEWLnE0brGcEHwwXS+c3WlmDN32jgxowCT2Om9ccLS7UJlNzPuRPuW9wclK
         zCqPwVSAkkx6LXjlR2whaOn3xG4ECFd13V25cjh8AbA5zvc0MSiuncobo4az7JxelyXQ
         Ss+A==
X-Gm-Message-State: AOAM533ZGVGWfT2EwwppChHECFNvO129LJ/3l6WV1JDnZwbmpll0wI/f
	ZT9evVDZAhceGS1tDgJbjHqreQ==
X-Google-Smtp-Source: ABdhPJykQdePL2I4KeC4QoO1pgMj2lxWrgcUC7yiajkjRBul0O9o6VUQ0GgumH4TVAz6NtbK4IDXBQ==
X-Received: by 2002:a62:ee09:0:b029:1c0:ba8c:fcea with SMTP id e9-20020a62ee090000b02901c0ba8cfceamr8751330pfi.7.1612608322484;
        Sat, 06 Feb 2021 02:45:22 -0800 (PST)
Date: Sat, 6 Feb 2021 18:45:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] arm64/acpi: disallow writeable AML opregion
 mapping for EFI code regions
Message-ID: <20210206104514.GB27503@dragon>
References: <20200626155832.2323789-1-ardb@kernel.org>
 <20200626155832.2323789-3-ardb@kernel.org>
 <20210206031145.GA27503@dragon>
 <CAMj1kXHSkBcSDuHbsFMJjC89JrO8TxYUoabDmWerNp27s45Ngw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHSkBcSDuHbsFMJjC89JrO8TxYUoabDmWerNp27s45Ngw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Sat, Feb 06, 2021 at 09:10:19AM +0100, Ard Biesheuvel wrote:
> On Sat, 6 Feb 2021 at 04:11, Shawn Guo <shawn.guo@linaro.org> wrote:
> >
> > Hi Ard,
> >
> > On Fri, Jun 26, 2020 at 05:58:32PM +0200, Ard Biesheuvel wrote:
> > > Given that the contents of EFI runtime code and data regions are
> > > provided by the firmware, as well as the DSDT, it is not unimaginable
> > > that AML code exists today that accesses EFI runtime code regions using
> > > a SystemMemory OpRegion. There is nothing fundamentally wrong with that,
> > > but since we take great care to ensure that executable code is never
> > > mapped writeable and executable at the same time, we should not permit
> > > AML to create writable mapping.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > I'm booting Lenovo Flex 5G laptop with ACPI, and seeing this change
> > causes a memory abort[1] when upgrading ACPI tables via initrd[2].
> > Dropping this change seems to fix the issue for me.  But does that
> > looks like a correct fix to you?
> >
> > Shawn
> >
> > [1] https://fileserver.linaro.org/s/iDe9SaZeNNkyNxG
> > [2] Documentation/admin-guide/acpi/initrd_table_override.rst
> >
> 
> Can you check whether reverting
> 
> 32cf1a12cad43358e47dac8014379c2f33dfbed4
> 
> fixes the issue too?

Yes, it does.

> If it does, please report this as a regression. The OS should not
> modify firmware provided tables in-place, regardless of how they were
> delivered.
> 
> BTW I recently started using my Yoga C630 with Debian, and I am quite
> happy with it! Thanks a lot for spending the time on the installer
> etc.

Cool, glad to hear that!

Shawn
