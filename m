Return-Path: <SRS0=PtU8=X2=lists.openwall.com=kernel-hardening-return-16982-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AF2C352AA
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Oct 2019 17:35:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F86E2086A
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Oct 2019 17:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sc8vjSf0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F86E2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16982-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30599 invoked by uid 550); 1 Oct 2019 17:34:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30562 invoked from network); 1 Oct 2019 17:34:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DkR+fE6L2sgDUjb9CgwKBgObrTscXuIanUOIJWC29ks=;
        b=sc8vjSf066wnXkX6Cjze9udlmyEoo0gGf6/1UfJqElaYKyNO3+qcHs77ElQ6tuDOT5
         rP7FFEpqpEjTsgMaC1qu5uM6xunBLO/5qapu3uEZv/spLwtnX7u551lHafWcFNSIKmMO
         RwaUJP0NTsvD/KaLAMDd5gQ5P5A+7snr3BLuz4SB36ArXF6PTkRbfU2VJa1+Rs7yFjGu
         QYH7aFnKDGvHGeidqtmVUDELioO1u6SCGcn1wOuBq3AJhzINqu4eiLlgMZBbTMOy/nKz
         6AivHEjIoSxSHboZQ9PwQr2nc0wdGP4DqTiVr31IxC/cfS8+V0mwTx4dqbrGcmHKXrsd
         z4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DkR+fE6L2sgDUjb9CgwKBgObrTscXuIanUOIJWC29ks=;
        b=TTFoEpuJcYm4vfgDkgR71ofxzb4a0jNTJRI/vECLyK3toi5FUT/fAh7KE1COb4upTE
         uzKbAfqfCRfT7ZYYhKSni+zi7te7aKmqNVMvM7E+QrI3kB/cj1+8b1T2YYTX/xTjmuAn
         xdBbFHWc/vfQpJ4f+mD7d30nSmAKWizZGMDQJmO7AfkDzR8fuZYS/C5YqxBbajrt9nGR
         85zVR5XYqom8TZqXW3s4brYmONydv4qiV2QwIfHgCOYZWBZiCTkz96fS38F+ZFl/JKrO
         9/L392sVmm/PJvqzxV5eb9mFR1l5VjbWxJEL/qnw2Ag9XycHoxDevE1OXuoHn/nPyQVO
         cvwg==
X-Gm-Message-State: APjAAAWQScr8OnPk9u5+klnAMDs7Vul/B1NcOY3sNhQNav1x8yD1Nh49
	YWo6bTKrHds68VJte3tfIWF88b0U
X-Google-Smtp-Source: APXvYqxpVJPysBibVUA4sTiFRSfvW3igen469vrfWv2FiJx52gwHjIt0TZ+eYGaLBI0rz2+v5SOY+g==
X-Received: by 2002:a1c:f30b:: with SMTP id q11mr4739077wmq.57.1569951283318;
        Tue, 01 Oct 2019 10:34:43 -0700 (PDT)
Date: Tue, 1 Oct 2019 19:34:40 +0200
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 16/16] tasklet: Add the new initialization
 function permanently
Message-ID: <20191001173440.GC2748@debby.home>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-17-romain.perier@gmail.com>
 <201909301551.ECF10DFB66@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <201909301551.ECF10DFB66@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2019 at 03:52:19PM -0700, Kees Cook wrote:
> On Sun, Sep 29, 2019 at 06:30:28PM +0200, Romain Perier wrote:
> > Now that everything has been converted to the new API, we can remove
> > tasklet_init() and replace it by tasklet_setup().
> >=20
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
>=20
> If this is the last user of TASKLET_*_TYPE casts, those should get
> dropped here too.
>=20
> -Kees

Good catch ! I will squash the change to this commit

Romain

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbpWHxyX/nlEWTnf8WhIh6CKeimAFAl2Tji8ACgkQWhIh6CKe
imD+4hAAlOOKDXDwNjh3eRUG8JmO+vdVodOWJYvd0QZQ7DGccSZpP7SUmgfIWEy/
BafT9eyI+idpq6SBQQmDCU+jYUZoTdrry5XmbNqgEwp6xkCKpvRupTBa+nnNMH7j
qX0CHPnC1lZBExxiyutD1GcX6bvQDYWy8fB3zi629pIvv6Hd49e6tunzQbOahRjo
9xmZTHJDLYEXfoe6jbntT61R8ImfoBzNjiKW+Hy1t65EuOYKxdx6ma7FVRBnYNJb
D5cJKqWFyqUfAJJd/BdDXSm+wyGL/8cPxoHFX7DJMf9m4NSMYmHUABqvPj8EmbSo
ZBZ9vtkm0UbpE0BZ/kSIhJVTkCe945gXCbQfqt0u6o8bXO4Ksa7UShiG4YohaXTW
XUiy4ud9+yMI0yi57BEKcZEfDIG4IbZEFIoT62j37NLkLOwPd9zXJGLf6N7Fub07
5ouyniOvtz3rNBLHVjjqwM2Vp+iQF4OZXS4EoPbieBYn7QH/dTp4q8yujqdXyVfe
zanmFwkvaCnLEPFRNG0sKMO5qJt82AKMbRHuE8EHuRaWayK4MNeNmb1O0jz6gTor
eR1Mq+Sn6o03V2RR5h5qiubDXPCgqzmMQBIUWsDAmN3MzCqMqGCBVElS2FgEzSe4
A4oXfIN5pYN2lIfzHJZyRnm2kws5WwEMrf98LkW3zQQtiBD6U2k=
=E0Ou
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
