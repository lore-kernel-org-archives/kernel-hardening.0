Return-Path: <SRS0=1GEQ=YX=lists.openwall.com=kernel-hardening-return-17171-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C53CA9EC5
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 18:30:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6F56D20717
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 18:30:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="al5aEOhx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F56D20717
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17171-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7267 invoked by uid 550); 30 Oct 2019 18:30:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7231 invoked from network); 30 Oct 2019 18:30:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qt1LJEyIRaEDllLVqLH7qbNDphlkjCZco3W19Gfwzcw=;
        b=al5aEOhxLiz0B1e3fwRa1JcU4iQZgmirA1Ct/lHAO/pQEfSBmkDnCWE6zt0ZZVm9yF
         iOnnQSg/OytlL7fwVY98bQg8i+gKIO84NlHty7mZoArixkMXetqSqD5uMYGcnlx1WNgE
         aqFVwy9/TbvwyeVX3hUWoFMEWmIklYjRnLhJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qt1LJEyIRaEDllLVqLH7qbNDphlkjCZco3W19Gfwzcw=;
        b=QHIVWBq0RHwLYAL7zlTMhGlKkRHnuFejaHlBml3OeOu89iW/L59ZFgrBMMAIzrrVYJ
         4Oic05JBW0HWyP6O7H7xzSGVqL2bt/hXsk8l51WaGm2EcolFfBlNfYSSMp+bn/95B47r
         vKNsy0NeI1nk1aOUed1VqgU7YV/KlPAGBGU67ywqyZyTEVR9VZkfz6XgA8B+/2yDjgNn
         VbEZgKIiAmMzgo6hHOMLi+ZuofwYRZ73+tTb9KL4L4uQOKastzCX4tTgQCcSGinEW7O6
         CetiMnregGAotbJS/FHaoqvpiCtrnMhP8a2E3goEBkKSOToLd/uiMGLKNV63PVcJ9efG
         gkMw==
X-Gm-Message-State: APjAAAXGLULB6uxkm0JwsoDx+X1SFnXoVUnrE2/TlhcAGU+3+fuoyzzj
	4i/Sw2bYZYWQjqX7+cuL54lmhg==
X-Google-Smtp-Source: APXvYqz3dMewe2phjB2EOF2Jom8Z3MYTzZ3AjLUP+7e1uUyrqbjtg2J3m89Vu9V2Lh7PUAeTc3TSJw==
X-Received: by 2002:aa7:9a94:: with SMTP id w20mr772278pfi.256.1572460215124;
        Wed, 30 Oct 2019 11:30:15 -0700 (PDT)
Date: Wed, 30 Oct 2019 11:30:13 -0700
From: Kees Cook <keescook@chromium.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org,
	joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com,
	dja@axtens.net, npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 0/5] Implement STRICT_MODULE_RWX for powerpc
Message-ID: <201910301128.E7552CDD@keescook>
References: <20191030073111.140493-1-ruscur@russell.cc>
 <53461d29-ec0c-4401-542e-6d575545da38@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53461d29-ec0c-4401-542e-6d575545da38@c-s.fr>

On Wed, Oct 30, 2019 at 09:58:19AM +0100, Christophe Leroy wrote:
> 
> 
> Le 30/10/2019 à 08:31, Russell Currey a écrit :
> > v4 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198268.html
> > v3 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html
> > 
> > Changes since v4:
> > 	[1/5]: Addressed review comments from Michael Ellerman (thanks!)
> > 	[4/5]: make ARCH_HAS_STRICT_MODULE_RWX depend on
> > 	       ARCH_HAS_STRICT_KERNEL_RWX to simplify things and avoid
> > 	       STRICT_MODULE_RWX being *on by default* in cases where
> > 	       STRICT_KERNEL_RWX is *unavailable*
> > 	[5/5]: split skiroot_defconfig changes out into its own patch
> > 
> > The whole Kconfig situation is really weird and confusing, I believe the
> > correct resolution is to change arch/Kconfig but the consequences are so
> > minor that I don't think it's worth it, especially given that I expect
> > powerpc to have mandatory strict RWX Soon(tm).
> 
> I'm not such strict RWX can be made mandatory due to the impact it has on
> some subarches:
> - On the 8xx, unless all areas are 8Mbytes aligned, there is a significant
> overhead on TLB misses. And Aligning everthing to 8M is a waste of RAM which
> is not acceptable on systems having very few RAM.
> - On hash book3s32, we are able to map the kernel BATs. With a few alignment
> constraints, we are able to provide STRICT_KERNEL_RWX. But we are unable to
> provide exec protection on page granularity. Only on 256Mbytes segments. So
> for modules, we have to have the vmspace X. It is also not possible to have
> a kernel area RO. Only user areas can be made RO.

As I understand it, the idea was for it to be mandatory (or at least
default-on) only for the subarches where it wasn't totally insane to
accomplish. :) (I'm not familiar with all the details on the subarchs,
but it sounded like the more modern systems would be the targets for
this?)

-- 
Kees Cook
