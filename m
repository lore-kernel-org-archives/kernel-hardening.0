Return-Path: <SRS0=9KNG=BD=lists.openwall.com=kernel-hardening-return-19437-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E381C433E3
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 17:15:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5EC44206F0
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 17:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="BH1RpB7Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EC44206F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19437-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21721 invoked by uid 550); 24 Jul 2020 17:15:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21695 invoked from network); 24 Jul 2020 17:15:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1595610860;
	bh=cv/SDR0kOcXEn9Fw/iBcj1piWhrjN0Exl+XnPA9RlC4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BH1RpB7QpaPIDkMWi70/rplClWt4XmcUdsoghyYHbM/ksvt3NcfxSmzteKwXvHd9Q
	 GqIW96s/rDXFztopxRcOynzc1/nAWTDieZXpCics37RkFTJ2QwL8BijL7reSfWdEbl
	 o2bO6fGLspZ6vNk9vy+elf2K7BuRdREPvaoIIkFc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 24 Jul 2020 19:14:18 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200724171418.GB3123@ubuntu>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
 <20200719155033.24201-3-oscar.carter@gmx.com>
 <20200721140545.445f0258@oasis.local.home>
 <20200724161921.GA3123@ubuntu>
 <20200724123528.36ea9c9e@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724123528.36ea9c9e@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:8mJAGBN69jsylqIUl4XfLkJ0qQx4OepHIZjmBvP8ebW13vJVvbD
 gRGLIW2zPT9VkV8Y3zkaZPnvM/AQJ/TPUGC034MMJtac+SlTuOOS0YUceTbPrXanaYdsHS3
 GtsFefuH7nNXe2TGU9Q5zMwfkWVYJWVMfa+ucVgKj7YF1HMi9S+Dy8rxQFS9G5wUar1bBTd
 hNRTel1dmZZGqq69NvIIA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6/RlyAQl3N4=:AF4CyxOALtHfjBrOCsKgIw
 r6l02g3SfHIj0w0ME5hSsD1+xJRABfLb2aQqNgpZt4u+/WVrrADR/Bu+/AFlzBgw6fiaecYeR
 GHVFvSFqs+LAhVDeiJENr7KH8RT27mKN2636z4f0PEzGpJJ+APBiy1sXxq4Vc/mDp8NdjcNf0
 BU7djhoRJSqM8JlNu/TmER3RkTzUqNaSYtpsoDAeZCQZGjMEGu0JojH0O51rGasVlcy6nAnN3
 h0JyCfV7THJ0tSD0ec/BizaXltosb4+gW9hAAJEeEGrSXI/2I8VTpK1EqfT5KoaOWlSagnULb
 b6MLJrUxmqSK0d5NAuoeHLgodA4P+1Dg1aMZmdG82nH46bZOj5Isoj4afB4rHvHQ3DfClUG+U
 7j/pALGd+tfv8p4Z3NoCr8/pZMNR0HJjedEcF1lGDVnzTZsIgt3uozXsn9VRQ9KYkOx7CxhTP
 ihqyaC3oqMFHpzX/1V2Nbux/2mYpUMdRL00mziaAMP5uvNgmxae+Kty26LuclueVc2CutBUcR
 NTQDlF2+9+zgYqvZsKmFpH3BuFXoxQyEHXEQ8DZ+0yeAQ8FAtQYXQG7b0zLykLohC1UQKvQjW
 XuIQrwiDisL6qxFsraljKTURnZX3KOBtdy6i/L3b1eZ/3cAuBTJ0pBbPjVLYFAPpVUk41wokC
 PHsuDyd6VoLgZFxeXEcLpLMZ+wJ7hdnM0mI73UeXvXMyPNZPqZNJgNjTazCIaGMEAZODH+iA7
 XwaPbH58ahKA0xGfdGnSnachpbe+k3kM2HKMnm03a9P2hYzqNgsnKkgbD+b8HD7gcZu3LgOiY
 DS89NQszfdV/ETcYkleVt/3H+GBltnPBHq0nF/o53O5N+Nyzl1gfiu+kIsVgFxkOYfIjP4YTG
 T1Cdu1dW6K5NcJ6EtKki21SHzTNFCIUg6+JwsIGZ4rjlQH71KVaaPvpmDrvouXTNXfK/z+5Vw
 X9ZiPp2808d6tLQPfBfjqM3DJs6AHiPwfl7ZVVhN7QUpixaakGDmNuvSzWRHECCSfGcY8gz7D
 lVdP0hkIOv6liZVWu7swaHouV3Xs07QLCFzHyBlvFRlg4I3LPq6B2E2oygjR5hF36IKGVnwZm
 zVOdYd44rB2hCu0JFbBEkhYjhdgWLJlQBrM2UQ5nnVh/tJm1uuLtwZZh0HMUlPXWw9n3ZSuZc
 uxqLXdfFoNzmKdjY+86IKmJFwTN+NXTbRcc+C9/7y54WW8c9hhLo9WyxJa0va0LJhu6A6Xoxb
 1lof539/B7Ftj289lKPOUmkc1ptwAptJokMVTIw==
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2020 at 12:35:28PM -0400, Steven Rostedt wrote:
> On Fri, 24 Jul 2020 18:19:21 +0200
> Oscar Carter <oscar.carter@gmx.com> wrote:
>
> > > The linker trick is far less intrusive, and I believe less error pro=
ne.
> >
> > If we use the linker trick, the warning -Wcast-function-type dissapear=
s,
> > but in a way that makes impossible to the compiler to get the necessar=
y
> > info about function prototypes to insert the commented check. As far I
> > know, this linker trick (redirection of a function) is hidden for the
> > CFI build.
> >
> > So, in my opinion, the linker trick is not suitable if we want to prot=
ect
> > the function pointers of the ftrace subsystem against an attack that
> > modifiy the normal flow of the kernel.
>
> The linker trick should only affect architectures that don't implement
> the needed features. I can make it so the linker trick is only applied
> to those archs, and other archs that want more protection only need to
> add these features to their architectures.
>
> It's much less intrusive than this patch.

Sorry, but I don't understand your proposal. What features an arch need to
add if want the CFI protection?

>
> -- Steve

Thanks,
Oscar Carter
