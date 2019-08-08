Return-Path: <SRS0=a3zq=WE=lists.openwall.com=kernel-hardening-return-16759-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD59C433FF
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 15:48:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CC8472173E
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Aug 2019 15:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="elH74zUd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC8472173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16759-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1391 invoked by uid 550); 8 Aug 2019 15:47:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1356 invoked from network); 8 Aug 2019 15:47:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qOGCEMCpTn5ZQE0V+/AO3HHpR9O4Ss/GAPyVSzlV65w=;
        b=elH74zUdEUMqB/Kjg2gw/5z8oNJcRqhoTTbOrQ9s/j3hXPA2gK8LCPdVKMIrscmdJa
         HOZgq904M9+/kf75EH2Wg9jH9Pav/kD2yAgbuIZvvLIlSzeUNYa64JWql1uk0SIN+99K
         HrI7RD9n+xYZhzcZd+f9Cs+QvpUTCaQWlALAJhu3h5azMmaMoUaCU7LTWwoxpZi6p0po
         8R3w5czmhF9vfj+OKKvx9xauv1gwRLOF4mLfEe+psGzLizXuEdcAPw62VJFm69uEzefR
         zc5n98fbvLJl3y4eX4xDnp3PXwrFEi/VpneOY50RRWhqqrwPVTqiQ+V3kOfnDDYkapjQ
         DPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qOGCEMCpTn5ZQE0V+/AO3HHpR9O4Ss/GAPyVSzlV65w=;
        b=Wb7eSs+15sNb1haltIwfA3NSBy8ffIEiqkCl8RpvLD12E4PgkA8qC1ULG9I3IOUD30
         QZrkjBozsm3WUQ/YLJml3iAAzyIAVe8bzIrXZlmyvt8W55aim9t/xZme92f+BfH3oxqf
         uuc63aZ4unY34xXO9cUIcKrFJqJrijwEc6ljWOZjJwcnLp/xsAz8yDUa9oy/InUcF49v
         5Ar//iUD/uFKGnHEo6fN+w7Hl9zqHeSpanaaR6Ap2FeFv0slWQwo4Y3FRghyde/WQeji
         AUF3UCKQXQ8PM2N1yhKViMzxx/Ub7J3A5j/lWxajBZ0vPHTDauV6ROluqAJeJUG5qnDI
         9ntA==
X-Gm-Message-State: APjAAAUOeL6dxgZQ499/KpaAgN2WfHKR8bpEdnIRK8XAiMthNmWFylrR
	aQltqPaSww8ZquzhlUrdLWUVirtQxw/eDeEVdHQ=
X-Google-Smtp-Source: APXvYqx4DvesM6HDnzJ2tXu8yTkQMHLf+lldf/SI6RjEcmrxAz/K+2p/dYN6KBs4FieuZQcZhBN7iMLPwXolkJc/DEI=
X-Received: by 2002:a63:60a:: with SMTP id 10mr13136234pgg.381.1565279261623;
 Thu, 08 Aug 2019 08:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook> <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook> <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
 <201907221017.F61AFC08E@keescook> <CABgxDo+FSk0Tkvu=uFd5tjd+6TnnkwxwrP1a0QLBSkhhJ4CqUw@mail.gmail.com>
In-Reply-To: <CABgxDo+FSk0Tkvu=uFd5tjd+6TnnkwxwrP1a0QLBSkhhJ4CqUw@mail.gmail.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Thu, 8 Aug 2019 17:47:29 +0200
Message-ID: <CABgxDo+ys-84ifkAMQp2Snv2PV4yTEYwi+3Jj9aGARn0hbhuWQ@mail.gmail.com>
Subject: Re: refactor tasklets to avoid unsigned long argument
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Shyam Saini <mayhs11saini@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi !

Work is in progress (that's an hobby not full time). I am testing the
build with "allyesconfig".
Do you think it is acceptable to change
drivers/mmc/host/renesas_sdhi_internal_dmac.c  to add a pointer to the
"struct device" or to the "host", so
renesas_sdhi_internal_dmac_complete_tasklet_fn() could access "host"
from the tasklet parameter
because currently, it is not possible.
from the tasklet you can access "dma_priv", from "dma_priv" you can
access "priv", then from "priv", you're blocked :)


This is what I have done for now  :
https://salsa.debian.org/rperier-guest/linux-tree/commit/a0e5735129b4118a1d=
f55b02fead6fa9b7996520
   (separately)

Then the handler would be something like:
https://salsa.debian.org/rperier-guest/linux-tree/commit/5fe1eaeb45060a7df1=
0d166cc96e0bdcf0024368
  (scroll down to renesas_sdhi_internal_dmac_complete_tasklet_fn() ).

What do you think ?

Regards,
Romain

Le mar. 23 juil. 2019 =C3=A0 10:15, Romain Perier <romain.perier@gmail.com>=
 a =C3=A9crit :
>
> Le lun. 22 juil. 2019 =C3=A0 19:19, Kees Cook <keescook@chromium.org> a =
=C3=A9crit :
> >
> > On Sun, Jul 21, 2019 at 07:55:33PM +0200, Romain Perier wrote:
> > > Ok, thanks for these explanations.
> >
> > (Reminder: please use inline-context email replies instead of
> > top-posting, this makes threads much easier to read.)
>
> Arf, good point. My bad :)
>
> >
> >
> > Looks good! I wonder if you're able to use Coccinelle to generate the
> > conversion patch? There appear to be just under 400 callers of
> > tasklet_init(), which is a lot to type by hand. :)
>
> Mmmhhh, I did not thought *at all* to coccinelle for this, good idea.
> I am gonna to read some docs about the tool
>
> >
> > Also, have you found any other tasklet users that are NOT using
> > tasklet_init()? The timer_struct conversion had about three ways
> > to do initialization. :(
>
> This is what I was looking before you give me details about the task.
> It seems, there
> is only one way to init a tasklet. I have just re-checked, it seems ok.
>
> Thanks for your feedbacks,
> Regards,
> Romain
