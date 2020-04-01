Return-Path: <SRS0=+JKQ=5R=lists.openwall.com=kernel-hardening-return-18357-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777FAC43331
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 17:47:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C6A0F20719
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 17:47:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pVcU+dsH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6A0F20719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18357-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19959 invoked by uid 550); 1 Apr 2020 17:47:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19926 invoked from network); 1 Apr 2020 17:47:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7f+oFGBz4lKq+gYaVg47iObMCSlHnFkkTWzFoO6ob70=;
        b=pVcU+dsHG+xi+OdTaXPlzb2fvjo47FLw/EUeR34ecopFZpovwEmAGBOR1KUyZ6G3vt
         7HV0y+QRQzVY8Lx9vEb6utqV7AIxezWlddf9ft4fmX5Kmh2JLVTeNtXRHVmARyhnmuR3
         UJgf3w8ZuSSFEoVmtaj+a8Ljkz7vkiaRdg4wU8DLrI/3J0hAKW+GYrXM97SQQHdbriVF
         WEh+cPxR92okd0nPKw7F/JfjrEds+3rxYkbsKM4th6lgFcURuC099Nk1SchXWqRMbUR7
         V0GwxUcl2onS7SY10WqEbxlm3r/0+MNuObBGG11nLve5x+q8mNj3NiN4ZrDYDoVpumib
         yrrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7f+oFGBz4lKq+gYaVg47iObMCSlHnFkkTWzFoO6ob70=;
        b=Hb16AKXrTMNTW9yBFKYkNURPwDkXOEksa+JnnD4wgbmwBjw7QTdd/8DEJZay+e6UEa
         t1J1WZnx+VvEFxcP0J72OE3VaegRai5/FQ1xWx52qWGFJuK3Xfg835cq5U8hBfHwxCkg
         ngPMGNNiJFZL4vmAS5aU5Wm8XLWUMvClJGd6a2srpZsizm/xPZZLmAvmUIdDClVMtX5T
         WNeicMpT6/Cz80N29qM9RaHlN6nrBajr4D9A39myD42Amc7Ugh/AGrppoXC9K3SFflq/
         vZVlUX46yGVjjkbJdu/YKxlSemjP0FZ8X7xMaIbhDPS4V87HVxPdqx82u5mIWzDVqw78
         Kgag==
X-Gm-Message-State: ANhLgQ3+r1H0L7Jn1gC3VLtcmaiht090r5EOxl95yN8zt2WdR7RO4Igv
	+t6XgjsTc4eGZyUqhO0bGwEsFa1Gxb/XnOd7L1s=
X-Google-Smtp-Source: ADFU+vtcPRVHBDFXuLENFOQ1nGCShR+miCa33OMScUOHVZVQa44lyFKgZ0mNFPnw7ZGMLllXJbDU7a+zLtxmGrqTOGY=
X-Received: by 2002:a05:6e02:688:: with SMTP id o8mr20983373ils.156.1585763231060;
 Wed, 01 Apr 2020 10:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <202004010033.A1523890@keescook> <20200401142057.453892-1-slava@bacher09.org>
 <eba80d4e-a385-1fba-37f9-38888ae91f1e@bacher09.org>
In-Reply-To: <eba80d4e-a385-1fba-37f9-38888ae91f1e@bacher09.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 1 Apr 2020 10:46:57 -0700
Message-ID: <CAEf4BzYx7hffHm5RV3QQQqvgAzy-41DRgFQDKh+4xcM9OL890A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
To: Slava Bacherikov <slava@bacher09.org>
Cc: Kees Cook <keescook@chromium.org>, Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Liu Yiding <liuyd.fnst@cn.fujitsu.com>, KP Singh <kpsingh@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 1, 2020 at 7:38 AM Slava Bacherikov <slava@bacher09.org> wrote:
>
>
>
> 01.04.2020 17:20, Slava Bacherikov wrotes:
> > Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
> > enabled will produce invalid btf file, since gen_btf function in
> > link-vmlinux.sh script doesn't handle *.dwo files.
> >
> > Enabling DEBUG_INFO_REDUCED will also produce invalid btf file, and
> > using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.
> >
> > Signed-off-by: Slava Bacherikov <slava@bacher09.org>
> > Reported-by: Jann Horn <jannh@google.com>
> > Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
> > Acked-by: KP Singh <kpsingh@google.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
> > ---
> >  lib/Kconfig.debug | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index f61d834e02fe..b94227be2d62 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -222,7 +222,9 @@ config DEBUG_INFO_DWARF4
> >
> >  config DEBUG_INFO_BTF
> >       bool "Generate BTF typeinfo"
> > -     depends on DEBUG_INFO
> > +     depends on DEBUG_INFO || COMPILE_TEST
> I had to add this, since DEBUG_INFO which depends on:
>
>         DEBUG_KERNEL && !COMPILE_TEST
>
> would block DEBUG_INFO_BTF when COMPILE_TEST is turned on.
>

Sorry if I'm being dense here. But what's the point in enabling
DEBUG_INFO_BTF if there is no *valid* DWARF info available for
DWARF-to-BTF conversion?


> In that case allyesconfig will emit both:
>
> CONFIG_DEBUG_INFO_BTF=y
> CONFIG_GCC_PLUGIN_RANDSTRUCT=y

Which I thought is exactly what we wanted to avoid. Not sure what's
the point of compiling kernel (even if it's the one that is not
supposed to ever run) that apriori has broken BTF? If it was
acceptable to not have DEBUG_INFO for COMPILE_TEST, why it's not
acceptable to not have DEBUG_INFO_BTF in that situation as well?

>
>
>
> > +     depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
> > +     depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
> >       help
> >         Generate deduplicated BTF type information from DWARF debug info.
> >         Turning this on expects presence of pahole tool, which will convert
> >
