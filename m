Return-Path: <SRS0=6Xzh=CN=lists.openwall.com=kernel-hardening-return-19786-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE83C433E2
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 14:07:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 754EE206B7
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 14:06:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pb+ilJUJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 754EE206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19786-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21963 invoked by uid 550); 4 Sep 2020 14:06:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21926 invoked from network); 4 Sep 2020 14:06:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wr4ik479hXJMABoUt+QySGUcxYVpD0giYre42tl6Lak=;
        b=pb+ilJUJRPhJ/T5Cca3PbrSqzWYKDzd+9lVwpvCtKeG4tVFR5fQw4XDiIQxMEernf8
         cN/W80EeOycrznLPrK9RkdvnacufPub2oUdkxxGTpGcA1GBMVIWkw8BcapZhRF7M9hCX
         LrD+cFDk+B5RNXXHuTCwraVJ0QWLjLRxgn87VwM/dXlhI1esf59Ab11er8fAr6j7znQn
         1V9KCjQAelo+dg9xaytKB3gQHCJarbecol+hxcLg9/Xw65DqUlhuFRQhvem9IilKf3KU
         QrlZV18mXNtahcZ9xGvB827p/mMnHDDm/dVEvJf//2styAsjRlmRlP03lJjgKsdCw9HM
         LR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wr4ik479hXJMABoUt+QySGUcxYVpD0giYre42tl6Lak=;
        b=CxP49C6GZeWWEg4zmG8LeKG+EMbNRAMkh5b3o3/56DAxoQ0u8zltgZ5irGgr+cm+rD
         nzFaA3avmjCXtN20Ie9urFX1x+4+QB3oOiUj0CTVXFkXhUCnk90KRoulC0Nsim9DvBGE
         DtnVkubvOzDZetEbKpJ8rZ7DGdyyIMbPnGFyyAYNYkG4fCFTkc1jk+xKKw8Gzq/5sPv3
         GYrt+BZboBAHqhAtly0HT+wmIqIQt7BPafzzB5k6qqr1PsuvhCmYYXux2uG9Do1/mZDk
         VnIeRa8v95/wH2idC5fs4W8hfM/ZX/j+2ML7/Ac/nw1lCS/6JO6jNcrFTgqh1hCorFHO
         YeEw==
X-Gm-Message-State: AOAM533wdSQ2mZR5YmzoS9EeSZvTqPtCqlv0YRYoo/Xdh7LM0Io/Mcu/
	V089BTR7uJ1uf3jl2bCREc+eOWP2dORgP5E4m6g=
X-Google-Smtp-Source: ABdhPJziFDpId3xQV+kTiECfez29XequCwVUbV9zAOTxbsVuPohRo7dKhwXxjzjzByWc3HuEEQrlxZ5l47bnwwTL+yY=
X-Received: by 2002:a54:4f9b:: with SMTP id g27mr5430650oiy.140.1599228397615;
 Fri, 04 Sep 2020 07:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200802215903.91936-1-mic@digikod.net> <20200802215903.91936-6-mic@digikod.net>
 <779c290b-45f5-b86c-c573-2edb4004105d@tycho.nsa.gov> <03f522c0-414c-434b-a0d1-57c3b17fa67f@digikod.net>
 <CAEjxPJ7POnxKy=5w-iQkKhjftxf2-=UuvA6D8EmhUPJyS1F6qg@mail.gmail.com>
In-Reply-To: <CAEjxPJ7POnxKy=5w-iQkKhjftxf2-=UuvA6D8EmhUPJyS1F6qg@mail.gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Fri, 4 Sep 2020 10:06:26 -0400
Message-ID: <CAEjxPJ7ARJO57MBW66=xsBzMMRb=9uLgqocK5eskHCaiVMx7Vw@mail.gmail.com>
Subject: Re: [PATCH v20 05/12] LSM: Infrastructure management of the superblock
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Casey Schaufler <casey@schaufler-ca.com>, 
	Kees Cook <keescook@chromium.org>, John Johansen <john.johansen@canonical.com>, 
	linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@amacapital.net>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Arnd Bergmann <arnd@arndb.de>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, 
	Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, 
	"Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	linux-kselftest@vger.kernel.org, 
	LSM List <linux-security-module@vger.kernel.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2020 at 2:39 PM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> On Thu, Aug 13, 2020 at 10:17 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t> wrote:
> >
> >
> > On 12/08/2020 21:16, Stephen Smalley wrote:
> > > On 8/2/20 5:58 PM, Micka=C3=ABl Sala=C3=BCn wrote:
> > >> From: Casey Schaufler <casey@schaufler-ca.com>
> > >>
> > >> Move management of the superblock->sb_security blob out
> > >> of the individual security modules and into the security
> > >> infrastructure. Instead of allocating the blobs from within
> > >> the modules the modules tell the infrastructure how much
> > >> space is required, and the space is allocated there.
> > >>
> > >> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > >> Reviewed-by: Kees Cook <keescook@chromium.org>
> > >> Reviewed-by: John Johansen <john.johansen@canonical.com>
> > >> Reviewed-by: Stephen Smalley <sds@tycho.nsa.gov>
> > >> Reviewed-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> > >> Link:
> > >> https://lore.kernel.org/r/20190829232935.7099-2-casey@schaufler-ca.c=
om
> > >> ---
> > >>
> > >> Changes since v17:
> > >> * Rebase the original LSM stacking patch from v5.3 to v5.7: I fixed =
some
> > >>    diff conflicts caused by code moves and function renames in
> > >>    selinux/include/objsec.h and selinux/hooks.c .  I checked that it
> > >>    builds but I didn't test the changes for SELinux nor SMACK.
> > >
> > > You shouldn't retain Signed-off-by and Reviewed-by lines from an earl=
ier
> > > patch if you made non-trivial changes to it (even more so if you didn=
't
> > > test them).
> >
> > I think I made trivial changes according to the original patch. But
> > without reply from other people with Signed-off-by or Reviewed-by
> > (Casey, Kees, John), I'll remove them. I guess you don't want your
> > Reviewed-by to be kept, so I'll remove it, except if you want to review
> > this patch (or the modified part).
>
> At the very least your Reviewed-by line is wrong - yours should be
> Signed-off-by because the patch went through you and you modified it.
> I'll try to take a look as time permits but FYI you should this
> address (already updated in MAINTAINERS) going forward.

I finally got around to reviewing your updated patch.  You can drop
the old line and add:
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
