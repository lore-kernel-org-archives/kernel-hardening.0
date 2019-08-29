Return-Path: <SRS0=OyJ7=WZ=lists.openwall.com=kernel-hardening-return-16830-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CD4C3A59F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 18:13:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 56D3123403
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 18:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kky3igfS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56D3123403
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16830-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23889 invoked by uid 550); 29 Aug 2019 18:13:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23857 invoked from network); 29 Aug 2019 18:13:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NfE8HNvgGXWQTrXn04F3+d+D0AzmL7NNQYcx8s8Govc=;
        b=Kky3igfSC0gmXIVwTnJf5jylaMrnC+qXxHMhzUBOL8SDNpBXFrd5YCxmfBObtHDDhO
         qrYLFOU5ajfTjfqqGTq/ET6m6B+IuDsfXKvjTcCxht/bzN19EBjCJW1i/DJ7yZGSECj+
         PsHkkDMNOnjrc9hGROkzulcf4b58FuGqmWy5TY/CpPr2T+RuetAMUB3RjFCdOsyuW5mp
         cH1WyvgxZnoCXdePuBOK3QJ1ynINCP541i/6ZSCDjNXMeQvvZAfvbE5CE0g6gcYSFKqk
         cdHGkTPgJxV5c8JlxA7t/SekF86W1kswnSuXcN8eLgMU+r9nPOMST3vtMz2nokMUAW8J
         JOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NfE8HNvgGXWQTrXn04F3+d+D0AzmL7NNQYcx8s8Govc=;
        b=tg0Hsyw5UAqK9OiYFOYD9g6Ynahh5L7IBq/ndCZV87df/XuKvq6ruKKv0qkcVBoBWw
         J2jL/IUiZ1IAgHP+IunpoVlu/MyHbdPu/9bHDcLfnsCMRYfzOPBAmyDP5rHHa6M6WUAF
         O+Mzpz6HrbuvxuealQNIb6mx56MJRI1IhsPGtXYPn7/32E7dT2ZDyRi8/JGGg91aWMTs
         UV1zwvVBQ5gPRvxPdLa3Bs7cCxkZzPehYf/qtJnAvvzFr41YIRwg3HzLoLtoVRupigne
         qsJoFDW+r9YsR3JlJaplSi5ybmZq8sn3cp60bjLWXAa/m6H5ycbOFpkahDt2LuyI4kAI
         FieQ==
X-Gm-Message-State: APjAAAVUe5s5Es5IINd9ClA9ngE2F+rgGE/S1qZRe4+UVM+djZ+CH31s
	4IZXNudGq2AQ+NauruZj89I=
X-Google-Smtp-Source: APXvYqwJW0rS5Ixzr44jt/vNU3fckd/JJFOccXKdX6vax6AKGGy9dF3nPsvfSfHaxMftDaF3ekbSSw==
X-Received: by 2002:a1c:1b58:: with SMTP id b85mr12128114wmb.95.1567102405013;
        Thu, 29 Aug 2019 11:13:25 -0700 (PDT)
Date: Thu, 29 Aug 2019 20:13:21 +0200
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Subject: Re: refactor tasklets to avoid unsigned long argument
Message-ID: <20190829181321.GA6213@debby.home>
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook>
 <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook>
 <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
 <201907221017.F61AFC08E@keescook>
 <CABgxDo+FSk0Tkvu=uFd5tjd+6TnnkwxwrP1a0QLBSkhhJ4CqUw@mail.gmail.com>
 <CABgxDo+ys-84ifkAMQp2Snv2PV4yTEYwi+3Jj9aGARn0hbhuWQ@mail.gmail.com>
 <201908081344.B616EB365F@keescook>
 <20190812172951.GA5361@debby.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20190812172951.GA5361@debby.home>
User-Agent: Mutt/1.10.1 (2018-07-13)


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2019 at 07:29:51PM +0200, Romain Perier wrote:

Hi !

https://salsa.debian.org/rperier-guest/linux-tree/tree/tasklet_init

It is mostly done ! I have just finished the commit for removing the data field
... and... I have completly forgot the macro DECLARE_TASKLET() :=D . Well, it
is not a big issue because there are only few calls.

What I can do is the following:

1. After the commit that convert all tasklet_init() to tasklet_setup(),
I can a new commit that modifies the content of DECLARE_TASKLET()
(pass the pointer of the callback as .data) and convert the callback of all
DECLARE_TASKLET() for handling the argument with from_tasklet() correctly

2. Then the commit for removing the .data field in the tasklet_struct
structure that also removes the data field in DECLARE_TASKLET() (without
changing the API of the macro, I just remove the field data from the
content of the macro)

3. Change the API of DECLARE_TASKLET() and update all calls in a single
shot


What do you think ?

Thanks,
Regards,
Romain

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbpWHxyX/nlEWTnf8WhIh6CKeimAFAl1oFagACgkQWhIh6CKe
imDRpRAAtKZGylVyGH/EP+AwTJBegNSnr9xp1sHX6vwvKag1wshRzqrk0kRjOxXC
PkJKcnfSLhkeweGM2gjuouG1pSD2lzkNq6e+vKQ/wmbddJE44nq8zCAtEXNugCnA
NjGK+TV1w6EkEqp8tkZLQievaC+IWEzr32WI0P5V0i8onhKyUdw6+zjWJIURZUQN
2OfnIjQlyl8Y3chHqW0sWIiAtpTU2omQVBehWNaNV37EXslI/4DvOq1PLegjOfhz
QbSfSfb8oErZF6bEi1vxv47ZZKw6zEfUwi4TsTnc1NYYb6niKn4+URm1YCthcblO
D6nJ6iX/aozvoWgMteUz2TbPL58oxH4c1fbkIXFwEHReG9pNVTvxDEJsPMeuFPUa
SL4I3mfJJNMJXBZhdxwEPGWcupxH1EL00yngTjYUbdWH18N8Bl5xyjBmvot8qaME
t7gJVVezS8K85NnC2D9K6nU/x6LbO0BEacAuFWvxa77agCcAYcq/U4bKPFRZyrvO
iaoMFO6bLV2u3NIs0RBrgYzDADDBT3BSv986GK5mw8QTPyE1Y3wUclcXiwKOdisx
OdCt2ofKOWsbtHHkCxW0ZnSzN0/a8KYWBQhoNBL1uA5szz8szB/ERXS/kJx6VYBF
pdQQ31Hri4D35PMIS9hzYvPgpzE2A861dNoWq0wKRHRv990blrk=
=JlT6
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
