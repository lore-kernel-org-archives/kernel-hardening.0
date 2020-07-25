Return-Path: <SRS0=/xra=BE=lists.openwall.com=kernel-hardening-return-19450-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784C1C433E1
	for <kernel-hardening@archiver.kernel.org>; Sat, 25 Jul 2020 15:10:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CE536206C1
	for <kernel-hardening@archiver.kernel.org>; Sat, 25 Jul 2020 15:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="O4nMnn44"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE536206C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19450-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6097 invoked by uid 550); 25 Jul 2020 15:10:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6077 invoked from network); 25 Jul 2020 15:10:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1595689772;
	bh=0+dq02+bTSZOWjOfes98J38UFipLGTbuXRkC1inmA3U=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O4nMnn44Dbi2fanJvR/4mvXmlsGpcLqZG9nCR8UR0Zf5EjwcO2E35MSM9NpIMVcHe
	 EnIroe2dfwpt68KTNi50T2xmrrlTOlI+gFcS+OsteiPKzjCO0cd6oGdxD9tYcxoiNm
	 MTNnqSZl2UoCgqz34LyNdS9sDu9tRaOZxJIHTmTM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 25 Jul 2020 17:09:14 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200725150914.GA3362@ubuntu>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
 <20200719155033.24201-3-oscar.carter@gmx.com>
 <20200721140545.445f0258@oasis.local.home>
 <20200724161921.GA3123@ubuntu>
 <20200724123528.36ea9c9e@oasis.local.home>
 <20200724171418.GB3123@ubuntu>
 <20200724133656.76c75629@oasis.local.home>
 <20200724134020.3160dc7c@oasis.local.home>
 <20200724175500.GD3123@ubuntu>
 <20200724143457.27755412@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724143457.27755412@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:W/HeglBOHMPssphZao4Bb9c/Pd7lRCslUJblLnctWyCUmDYyO6w
 YpmEOMVoZslb4H/XM0PZLeTJ+nMUtI+8G9fnb6i3QfrW3F6iH8dk9uedQQIQ9e5MLUHXWwO
 Xz/FVhiyB8gt+/NXUl5xDW5qOM1ZMUJoGM3Va3eHjYRZ6JMfVU80Ovp1TMMFkNsiisiTyGJ
 1FDsnD0UVKkFB7z/QeD7g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:g/VfRa5rABE=:OA46ynlvPUZWDrz+UmkSlE
 9EkXlH14BlRtWJyelPFyPn/fx1HoJBtisqfBpkxceyTIC+zQoKdh1jo3BgTc2yhmkyTJ9ahNJ
 U3woiYdtYmQSv4gRkIwdKsUzyA+3zoWFdW1ZgxREUx8wwcoxLacumDG9q+OlJIOqg/6h6W1Mu
 +NDvt9bXiBmDxv8DWuC6aZtKGu7t56GxTPA1mtw16BUGLiSNSFm6tliG6wrM2UusZ8rAZJqXj
 XYreNAsToUVQiJ+a0viw7oS7rObpl1qLgXFH5oK5ukz5nD3YdU1g3tY3ZG3II/S0mxN0zCyoh
 vkfWcijHxjcxKyKP8/56NonuwBg+CVDkb/ojJ4UbuODK6RxMpq7L9RoUXyLE531BlWsBPXby6
 pmU207PNrCV8yleQqk6Mv0GsjqwclKoXOYp4aA9wWTOwk4pG5E0+xnMTZ4voV22cnBkC1G35F
 BiNHjxM3/0Jk9H2wNCP4d6Zu2a4Bo25dxw2Pj4PiWVRN9U51MvAws5wg89K0fw1UEJ2uOe+x3
 qsEShtSDphm/g4ghtww8bi1ksrw1ymmRwV3xdmZTVJdzH0DMiWp2R+e7B4Xifv8X1LmpPUIeG
 Jyx7AqGbFlbxUxmsPG1UKyrqyqYqP5zLoQtQlqQPV5zRMZ7LsK+2TQec8QGP0rfe6sCDoNtG7
 xuniJwcPVIMbUONlrwPpLSlA1Ps4LxhIqgk0fV+0JP7W+O+Du0oLCpnmahVUiZ73wbOgBiuoA
 9y8I5HD9gJFJSY2Zx8w28BpeMG6/1Y1lm1xMWj1whM9yuBgafXL2uE52o2uV4w2cYsx1uc7A+
 /yDuU2CEUgvE3BetsXGb9Rl+Z4X5KcycD5Tz36ao/OZ1M/GlrTtWcBEsJeVnAXKsIJhTUmJXc
 yaOUg5mMoAEnGtUEQ27O2MAglt5aIRKQ2Jge6UvoovMhMLr/yJ5QJBMHGrPPrBPNPdErxJNpX
 fYyDesK7LiJKGQTrLtiI/UHwI6NafyAvqkIvpctogD2ubWwLfK8Svr+SI++hKtGQFvkDd6dSG
 2yEjPgmpGSJ09OCRWt785IswDoZ5GYqYXKESa/M5aLNmzswqvkS+mRQBuwnHlWztb7FNnR9/H
 m0pOJ04p/IpCSmi9OHSHNmguGhJd0BIjGE/3f9QAv33woYzWJu984xPkvfE+3/2U17rCuX4BI
 /Ki4ildOojsPQG/tY6voptYtQBKpXFqi9hNrEhRPuacWDlYdyuyUG1tsPIC/grAJFq8L10622
 nGS+uDhrz7wiK4UsSd6nz2FYax27X+fw4p5eQVg==
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Fri, Jul 24, 2020 at 02:34:57PM -0400, Steven Rostedt wrote:
> On Fri, 24 Jul 2020 19:55:00 +0200
> Oscar Carter <oscar.carter@gmx.com> wrote:
>
> > > Which one of the above is this patch set for?
> >
> > This patch is the result of a warning obtained with the following:
> >
> > make allmodconfig ARCH=3Dpowerpc
> > make ARCH=3Dpowerpc CROSS_COMPILE=3Dpowerpc-linux-gnu- -j4
> >
> > And with the -Wcast-function-type enabled in the top level makefile.
>
> Looking into powerpc I found this:
>
> arch/powerpc/include/asm/ftrace.h:
>
>   #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
>   #define ARCH_SUPPORTS_FTRACE_OPS 1
>   #endif
>
>
> arch/powerpc/Kconfig:
>
> 	select HAVE_DYNAMIC_FTRACE_WITH_REGS	if MPROFILE_KERNEL
> [..]
>
>   config MPROFILE_KERNEL
> 	depends on PPC64 && CPU_LITTLE_ENDIAN && FUNCTION_TRACER
> 	def_bool $(success,$(srctree)/arch/powerpc/tools/gcc-check-mprofile-ker=
nel.sh $(CC) -I$(srctree)/include -D__KERNEL__)
>
> So, it looks like you need to be 64bit PowerPC, Little Endian, and gcc
> needs to support -mprofile.
>
> Otherwise, it falls back to the old way that does the type casting.
>
> If you are really concerned about this, I would recommend adding
> support to the architecture you care about, and then this will no
> longer be an issue.
>
> The funny part is, you can still add support for ftrace_ops, without
> adding support for DYNAMIC_FTRACE_WITH_REGS, if you only care about not
> having to do that typecast.

I agree with you. I will try to add the support for ftrace_ops without
adding support for DYNAMIC_FTRACE_WITH_REGS to the powerpc architecture.

It's a great solution to allow a clean CFI build and so, protect this
arch (powerpc) against attacks that try to modify the normal control
flow.

I take a look at the kernel documentation about port ftrace to other
architectures [1] but it is out of date.

If I try to do this I will need some help. Some info that point me to the
right direction would be greatly appreciated. Some advice about what
functions I will need to implement would be really helpfull. Or point me
to the right piece of code that I can pick as base point.

> My NAK still stands. I wont let an intrusive patch be added to the
> ftrace core code to deal with an unsupported feature in an architecture.

Don't worry. I agree with you and thanks for finding a better way to
accomplish the initial purpose.

> I would be will to add that linker trick to remove the warning. Or we
> just use that warning as incentive to get architecture developers to
> implement this feature ;-)

In my opinion it would be better to leave the code as it an make the warni=
ng
visible until this feature has been added.

> -- Steve

[1] https://www.kernel.org/doc/html/latest/trace/ftrace-design.html

Thanks again,
Oscar Carter
