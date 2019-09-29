Return-Path: <SRS0=PJHO=XY=lists.openwall.com=kernel-hardening-return-16967-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FF8C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:37:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 19F6F21835
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cIdT3nTu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19F6F21835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16967-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13550 invoked by uid 550); 29 Sep 2019 16:37:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13518 invoked from network); 29 Sep 2019 16:37:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E46YZy3TrZ8ZBFkuyq07HXB3Vc5FgB+XcqBGjLDHbxQ=;
        b=cIdT3nTueCRa92StAMu+4f3hpMO1J+gQ9ZY3zaSmn8FwzU0PErsXyRWkDlPGToGQzF
         GLpzlWMHsmb1HfK2k/EBlABR8SoRqD8ZMqUlxapfkZUruSAEn/4wf0L51FjhWU8+kKEL
         vh9TxOvMueknhH68EhMpUBYeqzUfe2IG5Ns4INGgkOZwWDw6BtVaWDlrst3Zsqa2eASK
         GuRlBmuUKmxK4HpzwT3MzDuUGoO90W9LVWthTZCfA9AlE3Y7jn1IxLB2N2rRWQm3p7oB
         0VTF+H+DWzhJbVZ2ClEcXrlT/0MbWxvZmrqIKCDvcEUaxZmnVOUO/oEVPS1XVU57dHZZ
         6JRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E46YZy3TrZ8ZBFkuyq07HXB3Vc5FgB+XcqBGjLDHbxQ=;
        b=BorhBanEh4Q2bYKrCWqI8gjJycU/IjcJqZcHFVIiDS4sbl611Bun5IMJUwocaLyyXC
         L2hyudlpc1Lc9/hXg5aT1ffW62uX1P7DTEuXsk/ZbZZCR+Vk26epy3rltRstLpqZjJM0
         6/L4HKyYQm26lioHEi2MI033V6E/1RH0XoPgLgp4TAMQe7A/C9/wH0qmU7EdT7dJQBbA
         Y3AEkB9v9DMbXKVu4/FK1P4HmK/P3YVmkTKJzOlaG6ZRVwZzs70+T8FwxPAFrMcEfCw1
         UmQe+0xAhfGGm1iMtfS7goN8spOj0WV5VQzETSFj68vxq9oxQisHdeSRZeqaizAHF/QQ
         itfg==
X-Gm-Message-State: APjAAAU+ze3+ZmrFlUuHdw6xNCZoI0PFdhBHF0MOOzH4YhrjHykfVILz
	AJ5jCbGQ3Ns1ak3xE2MP4Mg=
X-Google-Smtp-Source: APXvYqy61Aj1Ak0ngcr1BxEYBjOKOIMAwRgqstO1x+CjNFfxKeU6PR1YvHta7NAQc99PWAFF6vrR0Q==
X-Received: by 2002:adf:f401:: with SMTP id g1mr9951710wro.275.1569775033566;
        Sun, 29 Sep 2019 09:37:13 -0700 (PDT)
Date: Sun, 29 Sep 2019 18:37:10 +0200
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Subject: Re: refactor tasklets to avoid unsigned long argument
Message-ID: <20190929163710.GA9807@debby.home>
References: <201907020849.FB210CA@keescook>
 <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook>
 <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
 <201907221017.F61AFC08E@keescook>
 <CABgxDo+FSk0Tkvu=uFd5tjd+6TnnkwxwrP1a0QLBSkhhJ4CqUw@mail.gmail.com>
 <CABgxDo+ys-84ifkAMQp2Snv2PV4yTEYwi+3Jj9aGARn0hbhuWQ@mail.gmail.com>
 <201908081344.B616EB365F@keescook>
 <20190812172951.GA5361@debby.home>
 <20190829181321.GA6213@debby.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20190829181321.GA6213@debby.home>
User-Agent: Mutt/1.10.1 (2018-07-13)


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi !

I have realized that I did not answer to your previous email (I was sure
that I did it... my bad). Thanks for all your advices.

Well, I have just sent the whole series for a "pre-review" on the ML,
it will avoid common errors, once we agree on the series, I will resend
it to the right people directly.

Sorry for the delay, I was busy these last days :)

Regards,
Romain

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbpWHxyX/nlEWTnf8WhIh6CKeimAFAl2Q3bAACgkQWhIh6CKe
imDHJBAAqLeeGD92V3Z5ZLBrJutsQxxne7IR8KVNDomTYQV8UTp02b0OAZCFykvC
Ra8P2STuZBafbI4vL8Gp0X0ESQPvPfXJr5ZtLnC73wSPt+Oi9ft08H9mEgeYtAZs
FwAUsfPXz6PC8deyE3jgElr+YNGupBrkjmJiDdC1in1ccchGCglyCA1lbcKjLT1/
1wkjO70cu9/QgN9y7MGP29AvA54qbIPoxJV3k4Hw+7pEY9603TBXSC8t6r0omubz
uSFAehA50d+jTcWACvZ74J33X5mWQnX0cl9I4iO56fM2VObsk0pO4gwuhHyH6DqI
0434RkoOFHBnVUrh6ZDFvFK9MdLL0c0HquhGZGv1lnaLrzDEb1B0Ss5RT5MoR8pI
4cVlKO/6alOy17mjm3J5uyPWx/JpqM0msSB627qxdFlz2STHIMEClCuFnEoSFt9o
+z+d3fddwPBSLH7/Kprp1ear8MsSw2W8aVf2NDrUW6BC//FPvtVQpR4yLjCsDk3Y
A4ZNhe/ULhFWzb1H82KmtRJJ8BqLISvs756DP2iZlcZqjM91UKcb/3gC5BiFFoHd
umn693AlaCalQUXA/EzcpgeVrB2oO5YWN5FlbE+38q1t/+TMIZ0w8qbz3Bfzc1lO
w0UQeczg0IDYyhCAFXAsDyqbo/dbPyH5+LouYUbkKg2LsTzPGyc=
=/HHR
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
