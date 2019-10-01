Return-Path: <SRS0=x3Vw=X2=lists.openwall.com=kernel-hardening-return-16981-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9CEECE587
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Oct 2019 17:18:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 13F2021920
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Oct 2019 17:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHqA7KYR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13F2021920
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16981-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24567 invoked by uid 550); 1 Oct 2019 17:18:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24535 invoked from network); 1 Oct 2019 17:18:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oJsU3pAtkGSldHQOsdRTn1lnw/CEins3bGqRCwhVBr4=;
        b=MHqA7KYRyCj2Xw+vJQ3ucLRrv1XXQEUo88DfxLNKZTh6qmpM/TnhaFjJRX+s3ivF8C
         Ee7U6v58GJgtYelefT1YTvZgX734Ta2CSJKOFk7J0ipRgw3I4PVBdXJM0CuP732t+a8k
         q3ItGUU2jvi3ODigBS8wYnoR1t9yuwpsOno5rvCreAUjosmW0YjjddCTjIi9qVVuPvZ4
         VQbCfZBEViOcI+DeNOi9SSVigCC8UgifFkzWESU2WyMI7SESuXCxMWIvCnnV7ir9w5Cu
         5y8xiSGdhfF3cjtKrcV4gHBifBkK2pBx3wefwjkbq+00hR5zhecvngY8fBlebkgTbm4w
         d7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oJsU3pAtkGSldHQOsdRTn1lnw/CEins3bGqRCwhVBr4=;
        b=EumM7VyQr5wlIxe2VxRwzaejHqMIEFroJ+yXhPtLDKm8m+3x8Ow/WFOcFVRa2FYWky
         XJ3XlWyzGxsaMiEoztqC8gyZ763t106m+wvMnb9A8VZyKl85purj+H2L9EE2H8RjO3Tn
         qVNQhHCuYsrISRPIRrT0xgpJXJTtqrsEEMMi4XEP4Rdc6ODCvhlbN/3liw1gZavooUEl
         z4c5utayvZ3cmStwnkVetrhapyc9EoinC9Wj4AT2eWybs/Htaxc8KNiMVfWD/g/EGxa0
         LQid8bTzGYIhss3cgr61645bSj0Mg/iovFdIHm/lUyRMuFumHze84qe79kZKodbka4Gq
         whlA==
X-Gm-Message-State: APjAAAVnhVtMTIOoTpE9fFpO9Xng4ORmek6YUy4VAwu9zh6b6fZT00jz
	1EtgE7mMr6j11zn8LKUr0rk=
X-Google-Smtp-Source: APXvYqzujlXEJc5V956AyazHPaMNvUO4gX9705Fuj5h4DDbh43jouRJORW+wAWB3N1t2iRhyKw8hcg==
X-Received: by 2002:a1c:9d52:: with SMTP id g79mr4493954wme.91.1569950311591;
        Tue, 01 Oct 2019 10:18:31 -0700 (PDT)
Date: Tue, 1 Oct 2019 19:18:28 +0200
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 11/16] treewide: Globally replace
 tasklet_init() by tasklet_setup()
Message-ID: <20191001171828.GB2748@debby.home>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-12-romain.perier@gmail.com>
 <201909301545.913F7805AB@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <201909301545.913F7805AB@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2019 at 03:46:29PM -0700, Kees Cook wrote:
> On Sun, Sep 29, 2019 at 06:30:23PM +0200, Romain Perier wrote:
> > This converts all remaining cases of the old tasklet_init() API into
> > tasklet_setup(), where the callback argument is the structure already
> > holding the struct tasklet_struct. These should have no behavioral chan=
ges,
> > since they just change which pointer is passed into the callback with
> > the same available pointers after conversion. Moreover, all callbacks
> > that were not passing a pointer of structure holding the struct
> > tasklet_struct has already been converted.
>=20
> Was this done mechanically with Coccinelle or manually? (If done with
> Coccinelle, please include the script in the commit log.) To land a
> treewide change like this usually you'll need to separate the mechanical
> from the manual as Linus likes to run those changes himself sometimes.

Hi,

This was done with both technics mechanically with a "buggy" Coccinelle
script, after what I have fixed building errors and mismatches (even if it's
clearly super powerful, it was my first complex cocci script). 80% of trivi=
al
replacements were done with a Cocci script, the rest was done manually.
That's complicated to remember which one was mechanically or manually to
be honnest :=3DD

What I can propose is the following:

- A commit for trivial tasklet_init() -> tasklet_setup() replacements:
  it would contain basic replacements of the calls "tasklet_init() ->
  tasklet_setup()" and addition of "from_tasklet()" without any other
  changes.

- A second commit for more complicated replacements:
  It would contain replacements of functions that are in different
  modules, or modules that use function pointer for tasklet handlers
  etc... Basically everything that is not covered by the first commit

What do you think ?
Moreover, the cocci script I have used is... ugly... so I don't want to
see Linus's eyes bleed :=3DD

PS: I can try to recover the cocci script in my git repo by using "git
reflog". And put the cocci script in the first commit (for trivial
replacements), in the worst case...

Regards,
Romain

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbpWHxyX/nlEWTnf8WhIh6CKeimAFAl2TimMACgkQWhIh6CKe
imADtxAArIrfCdVkX9t5jFAgGFvkUI0v3u3v3kQUareMHtER/ZQ5nFyC4WJLkWg6
SmV3SvMGiMDVMOf0Ri03BbS1yjPks2E51zTvXwD3w6DVLbo/rXZPPXiOsNK83BYb
HrOH9x1TM2KmsOMBozo1pGRILGdQbA8SoQ/1D+UJzlJMHaZxmct8bwDzWNlHo/xK
4RWjI2cYkFlnHeg2TKAf9BPiVDmWrAGgqGnnb3WGUxTDPt8nZpCfBuve+vs/rhGZ
zh3YTZEH/SJjZb7sxLHfxeLSi0uNbHbz/RCB62S0xM7CHGGy0+Q519pEn/6OujdF
AKQ/03ntV5mEArxW38dVFevUln64FqIwLoq3MvqPEtSXaiDf2xqMGqPCOAWTxupJ
9COKq2s0DWibKnfWI4iiY7srXhAzm6UvkfsbrKSBPhc7xn/gqFbwNjNCaOeVadhc
ugRfWE0yHRfdsrVHNkar2oeIg3hADT3oOgGc7YJzKj3nXtgHhHp5jznAyljQb/7t
K9ivOPGvTulHXmKejHinZkTcumBmkeUO80XvJ10SAayIO5MvCdxbdmwxSTXIWgn4
mjBsUY46z+nD8mM5AsCzNsM+Gfv9SOVMiHhHnaTexbGvZ9x6Z9rVBebm0M0mnT2Y
R+8GFOBHZa1P/e+j13VDglTQ2ePkjYvlioDyNnPZ83C+basVYzc=
=tVX0
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
