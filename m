Return-Path: <SRS0=+n2a=3F=lists.openwall.com=kernel-hardening-return-17579-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD62BC33CAF
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 20:17:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1A682206D9
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 20:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nqN/bGHt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A682206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17579-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1294 invoked by uid 550); 16 Jan 2020 20:17:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1267 invoked from network); 16 Jan 2020 20:17:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZF5qzwwkyvyxMKFoOMSyyzNqONb3HROfIsi+ysNvVik=;
        b=nqN/bGHtSGgX+TrvYBkC13nJUB3X8ukJ0klosFF2D10Zy6+y3oamxcHwM8fKEGApUq
         ljpWCk+uAgUgTHRZ1qBolWRCI5hpR6cf37CtPTltdh0YgZvzs++wth7qnHJIp986uOBB
         UtxOCPtMeYhDZIrkw9F7bWSMB7HrODj92xdDp0H7B5dpg/28a7guMnn4MYFhqm3AeNyl
         0j3ofX8AEU86BvazTA4YNmuV8io7MMtpGWaEkogvIihSJVFwcARSZu5G6e+K3zeFZ3kx
         72oIJUgsqtD/qxVLtjNU3NsUe+MHB49BJcuPel9WG6KsUZ0IewO/3FguqYguZl6qKihc
         072g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZF5qzwwkyvyxMKFoOMSyyzNqONb3HROfIsi+ysNvVik=;
        b=duTuWDIHEYI8NQW/moOQADP0DKihKDwanQtIQPXAdOqRHdNWrq1TYsZW0SvBW9Hzaq
         VXZWAOFmIvdT5N20iJtxNhC471Z6lELHxMKeCGcAvUp7AQ18PWD3G+yaO70sz0DcY+n6
         P0ASxltHk9LYeB8ZBHZleImGxsjRZEEh/+VQQC+bOwpKYBUtWsZffxJQ44IYBf1uddrI
         ClFRlAgzbYHQBL8khI5vkPVMjy8OBl7JukaB8kOSJ9auHQ962zfwYsRDJnPNAf2EkC0W
         tsFYJBaPC/sy9NZgGYZ9/xNbXhOaE2ln39cEyJDbFnQ82wpZpbOwcfLXcikMFDKJfV3n
         5Taw==
X-Gm-Message-State: APjAAAXMw0DaszffGDocYHCMWWqcrGfUfxEjpfumy1E9WIUfNUj5/8UG
	U9DR63ZS3dISX30QJYa6cYKcsI07y6NzXBRdRhSN1Q==
X-Google-Smtp-Source: APXvYqzGSnsl6edzBoVDYTYn7dSudVhqxeHJpq3vbT3Nbo0uCX4G50Cg8szwmqQoGFBA6ZgNEWLEG8Jm96Lj3l2tVXg=
X-Received: by 2002:a67:f057:: with SMTP id q23mr3030208vsm.5.1579205825357;
 Thu, 16 Jan 2020 12:17:05 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191206221351.38241-1-samitolvanen@google.com> <20191206221351.38241-14-samitolvanen@google.com>
 <20200116174742.GF21396@willie-the-truck>
In-Reply-To: <20200116174742.GF21396@willie-the-truck>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 16 Jan 2020 12:16:53 -0800
Message-ID: <CABCJKucQY_Qr6bZXW5TdPnDcBUd7uk8_Md5FNfO+ObNmsH3MZg@mail.gmail.com>
Subject: Re: [PATCH v6 13/15] arm64: disable SCS for hypervisor code
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 16, 2020 at 9:47 AM Will Deacon <will@kernel.org> wrote:
>
> On Fri, Dec 06, 2019 at 02:13:49PM -0800, Sami Tolvanen wrote:
> > Filter out CC_FLAGS_SCS for code that runs at a different exception
> > level.
> >
> > Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/Makefile | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> > index ea710f674cb6..17ea3da325e9 100644
> > --- a/arch/arm64/kvm/hyp/Makefile
> > +++ b/arch/arm64/kvm/hyp/Makefile
> > @@ -28,3 +28,6 @@ GCOV_PROFILE        := n
> >  KASAN_SANITIZE       := n
> >  UBSAN_SANITIZE       := n
> >  KCOV_INSTRUMENT      := n
> > +
> > +# remove the SCS flags from all objects in this directory
> > +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
>
> Same comment as for the vDSO; can we remove the -ffixed-x18 as well?

Sure, I don't see why not. I'll change this in the next version.

Sami
