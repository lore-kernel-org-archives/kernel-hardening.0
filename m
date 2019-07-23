Return-Path: <SRS0=cU1G=VU=lists.openwall.com=kernel-hardening-return-16546-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4F5C76190
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 06:08:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 224372166E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 06:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="HBiM+Ghp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 224372166E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16546-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28635 invoked by uid 550); 23 Jul 2019 06:08:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11470 invoked from network); 23 Jul 2019 00:25:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QchpEl6IYcDn2365/1cAgrUj/Kod3MFaa9kS/y4zsIA=;
        b=HBiM+Ghpfpp+iZBoxIUNJ2J3yJMGSnr6utpnv/T21+Byj6Hjh9iQP076Qh6GBNe/Y6
         AbYzxrADIvG98AFdE5/ChLpaKuHryldzAwsrWdesvixGNgk7emHBIfc7yEd+HQI+VfMF
         eX5jgnwshMil2Hu09h2+tDX7EqIuuo8Gc47w77IB3DBAN+9Prv7TQY4khMVNqriv9st5
         ciPXLg+rSbU/q0tOf+/5GdsWhsoGa59FLmabXL5A+QBpwiQIcYMmv4brLhD7xn+kc5mB
         TBNeJOfKL2vQ79QOMG5Ygm+dWolASdkNOOiNiDZd8+n+QNECI0D5sqpTvnnCU7QnhwGA
         loQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QchpEl6IYcDn2365/1cAgrUj/Kod3MFaa9kS/y4zsIA=;
        b=bFcBXvrT+QlJ80UefSu/U77/7fwNQv2Lxzi2iKy+65u8fcK9+8DaD01/bDGV/NUdx/
         U21xWW/+UYq9ifpgTr7jWCMWVNW2q2nT1UiDoAd8ZbnxauI2jXPqLbRpHxazyCi0E17H
         DyqE9D1lReRVzbm95abpunw+3zT6FewSytOGG8RVtzpDIgCL1WG4WI8M2PkySaPxq+Bz
         H4hiWZ2OpMUhDwlnNjvmE8rkFW+kdQSY+nT9GWhCkc6B9Vp8cZIrxXn8/dMOPdf8k9XA
         ra/NmXgJJ+MAn8KP+kVZtyJYlG+Zye1p0g8zuw/c4Pbw1YJ3M5zCs9i7KF3W/bNtw8wL
         4N0w==
X-Gm-Message-State: APjAAAX/w5jQZKkBK4tqdid15b24zSBnQXhoDyY3p/DyeGbur7gBNqnT
	fk3WX/M6Lz4+W+x0VjE4kXwQobb26Ea5A412kA==
X-Google-Smtp-Source: APXvYqx8Y9O6JQiw0vn8cUbd+Kt7Bu2W5CGQbSsI0sL8oQGMsom1pYEvtO1whbQwpCJnO24ajc3HZ8ouCLA0cxbQ82A=
X-Received: by 2002:a19:4349:: with SMTP id m9mr32869303lfj.64.1563841529750;
 Mon, 22 Jul 2019 17:25:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190722113151.1584-1-nitin.r.gote@intel.com> <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
In-Reply-To: <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 22 Jul 2019 20:25:18 -0400
Message-ID: <CAHC9VhSQLkRSby3-9PGZZrLMGB4Fe8ZZjupHRm0nVxco85A1fQ@mail.gmail.com>
Subject: Re: [PATCH] selinux: convert struct sidtab count to refcount_t
To: Ondrej Mosnacek <omosnace@redhat.com>, NitinGote <nitin.r.gote@intel.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, 
	Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, 
	SElinux list <selinux@vger.kernel.org>, 
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 22, 2019 at 9:18 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> On Mon, Jul 22, 2019 at 1:35 PM NitinGote <nitin.r.gote@intel.com> wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> >
> > Signed-off-by: NitinGote <nitin.r.gote@intel.com>
>
> Nack.
>
> The 'count' variable is not used as a reference counter here. It
> tracks the number of entries in sidtab, which is a very specific
> lookup table that can only grow (the count never decreases). I only
> made it atomic because the variable is read outside of the sidtab's
> spin lock and thus the reads and writes to it need to be guaranteed to
> be atomic. The counter is only updated under the spin lock, so
> insertions do not race with each other.

Agreed, this should be changed to use refcount_t.

-- 
paul moore
www.paul-moore.com
