Return-Path: <SRS0=Wifo=AV=lists.openwall.com=kernel-hardening-return-19282-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160ABC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jul 2020 15:21:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 61E952065D
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jul 2020 15:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="IiyV/6kj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61E952065D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19282-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9733 invoked by uid 550); 10 Jul 2020 15:21:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9692 invoked from network); 10 Jul 2020 15:21:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1594394445;
	bh=IwTd6axjUykRPNOqnxq1T8INyLFtH4Grahn4QNilSIY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IiyV/6kjkH3p89Vqdcea131zUdn9e34AvyYLqul29i8n3OewYzMUQPSaAYq+mKx0g
	 qRT7h8fpEin/AOQKIM1D81dhUL1jo3orZvfF5ny395Xfn2hNnYZZqtdUsmAXakBUYM
	 Ta9mDhOuebH3gbKq09HFuzthzrJxp5O/9dmSEC9A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 10 Jul 2020 17:20:24 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: Oscar Carter <oscar.carter@gmx.com>, Kees Cook <keescook@chromium.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] firewire: Remove function callback casts
Message-ID: <20200710152024.GA3305@ubuntu>
References: <20200530090839.7895-1-oscar.carter@gmx.com>
 <20200708130628.GA21753@workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708130628.GA21753@workstation>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:NXOytpk85GGVi2EnBsjBjoJRKIjmWxRVO9BFlQb88DJo4bolwEQ
 vJlfsHetbkUzntLVvbSdJ7BPm7lucP7k88RrGtbyKFzirFQlLkGPcAgOq2jED7UYt3CZKgV
 QWJo8yzPSrWfqjp3wjSixQi6aHWnWKy0qgIauL2EZb4V8wME7v6/t2kvM4GEsVNsPL7RVxI
 mOOGIm1/q555Wckac+/xg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cprC2WU1qiE=:g5jM+UtJlALXvgDapZSWJW
 y2Vg03TXGW8JcjxyvkncCzBEjctPVHWdf7QJxWOmMGjPLwpy8hBTpzZuLk9d9cHzMb9mq6v/+
 yIOb1Hlz3Eof2ItGQju+EWGUv/R4WkD1xC54pa7hkQm+dTFM/bGYz7Z6gDVsDhlpNCgX5p3Pm
 rGVw2r9Ug/WxrnWW0cuyMf6UP1BFpkhX8Qn+X2QZhqECj3cUW9bcIVfKKqFS0YYMtTRt0iuq+
 SvncdleCVJMHmng7n668wfGIQDrA6LVA7+E+z5JSjsWpZ6iZDDKpxIgSh8C5UQS0my4Ycdtla
 /cwNW7iVtvSJ2fgny+CRAr0WaU7Je6KEmJ28nvWdOWzV97D4ryksdbUJouZohvQ0tHg4ROx1i
 cn2ZEPlfgJmSzDYCp1G2ZEeikjHfOoT3QMFNjYulQicUNiNIuZ4llXeDVOr8QK33P7pTKQTbS
 ppApIZu1Ev1PLIDrCr55gES7r/kv6k0Gd7rrDVhsfIYcg2yCNsVpUlZl+kSgN0WnWnxda2oVM
 9VqOK3ZR9I/jC1Ih7VOSEfIWJKm+3yn+39ZTI8hHk8Uu9YAsm2rz1nnO/p3P0sEG+ud/9vkUd
 ijYrb9wiuy1ogJ5BR7CH1Upud2xvLD121FuCMYhUTHAPZTivwyE+eGplJBBFuZCOOi9cAelO7
 LRuXGgHcW17FMVz5rj2W04G44WXsEWXfy72vPPl1sE1A3HlsGl7ktP3ySKhd+OOrx+O5BoXwc
 auoI95ZP6L6FWmeO0QMH4e88HuFxNYWCDKUV4f8c7W5LIhKLHBCGr4vdW0hC9sltiOU5iODMn
 sWpVPR/XZKMmqMXzOG5kMllrRUp4DoNgOz10GRWrfAgGB+u0tUxsoKzDKcN+3Sxm6Vjwk7Iu2
 d8vvZARPL0fuPn1pRPrvj2wJOLk9WPSTSp2KnWEDuFWjxRMPQNflAjXP2M1dBuq/yuoyNd/FT
 mtgRi9gsvSzYMAs4k9oJbOTQGEyLJq6nCQqEKGN+KKbwijMRKReoCE6x4JYUSEmSIQXDecopH
 aQbue1p/3V0tXxMI1UyXGkL+nuZAhlo6+XlP2PFdMHAcFpkSPql1l+bD1ZAOS7/7R5PcXz4AL
 C+1DeW2nZNf+l3tWAoepmD5b/Yr4mDQsIx2sW3ijyHg17nA+0zWyYQ/H78RgifNTO3DpGGVsE
 WmINZ0mM4XBMTQnbwYtWIS6Ub2bB5VPgzsk+w2rJNpLBzQF1z1kX03yX+SN1iLvxfu7h1O07s
 66DlNnCNC5yb2iySX1vISn9b/X8KRhEaFyoH36g==
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

On Wed, Jul 08, 2020 at 10:06:28PM +0900, Takashi Sakamoto wrote:
> Hi,
>
> I'm sorry to be late but I was stuck at my work for ALSA control
> service programs for audio and music units on IEEE 1394 bus[1].
>
> On Sat, May 30, 2020 at 11:08:39AM +0200, Oscar Carter wrote:
> > [...]
> > Hi,
> >
> > this is another proposal to achieved the goal of remove function callb=
ack
> > cast start by me with the first [1] and second [2] versions, and follo=
wed
> > by the work of Takashi Sakamoto with his first [3] and second [4] vers=
ions,
> > and the code of Stefan Richter [5].
> >
> > The purpose of this third version is to put together all the work done
> > until now following the comments of all reviewed patches.
> >
> > I've added the "Co-developed-by" and "Signed-off-by" tags to give cred=
it to
> > Takashi Sakamoto and Stefan Richter if there are no objections.
>
> In my opinion, it's no need to add my and Stefan's sign-off tag to patch
> in which you firstly wrote even if it includes ideas from the others ;)

I would like to leave it as is because most of the work is based on your c=
ode
(Takashi and Stefan).

> > [...]
>
> Anyway this patch looks good to me. I test this patch with libhinoko and
> find no regression.
>
> Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> Testeb-by: Takashi Sakamoto<o-takashi@sakamocchi.jp>
>
>
> [1] [RFT] ALSA control service programs for Digidesign Digi 002/003 fami=
ly
> and Tascam FireWire series
> https://mailman.alsa-project.org/pipermail/alsa-devel/2020-July/170331.h=
tml
>
> Thanks
>
> Takashi Sakamoto

Regards,
Oscar Carter
