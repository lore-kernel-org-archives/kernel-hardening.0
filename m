Return-Path: <SRS0=05ba=VU=lists.openwall.com=kernel-hardening-return-16547-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4D6C76190
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 06:08:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DAB222239E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 06:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="eYCyZD6+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAB222239E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16547-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30035 invoked by uid 550); 23 Jul 2019 06:08:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19590 invoked from network); 23 Jul 2019 00:36:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V1qLox/HcKqaARh5nCdyrjblfDl+n5sFe9PDB624/uQ=;
        b=eYCyZD6+ZuS/vB5TpYkBQYdKK5kd/jAesT2uuum+J1rP8+F3tiaJNaHOM+OvjFJDG7
         uyATfkYBrP90hc/NdWXf2hUkpuNxNzNetlz/kRTIFKRObov3+7X5p8wuG52iS8nnvPkR
         YTmISBefoo5i53nN3wMEnKTAOaVfnLWq93v+NfwsCgIzjejDXAxplDvUw25W/orQuqAO
         FGp6wzvEcIMvgx0GkySU0cKoMKt4d6zWjmQ2cm0MUSIzIRT8Jku/LWMDQTWkozOiTlYX
         VRcf1qdMDEESplMOLNSnS2NS6S8uADE6jrv7pW+uFESXyEazFYl/WuFdYQKaEphIibCh
         41jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V1qLox/HcKqaARh5nCdyrjblfDl+n5sFe9PDB624/uQ=;
        b=IU2wfgMwa9fIQk3rrRYypdXlH4eLO5rnSk/dXUGXH5ICCS1p0K7d0TMh+GNuTqWnd9
         p5+V2CwMd9KfKNItqYzLUhZIaAEF3vx5mRGe9scPFUDh3oTUrIgU0iz8Li0GqGDNWGg1
         YYvM1/mssi0w/LkW29PkwZlf9i7SpViGuZpsuDwj6iNnjx4SYjtqaWUAGDOXZS7PYrZI
         IQPaYndkmJIw7TlVQd5LnWJPR2fdikXgGoW8cs2ViLEjCjSvvhRoVdR1WoURRKP9Hckt
         szrTVBaK72ralpReEWMivyzueV1W0A+hIzPzWIkJRdTm7INxW7a8WXFZm5iWxExwczRW
         8IIg==
X-Gm-Message-State: APjAAAXWaqU6FtQo7aqrWfaAv1+V9I3vdNYmMG/517kF6Cp0eZyv9TVb
	zrh1KFfYAMsjypiZpIhhgKJZIjZBixkRIY6KyQ==
X-Google-Smtp-Source: APXvYqzoUjfQZm+IXQbdMcOuDKAltzsj6XLnjHXuqPGc8HA3CrakVkrDK/T3HMwcmv9vyX3yUlvdz45JWRZ28K7TVvw=
X-Received: by 2002:ac2:4c37:: with SMTP id u23mr19426864lfq.119.1563842177418;
 Mon, 22 Jul 2019 17:36:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190722132111.25743-1-omosnace@redhat.com> <201907220949.AFB5B68@keescook>
In-Reply-To: <201907220949.AFB5B68@keescook>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 22 Jul 2019 20:36:06 -0400
Message-ID: <CAHC9VhSpwafSdcX97VPiy1Earns4UOBjywcM9R=j24KFUtWB8g@mail.gmail.com>
Subject: Re: [PATCH] selinux: check sidtab limit before adding a new entry
To: Kees Cook <keescook@chromium.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	NitinGote <nitin.r.gote@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 22, 2019 at 12:50 PM Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jul 22, 2019 at 03:21:11PM +0200, Ondrej Mosnacek wrote:
> > We need to error out when trying to add an entry above SIDTAB_MAX in
> > sidtab_reverse_lookup() to avoid overflow on the odd chance that this
> > happens.
> >
> > Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>
> Is this reachable from unprivileged userspace?

I believe it's reachable via selinuxfs under /sys/fs/selinux/context,
and the DAC permissions are for the relevant files are 0666, but the
SELinux policy might restrict that.

> > ---
> >  security/selinux/ss/sidtab.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> > index e63a90ff2728..54c1ba1e79ab 100644
> > --- a/security/selinux/ss/sidtab.c
> > +++ b/security/selinux/ss/sidtab.c
> > @@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
> >               ++count;
> >       }
> >
> > +     /* bail out if we already reached max entries */
> > +     rc = -ENOMEM;
> > +     if (count == SIDTAB_MAX)
>
> Do you want to use >= here instead?

Yes, definitely.

-- 
paul moore
www.paul-moore.com
