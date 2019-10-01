Return-Path: <SRS0=1j/d=X2=lists.openwall.com=kernel-hardening-return-16983-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F41EC352AA
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Oct 2019 17:48:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 75CBB2168B
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Oct 2019 17:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1v0ITgc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75CBB2168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16983-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3505 invoked by uid 550); 1 Oct 2019 17:48:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3473 invoked from network); 1 Oct 2019 17:48:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fOAIA7Cy4W5smr9/UkfFagPFJwt0COdozksV3xwOm3U=;
        b=C1v0ITgce47DM1dPl/7/C1YCEn25B5ZJP7Gtd3c7WAuI9QlT+9WeUYJA4LX+Peu2Io
         3Nh9QzJOQ5vE1MST39JUAtMxeH7Cxc1a1D8bigYH462EdssfZLmxPhCY9vSUHgkedpoK
         UjezTw1e5IPNtQflFxZB14ZWcAOVK1jdwAv/n67LJNwKArPYH2fS0BUkXfY6s7/89Vhh
         BK3bRI5rNkxm2YTmMJ4DEPN3T4JQRHi6a38F6n8rP2+JeV/e+cXoJpQJzCcOwyPydsyA
         Hhacx7/8z/Ig6Hk17RA71cgXHzrLJlG1adA5p+9nogyOpzyyyK3bpIH7/iEeix6M7VBE
         qeWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fOAIA7Cy4W5smr9/UkfFagPFJwt0COdozksV3xwOm3U=;
        b=sZd5MC8iJ4U70FWPdMC24MUC/xaF5/g9n5oem8jsCkA3hx/HXLcEjJdHseRe3hEmRl
         dLJ9z6GRxZ1YOHi2J4Mi8Sw7mY7rFdFvhFDgZEwhH1+40pauOJRyXPhoCHg/i2FDF16I
         7jMsuTYz7cmtCI/K55o5jjmUUNpZsB6e9PVjbeNKLLusXUm5tpa8TOvQ9CgHrh8G/Tt/
         aAlIMjGXvQ1YtmUlekkcm5j9bphXPKkQvFX1OvbVm5TQBZESGqi1jKxmrgCm+3652aqr
         wV0welSyPkYs6DHaCtfZoksRX/hsBIJ/yu/yZ+o3+h5K2ROtipa5/w9uJFiaLvYLozYW
         95VQ==
X-Gm-Message-State: APjAAAWZ4WyULemIq+FwiG/nTBeZ79XnlKdJdwSUsEjyqFZpyoSD0zDY
	ESTz81hZo+SwBPSTeruz9EE=
X-Google-Smtp-Source: APXvYqxQmUopcq4XStb9Ig5j0ikNcydgtULXTqmw0Cm/UTdIOx+SuEpVUxdKfSXTNkaRAZscIMVnJA==
X-Received: by 2002:a5d:5708:: with SMTP id a8mr18212835wrv.240.1569952075822;
        Tue, 01 Oct 2019 10:47:55 -0700 (PDT)
Date: Tue, 1 Oct 2019 19:47:52 +0200
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 00/16] Modernize the tasklet API
Message-ID: <20191001174752.GD2748@debby.home>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <201909301552.4AAB4D4@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WChQLJJJfbwij+9x"
Content-Disposition: inline
In-Reply-To: <201909301552.4AAB4D4@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)


--WChQLJJJfbwij+9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2019 at 04:06:50PM -0700, Kees Cook wrote:
> On Sun, Sep 29, 2019 at 06:30:12PM +0200, Romain Perier wrote:
> This is looking really good; thank you!=20

Glad to read this :)

> I think for easier review it
> would make sense to break out the "special" cases (where you're changing
> structures, etc) into their own patches (and not as a bulk change --
> they need review by different subsystem maintainers, etc).
>=20
> Then the patch phases can be:
>=20
> 1) Introduce new APIs and casts
> 2) Convert special cases include passing the tasklet as their .data
>    (while also changing the prototypes and replacing tasklet_init() with
>     tasklet_setup())

	=3D> So, one commit per driver for preparing the data structure to
	own a sub "struct tasklet_struct" + tasklet_init() ->
	tasklet_setup() with use of "from_tasklet" in the same commit.
	Right ?

	For example:
	the commit "[PRE-REVIEW PATCH 03/16] mmc:
	renesas_sdhi: Prepare to use the new tasklet API"

	would contain changes for preparing the driver to use a
	"struct tasklet_struct" correctly + convert the driver to
	the new API (tasklet_init() -> tasklet_setup())

	Same for commit "[PRE-REVIEW PATCH 04/16] net: liquidio: Prepare
	to use the new tasklet API".

	This is what you had in mind ?

> 3) Convert DECLARE_TASKLET() users to the same

Yeah, this is what you explain in reply to "[PRE-REVIEW PATCH 12/16]
tasklet: Pass tasklet_struct pointer as .data in DECLARE_TASKLET", right
?

> 4) Manual one-off conversions of tasklet_init() -> tasklet_setup()
> 5) Mechanical mass conversion of tasklet_init() -> tasklet_setup()

 See the reply to the commit "treewide:" about this

> 6) Mass removal of .data argument from DECLARE_TASKLET()
> 7) tasklet API internal swap and removal of .data
> 8) tasklet_init() and helper cast removals.

Ack

>=20
> Step 1 needs to happen in an -rc1 (e.g. v5.5-rc1).
>=20
> Then steps 2, 3, and 4 can happen simultaneously across all the
> maintainers that need to be aware of it and land in the next release
> (the linux-next for v5.6).
>=20
> Finally steps 5, 6, 7, and 8 happen in the next release's -rc1
> (v5.6-rc1).
>=20
> If we can get the "phase 1" patch ready quick, maybe we can get into
> -rc2 for v5.4 and move things up by a release...
>=20
> -Kees
>

Thanks for your time,

Regards,
Romain

> --=20
> Kees Cook

--WChQLJJJfbwij+9x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbpWHxyX/nlEWTnf8WhIh6CKeimAFAl2TkUcACgkQWhIh6CKe
imC/iw/6A9/+JCB7d9nSY7ISEa3tVKLYP/lrXvjnnWp+wFIvTvsX/d92fUKrfaA3
n03FW8ejdGHOB8J2R3chl1z+LtYu3fyalcHwWgQb7SYQjJz5nsHv6If5Wo7UuHDO
TegBavtl0D8huGg5DXdHs8TFJ+iZbUh2uATMDdXsYRbQA4kcERMnS++8jcUkwVes
ch1aB7n5pHRfxdW+RpxP6/GwJC0+ltNuq2sJz342SAIHOIcZJ03JBKbjVM5cDTT1
XCoUYq5F0NnQuQyW5kZ7kTJ/v3UYEDYWZ0hNc86tAhSx0AdyT+6SlBDpaxuYbh59
6gn6k16Lv+mOhLsPrNE0u4BI15iS0l/5DwToBY1PkElkJ6Rv7l9INx3kgp/XJc/r
hjcJvWCu+ZxQBX1gG34bT3uYWNS8cZGHlVY0CBHdU1Pa4Onb7g/Hkz1l/Tw5NCc7
GrkpfbpGDeT0BAJ/Ty7k7hPykqTIblT/w3Cw5ll/7ZkvyTrzf/DEmRylzVmKKzLv
heawIHf5yvkZRyEiKuKgJtvpKfOTlM1lEhRGUDm+ROYYbEoeFuhJJSb4cPJjD+3V
u44LZ1oPTxzXwQZLSNRk5KQjBB5Rdoqd7gkA0dc8mytdCRaY0Wu7Vpy6v6G0pE2O
/+qo4uir9WHyp99dwaP3VwEv5+BdtjS0ptIsrXsZKvgPWdFzzyw=
=qCjF
-----END PGP SIGNATURE-----

--WChQLJJJfbwij+9x--
