Return-Path: <SRS0=3lu0=5P=lists.openwall.com=kernel-hardening-return-18291-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4BFC43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 05:35:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EC29D20780
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 05:35:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="ItgV5s1o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC29D20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18291-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17504 invoked by uid 550); 30 Mar 2020 05:14:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16223 invoked from network); 30 Mar 2020 05:13:17 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 02U5D16L029460
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1585545181;
	bh=2O1PRZcRzehItdBq+SOYt2I5sthUecO3gWWhCXTRP/c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ItgV5s1o4ijSYa1K2aSUhMGnRvREUvcewwBuUuKGonPJp/d/ndjsjd3PoNpZ2pt37
	 /sxGb/Rmq3RPFD6nQ0S0Hin6nQrUN/FDt5EKsLvjKLNHmsIBwF4bwmwTSrh5BXU9ya
	 FWL58Ta1qFnMU7LivZGa0hK9QVcCBnDk/aj2TMUYgseywcGZ38qJVPOJWAquMJSik1
	 kIXd/yIHmoteF4dNdxF1lzJHSM5DczQG4VG23sqa3j8j7XevbrTZTCQU4xNEXMXY6y
	 v8sfKdqPWr+SNjpTfSFHCpYpNqdoJ9iG5P5c55l3j7aFxSAG8hZ+SryCUqUPw1POz9
	 E0TShu6uxSdwQ==
X-Nifty-SrcIP: [209.85.221.179]
X-Gm-Message-State: AGi0PuZOlaCDfo6gN+FB6gGFBB4oiKmOuivtjCaXbbUk961ETYCnjXg7
	F8rUsuGSK0j0XAyyGX1JY3bw+Eiv5r8wXRUXQys=
X-Google-Smtp-Source: APiQypJcTTfLrz6NE2CFD6TIOP+rr7KaoSnH4ArjXjaCsrK70EkFivm3Wt+pUVnSxQGtA3GXt+L3qFSo3zRkcifs0nU=
X-Received: by 2002:a1f:32cf:: with SMTP id y198mr6252148vky.96.1585545180610;
 Sun, 29 Mar 2020 22:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200329110832.19961-1-masahiroy@kernel.org> <202003292126.5105600A@keescook>
In-Reply-To: <202003292126.5105600A@keescook>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 30 Mar 2020 14:12:24 +0900
X-Gmail-Original-Message-ID: <CAK7LNARhnzxhMMD7b36s8u_DJ+XdU0p4RQpsjYpPxwjTU9P5ew@mail.gmail.com>
Message-ID: <CAK7LNARhnzxhMMD7b36s8u_DJ+XdU0p4RQpsjYpPxwjTU9P5ew@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: drop support for GCC <= 4.7
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Emese Revfy <re.emese@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Hi Kees,

On Mon, Mar 30, 2020 at 1:27 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Sun, Mar 29, 2020 at 08:08:32PM +0900, Masahiro Yamada wrote:
> > Nobody was opposed to raising minimum GCC version to 4.8 [1]
> > So, we will drop GCC <= 4.7 support sooner or later.
> >
> > We always use C++ compiler for building plugins for GCC >= 4.8.
> >
> > This commit drops the plugin support for GCC <= 4.7 a bit earlier,
> > which allows us to dump lots of code.
> >
> > [1] https://lkml.org/lkml/2020/1/23/545
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Thanks for getting this cleaned up! I look forward to the 4.8 version
> bump. :)
>
> Acked-by: Kees Cook <keescook@chromium.org>


Thanks for your Ack.
I will queue this up to kbuild tree,
and it will ease more kbuild cleanups.

Thanks.

-- 
Best Regards
Masahiro Yamada
