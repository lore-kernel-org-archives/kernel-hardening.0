Return-Path: <SRS0=lxHZ=DA=lists.openwall.com=kernel-hardening-return-19988-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC1AC2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 18:49:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AB575206DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 18:49:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6zFoRR/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB575206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19988-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24331 invoked by uid 550); 23 Sep 2020 18:49:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24282 invoked from network); 23 Sep 2020 18:49:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RkpPiL5sLMoQ72Z4SVPCyIzaZVEUsKD6IONs26Z9oQ4=;
        b=j6zFoRR/TNHPnYOJYg/v6yC5mOjqz6GhBvNdUdw/ZZY3Z659h4thQrXUvmYYNs/dMc
         9AtbSQc1r9/KTQ+OdnHEMcrYOKmjexHp+zLAowzXW60xVUgp32upPori8ocBAUEa2r3r
         RBgGigmHJn+mG8rh+rrSfDqq2SdthMmzakAE8uf56Ks1STHFgtkyEvVJSTmUDeKd4JlH
         Cx+3SJd1aI9By0RJ0GJTBMtFDnsq45jEHay9VWPh2LaXhf87zwX1sup1iq4GFW7bYwHN
         wYZuJxH556l/n/M+2V+a2YdPh4IkzEbo9S36Kf5zviplDX4eWHJkLL/e8sUM7P5GbZLv
         8Ccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RkpPiL5sLMoQ72Z4SVPCyIzaZVEUsKD6IONs26Z9oQ4=;
        b=BFEb+p8V8gCmTXrFhHOUSdzdOxFiznKB+QeHZHAwosrzruPm1hxspepLoDDFJ++x9Z
         QNXKXTO6fIgWUydKNzOZ7V70KISC0cZbNvKaia3NDdI4pggbWi6TE5irqm2RYaR1EnZf
         o3MHQWY3M7HWXbboQ/diRU0feKfJWJoXHtoyuu16QYmePpB+9po5CJvh7J8s3YnuQho7
         3uaVWRic/9wOX3p+4vDXjeKpS3SURd9eR54LT8pPS6rsltuVyeZn1d8C0RIDmALPoAQx
         ZRQNj3C7f40BxZXCf9ht3dAWal6uvlnzDV3CQTPCEf3W/DoNz2Yu4WwOsCQSVlHVXylm
         hxVg==
X-Gm-Message-State: AOAM531RBv4Bs8vgwBj8P7c1hg2BndSToOo+L1k5uPpmr3Xxqj73YrDx
	6ITS3qUi8ee/p7K5zbm6PVo=
X-Google-Smtp-Source: ABdhPJwkH8cFnD08Pdj7anSenqn2tvNw6QetwTg2I4xIrVuO/X572JBB17yMeOLN0zGx1aVaPRH8zA==
X-Received: by 2002:aed:3203:: with SMTP id y3mr1556830qtd.278.1600886973396;
        Wed, 23 Sep 2020 11:49:33 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Wed, 23 Sep 2020 14:49:30 -0400
To: Solar Designer <solar@openwall.com>
Cc: Florian Weimer <fweimer@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	madvenka@linux.microsoft.com, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	oleg@redhat.com, x86@kernel.org, luto@kernel.org,
	David.Laight@ACULAB.COM, mark.rutland@arm.com, mic@digikod.net,
	Rich Felker <dalias@libc.org>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923184930.GA1352963@rani.riverdale.lan>
References: <20200922215326.4603-1-madvenka@linux.microsoft.com>
 <20200923081426.GA30279@amd>
 <20200923091456.GA6177@openwall.com>
 <87wo0ko8v0.fsf@oldenburg2.str.redhat.com>
 <20200923181136.GA8846@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200923181136.GA8846@openwall.com>

On Wed, Sep 23, 2020 at 08:11:36PM +0200, Solar Designer wrote:
> On Wed, Sep 23, 2020 at 04:39:31PM +0200, Florian Weimer wrote:
> > * Solar Designer:
> > 
> > > While I share my opinion here, I don't mean that to block Madhavan's
> > > work.  I'd rather defer to people more knowledgeable in current userland
> > > and ABI issues/limitations and plans on dealing with those, especially
> > > to Florian Weimer.  I haven't seen Florian say anything specific for or
> > > against Madhavan's proposal, and I'd like to.  (Have I missed that?)
> 
> [...]
> > I think it's unnecessary for the libffi use case.
> [...]
> 
> > I don't know if kernel support could
> > make sense in this context, but it would be a completely different
> > patch.
> 
> Thanks.  Are there currently relevant use cases where the proposed
> trampfd would be useful and likely actually made use of by userland -
> e.g., specific userland project developers saying they'd use it, or
> Madhavan intending to develop and contribute userland patches?
> 
> Alexander

The trampoline it provides in this version can be implemented completely
in userspace. The kernel part of it is essentially just providing a way
to do text relocations without needing a WX mapping, but the text
relocations would be unnecessary in the first place if the trampoline
was position-independent code.
