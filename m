Return-Path: <SRS0=x9Oy=AF=lists.openwall.com=kernel-hardening-return-19135-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97560C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:10:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EA3902072E
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ulgAO6ky"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA3902072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19135-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15433 invoked by uid 550); 24 Jun 2020 21:10:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15398 invoked from network); 24 Jun 2020 21:10:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2jIkhYgexjs9KkwlPySDcA/4RhGGwlAKSrpoMnhGmk=;
        b=ulgAO6kyxk2umRKRWH6nMJnay5+JI9S+MN+66ac15rcJgmGZtAYk+H5+fPCQqHCN4n
         YwMVU0XBQEhTdVY5OHD749qpd8Pozz/SM+1Buf2jPE/xGsC+B8G3MYh7c8rCA848s7mL
         3wpkBMp2MTJmyiCiTEBPNG6vBbmHu+xghA1mKpCcjOJyJnqEFuFwGJ/pFH0IcAb5JQC+
         A2lLOE//kF+ciANNdx3Etcs1w4HXCok/pytM4pC9m2UbLu8T+ZNQiWPiX0fGAsI8+xBJ
         v8AHa7fV3npUoZ0xdjzOFVVo0SV0pKjAQOJojHM+9coxAbL/MqHPcTuHuRnLuuT3AK8g
         iPTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2jIkhYgexjs9KkwlPySDcA/4RhGGwlAKSrpoMnhGmk=;
        b=jOCh6Ua6JaE2WYdkJGblxQ9yYnmYl/lTAEQycJzvZYyXLeymuY7vHRKqoMVYo4tuRM
         tCuvamFQdkSgHnVYIAAs5P6YNZFWaU7LRoYqGQ2VqrlX62NhYplAfts9IEeF1EmzYGmB
         rIpo6oBO6vh3S8l/17TGJoL73+/+6U8Vj0YZFYQo0LkeMBYEK7+Cozn5oniWeN81x/fm
         5QluM/LGAr41eKAAA5bNyDiDJH947B6zsFB072zMHLdauJWsKat5u50JtIUcFhdI1aMK
         QQzf2mNqPPVmXlE0Vy/GUUo6H2+GuRdGvm/FEHB7JEanqvh23e1zLEvK+E9krmruVy/5
         h7CQ==
X-Gm-Message-State: AOAM530ZSn+h1mmMkwYxlZvya4ellZSUL3EuoIpqu2P2mGHtExwTHd99
	5OGfbYpjdCZMUWNpnuskunxI53hXGSMWCVpTv7pwzw==
X-Google-Smtp-Source: ABdhPJyx7J+Crf2HbQKcuBNOiCwJq3seEefhf6EE+jeFP724rCfUEgtaO9Vi1jID9/eG3LhJZ3IQ+YfzgYs3IE2HM8s=
X-Received: by 2002:a63:5644:: with SMTP id g4mr22699481pgm.381.1593032992558;
 Wed, 24 Jun 2020 14:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-18-samitolvanen@google.com> <CAKwvOdnEbCfYZ9o=OF51oswyqDvN4iP-9syWUDhxfueq4q0xcw@mail.gmail.com>
In-Reply-To: <CAKwvOdnEbCfYZ9o=OF51oswyqDvN4iP-9syWUDhxfueq4q0xcw@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 24 Jun 2020 14:09:40 -0700
Message-ID: <CAKwvOdm_EBfmV+GvDE-COoDwpEm9snea4_KtuFyorA5KEU6FbQ@mail.gmail.com>
Subject: Re: [PATCH 17/22] arm64: vdso: disable LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 24, 2020 at 1:58 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > Filter out CC_FLAGS_LTO for the vDSO.
>
> Just curious about this patch (and the following one for x86's vdso),
> do you happen to recall specifically what the issues with the vdso's
> are?

+ Andi (tangential, I actually have a bunch of tabs open with slides
from http://halobates.de/ right now)
58edae3aac9f2
67424d5a22124
$ git log -S DISABLE_LTO

>
> >
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  arch/arm64/kernel/vdso/Makefile | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
> > index 556d424c6f52..cfad4c296ca1 100644
> > --- a/arch/arm64/kernel/vdso/Makefile
> > +++ b/arch/arm64/kernel/vdso/Makefile
> > @@ -29,8 +29,8 @@ ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv \
> >  ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
> >  ccflags-y += -DDISABLE_BRANCH_PROFILING
> >
> > -CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
> > -KBUILD_CFLAGS                  += $(DISABLE_LTO)
> > +CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
> > +                               $(CC_FLAGS_LTO)
> >  KASAN_SANITIZE                 := n
> >  UBSAN_SANITIZE                 := n
> >  OBJECT_FILES_NON_STANDARD      := y
> > --

-- 
Thanks,
~Nick Desaulniers
