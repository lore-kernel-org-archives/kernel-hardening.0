Return-Path: <SRS0=D8x/=BD=lists.openwall.com=kernel-hardening-return-19442-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D29C433E3
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 17:55:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 57E8A206EB
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 17:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="bCaccUrn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57E8A206EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19442-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11488 invoked by uid 550); 24 Jul 2020 17:55:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11468 invoked from network); 24 Jul 2020 17:55:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1595613303;
	bh=bd7AfjvjsR5Qk3rBOb/BoQCvIxeYKyl8zxvU5zHcong=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bCaccUrneFucbaK/zbVzOlht2A5J/ALAIowZJFqBqm++eae7RE1xOOqTOqFd4gNHn
	 Q8WKBIYmGoJxWjWMvBnzc85X4MjQWTXgTGGHM/6I9P4bDYHyMPfGD1sm620yRp/z+X
	 gsJ0zKtRI5HK03a3WAFpZsQHQzkm8+Au+M204d1o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 24 Jul 2020 19:55:00 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200724175500.GD3123@ubuntu>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
 <20200719155033.24201-3-oscar.carter@gmx.com>
 <20200721140545.445f0258@oasis.local.home>
 <20200724161921.GA3123@ubuntu>
 <20200724123528.36ea9c9e@oasis.local.home>
 <20200724171418.GB3123@ubuntu>
 <20200724133656.76c75629@oasis.local.home>
 <20200724134020.3160dc7c@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724134020.3160dc7c@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:TZ1DP0On1XKZYjrBrZj4Y7milA9q+ptPxjNoL+TNYbViNPsNrmO
 pMU1XNJEJiNanv5f0voeZj2AR0wwXO1fZJ8NR+CMNGqLm4oBspFGZ0tPmPudni1kYPM2JOm
 RkL55fz1CfCzvfFs8xJW3nXAS+/isSVSXviJk0dzsXoAuQ8riytNUPL2dmOWIgip4XPU3KF
 Lh30lP6vYbcjJ0RnIiAcw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:N6C+JegwCJg=:o2+Jlr92h0aFOVMtUVSrfs
 KTl+twPvQlzX/dYn5OYT+zZXK7Wa9uJVPDqTHxFiHw3jr+sACywr/4PMYE2hxKV8STeMRlAlu
 FT/YIJ2UMu8vrCDFS6QOiiVBhtD+WbbH7b2tqpEEDt/ZDoJG0w3zpY1/5DbeIrg4g+oeb0P7v
 BGouCYPf63KpQXvpVcsldG0HwAE2knKPiJ1nYeD/k9lm5++grkQDXr0Qnbp+0L6CqhmaUTisa
 JdEPtuvduJBMv86DP2F8a+O3x2kzMocBz8k14Y88In23m3RLRkCOG04So22bePefWfFTu5z+Q
 V9uUOZKBD1L9MkQ20JxIEGJymiYc/VW6B6Crllf0Tpmta81OIU2UWyq7oxBn7MOBPw+nsvUVJ
 nYK07u3k+dNws1HhaWAFMEBiWJkMIAV1h0BzWGjYyDvP6HuEwnLy+OrHP8JMFA3CDXs2Kv87t
 xVlct0M7KzRwJRM2QPs4sTAeK2FXtCtFiEBTQVexSg3Ls72BZTOgbjp8hnwh/vWsddJNhMpRb
 hRaf+IoBFw0XTSXcFFaU0hznYBTHJmlC6xa/IdpZ2CgBd2QFabft+2jUkxRZ3v/lTJ57jQPC4
 FSEEa8WOEmkDI0SP/SebFsDus6R3XZSJRI8fq5Q54ESzzPW3sehv4J18KG69M2RItXdqzFwFy
 pUYyfoP7Qt+ntgyAnlqhoYtGbozld4RgucQMBVQEmmDjFCQUOopjraV7pj39D09DrLbfhTO1K
 03vJ2zntU2ToPDBuZVO8FJ6J9jkDPWi9Cfewz+16uR459iqj/JxWhLao0W0rphINBtChmJ9kS
 dsIf+7nBlUN5ppfXscG2uBETSLD/6G04PAz/CCw+8O+CD3Iu4o8aUOsa9IefRwNsr1hc8zXeA
 AJUlziOov5tnh8odBlzdN7h5D8N/8VYYCG+MUS7w7UHJmSubUFAyXI8yNlEP1tf83KTpvj2sO
 4C8IuFeM6epgQNTfAqkruL+qvkFCthCIk1VP0mZQpD73JshChISl6zBb3QXYUlx4FNGfsb3xp
 i9r0M1MCUc+iy5xeAqpdAlNoE612hOnTnk3freW3ujlg5NVQBSRuvkeci1968TAcvBgLRuEuo
 4HN4vPkrCY658wvuDYxMYhkvwzPFzGQWt+lN6nHhBVFNMKLkG/ZX2vCSsvmKaIjb3TYX8rh85
 S50qkH80dUAWHSGa0+r9czum2Zj3bjIBIB+D4dEDFjKmvbjVrIFo/bWIS6fGuqMDMNYo2TFrg
 7d0fsUo6WjBrtk1HaQiqfg2jUqhF2bIWx9B8/Pg==
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2020 at 01:40:20PM -0400, Steven Rostedt wrote:
> On Fri, 24 Jul 2020 13:36:56 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > Which BTW, is supported by the following architectures:
> >
> >   arm
> >   arm64
> >   csky
> >   parisc
> >   powerpc
> >   riscv
> >   s390
> >   x86
>
> And here's a list of architectures that have function tracing but need
> to be updated:
>
>   ia64
>   microblaze
>   mips
>   nds32
>   sh
>   sparc
>   xtensa
>
> >
> > All of the above architectures should not even be hitting the code
> > that does the function cast. What architecture are you doing all this
> > for?
>
> Which one of the above is this patch set for?

This patch is the result of a warning obtained with the following:

make allmodconfig ARCH=3Dpowerpc
make ARCH=3Dpowerpc CROSS_COMPILE=3Dpowerpc-linux-gnu- -j4

And with the -Wcast-function-type enabled in the top level makefile.

>
> -- Steve

Thanks,
Oscar Carter
