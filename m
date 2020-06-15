Return-Path: <SRS0=eDph=74=lists.openwall.com=kernel-hardening-return-18983-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2167C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 17:03:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2BB332078E
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 17:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZdDL5AnK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BB332078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18983-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15397 invoked by uid 550); 15 Jun 2020 17:03:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15374 invoked from network); 15 Jun 2020 17:03:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h+e+6oiMfPcuzfOioIuAZY78N0uqSVxHMMheHIvnJFI=;
        b=ZdDL5AnKuDKjT78TYGdiLM90FU4CSgVPQvBPwBxI4352g9rT5orcRSoCEyhOgCzmrb
         4e5RDz3iPk4xgm/IQFSISxou4eEhtOFpaahQc3QKC4aym1agnSpfRVXS8vTqXb2Plmrd
         JE+g5jt9NSl4Bg3MUUdIcJO1AZwUTx6w0nfikkonIXSuSDXlbWYxbECK8lmFLj4afdYC
         HrXWm/+8PH0LuJZpduXLjdnuoL+cnyvy/wanzTOdUAr9jrz/ji7YRX+MTUSO0WBJYFXJ
         eCTY/xUIKoC3WPvskinA4vXddp2oIjFSeL+i1Yt4RZNpAH1rkFIT1NsfcEEsKZQU8Oth
         aD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h+e+6oiMfPcuzfOioIuAZY78N0uqSVxHMMheHIvnJFI=;
        b=UYfgXabe3icNL0iD0jk0JXoaGsfqIQuHteJptqufjxvfoVY6vEQNWWSxINIbcrZEVP
         zF6uqdb3tEKmOAMa58VQZ44OnQOAbXOHNgAgIXVLHIWGvCpy1GJtigEsMam/0mPFq2TE
         pvj2rkfG2/0lAawdjIHhzHFmVI17rN5n90nG6OchYYPwoHTzknu2PsAs2/SErh3lmQWx
         jFFQK3nVK4c+Jmta1ZQH1PY/vnDuv8K7eB7cEyB3u9X9ijCqINm3NCNtpTH3VYyO+a6g
         6TlPyD7JKlr9QkAPMV84q9dULCavvvIdKPFZeiQYihLDM0OZBnw2SaMKoXPLYcOJuyfL
         oKcQ==
X-Gm-Message-State: AOAM532RlbW5z4PYamzHAGSY9y/cGKOxAJpHXI6YqWIUo1+D8tLe1UJ5
	sBBmUSDjbX1HIaN8vhpdBsVnK3LexGeOXrGsxnpLlA==
X-Google-Smtp-Source: ABdhPJxKghjauWCQ06S7R7giwAOWLRv8YnNXKPN82l+nvWY9jbQW3XjbsykSVqW3lMHbTPuJcLGB8eKa4JCQbYJKd3Y=
X-Received: by 2002:a05:651c:38b:: with SMTP id e11mr12109574ljp.415.1592240597617;
 Mon, 15 Jun 2020 10:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
 <206DB19C-0117-4F4B-AFF7-212E40CB8C75@oracle.com>
In-Reply-To: <206DB19C-0117-4F4B-AFF7-212E40CB8C75@oracle.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 15 Jun 2020 19:02:51 +0200
Message-ID: <CAG48ez3fQbBLUBUkSaF-0b_DhL8M_1JU4DKkjTYXGB_6G1RgiA@mail.gmail.com>
Subject: Re: [oss-security] lockdown bypass on mainline kernel for loading
 unsigned modules
To: John Haxby <john.haxby@oracle.com>
Cc: oss-security@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	linux-security-module <linux-security-module@vger.kernel.org>, linux-acpi@vger.kernel.org, 
	Matthew Garrett <mjg59@srcf.ucam.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 15, 2020 at 6:24 PM John Haxby <john.haxby@oracle.com> wrote:
> > On 15 Jun 2020, at 11:26, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > Yesterday, I found a lockdown bypass in Ubuntu 18.04's kernel using
> > ACPI table tricks via the efi ssdt variable [1]. Today I found another
> > one that's a bit easier to exploit and appears to be unpatched on
> > mainline, using acpi_configfs to inject an ACPI table. The tricks are
> > basically the same as the first one, but this one appears to be
> > unpatched, at least on my test machine. Explanation is in the header
> > of the PoC:
> >
> > https://git.zx2c4.com/american-unsigned-language/tree/american-unsigned-language-2.sh
> >
> > I need to get some sleep, but if nobody posts a patch in the
> > meanwhile, I'll try to post a fix tomorrow.
> >
> > Jason
> >
> > [1] https://www.openwall.com/lists/oss-security/2020/06/14/1
>
>
> This looks CVE-worthy.   Are you going to ask for a CVE for it?

Does it really make sense to dole out CVEs for individual lockdown
bypasses when various areas of the kernel (such as filesystems and
BPF) don't see root->kernel privilege escalation issues as a problem?
It's not like applying the fix for this one issue is going to make
systems meaningfully safer.
