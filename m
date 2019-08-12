Return-Path: <SRS0=Pi08=WI=lists.openwall.com=kernel-hardening-return-16784-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076C9C433FF
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Aug 2019 17:30:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 272DF2067D
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Aug 2019 17:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MnBdvzRL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 272DF2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16784-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23561 invoked by uid 550); 12 Aug 2019 17:30:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22498 invoked from network); 12 Aug 2019 17:30:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l+kXBI4QVPHx2gqCFYojQa0ygFH89PXh0aVXSQ3w2zE=;
        b=MnBdvzRLlobwFJshbap6fIn/Vq/NqcR9wkhrvoHKWuR19FxUMOT6Jx8DEcpw5qhkRx
         8ubFR3PCEtN3yNQx8vlNEhJe4xfYqAyRsJvOd4GHnt5mvzJu6TuL7TDZJXKvxPY7REwi
         xsQbJh4KNDukSbLvj+uEavVGYg6bbbzD+f1CCuHboWC925XiEqSMvCGMj5pZqU+j4uSH
         MJVxmXUq8SmyP+fRHCIOOCkBRf9cqyxQ5HdQZqP/afg9Hjnhh9lvsGH23e/M8UvtXuwu
         /iRBs5BJWumo7FLminKWfPt3eJo60pRL4HGxuxjlFj01JDa7gl2gzngaRNLiIjnEuEGX
         J2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l+kXBI4QVPHx2gqCFYojQa0ygFH89PXh0aVXSQ3w2zE=;
        b=VR/zNs5Nz7QbNrsD34oGmhk3nT7P7tyWNTB7Ur1ZEHsoTH9SLBSdbzM0fQ+y3+KccK
         XYHvjfZMAJua5zwZaW0MlWMfcP8RSppvKj3B0H/f4gGsGEbyrqe0GHe/kY2uufNxsLO7
         1NtqjMwNxSBfG6aIYf67c5YBQKCMby5grMU4aYd90O3oisHGj1zvnG3zgms0+t+2ttRq
         FgqQ50HzIsqjPctpUK1EH8fLMrfwcuronCPNUF7JF3ENrk8N41VEMrCSmYs0HP59/coN
         /W+hKEoxdgzvDQpr3oWtHkm/iK2gdUmzi7p2KknusdLA2q2EFk7TfhtpqkpAWA6dR1p3
         wVog==
X-Gm-Message-State: APjAAAVq5+UQ+frAM1B0rAK+rTUEtCX1lTyoWK4f9v/tNRSyK3cOAaSl
	KrGDtOwOWFqk/ICS1BZqBjc=
X-Google-Smtp-Source: APXvYqyrvsBevr8Du6A/n5KLf4hPN3YFNsK5aUd5i+ZVLFn3cH3AohvEo8vIytSkA+EGrukZiJhNZQ==
X-Received: by 2002:a5d:4a4e:: with SMTP id v14mr22965296wrs.200.1565630994543;
        Mon, 12 Aug 2019 10:29:54 -0700 (PDT)
Date: Mon, 12 Aug 2019 19:29:51 +0200
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Subject: Re: refactor tasklets to avoid unsigned long argument
Message-ID: <20190812172951.GA5361@debby.home>
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook>
 <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook>
 <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
 <201907221017.F61AFC08E@keescook>
 <CABgxDo+FSk0Tkvu=uFd5tjd+6TnnkwxwrP1a0QLBSkhhJ4CqUw@mail.gmail.com>
 <CABgxDo+ys-84ifkAMQp2Snv2PV4yTEYwi+3Jj9aGARn0hbhuWQ@mail.gmail.com>
 <201908081344.B616EB365F@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <201908081344.B616EB365F@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2019 at 02:02:52PM -0700, Kees Cook wrote:
> On Thu, Aug 08, 2019 at 05:47:29PM +0200, Romain Perier wrote:
> > Le mar. 23 juil. 2019 =E0 10:15, Romain Perier <romain.perier@gmail.com=
> a =E9crit :
> > >
> > > Le lun. 22 juil. 2019 =E0 19:19, Kees Cook <keescook@chromium.org> a =
=E9crit :
> > > >
> > > > On Sun, Jul 21, 2019 at 07:55:33PM +0200, Romain Perier wrote:
> > > > > Ok, thanks for these explanations.
> > > >
> > > > (Reminder: please use inline-context email replies instead of
> > > > top-posting, this makes threads much easier to read.)
> > >
> > > Arf, good point. My bad :)
> > >
> > > >
> > > >
> > > > Looks good! I wonder if you're able to use Coccinelle to generate t=
he
> > > > conversion patch? There appear to be just under 400 callers of
> > > > tasklet_init(), which is a lot to type by hand. :)
> > >
> > > Mmmhhh, I did not thought *at all* to coccinelle for this, good idea.
> > > I am gonna to read some docs about the tool
> > >
> > > >
> > > > Also, have you found any other tasklet users that are NOT using
> > > > tasklet_init()? The timer_struct conversion had about three ways
> > > > to do initialization. :(
> > >
> > > This is what I was looking before you give me details about the task.
> > > It seems, there
> > > is only one way to init a tasklet. I have just re-checked, it seems o=
k.
> >=20
> > Work is in progress (that's an hobby not full time). I am testing the
> > build with "allyesconfig".
>=20
> That's good -- I tend to use allmodconfig (since it sort of tests a
> larger set of functions -- the module init code is more complex than the
> static init code, IIRC), but I think for this series, you're fine either
> way.
>=20

Oh, good to know (I did not know allmodconfig). Yeah I think that it is eno=
ugh
for this series, but that's a good idea for the other ones :)



> > Do you think it is acceptable to change
> > drivers/mmc/host/renesas_sdhi_internal_dmac.c  to add a pointer to the
> > "struct device" or to the "host", so
> > renesas_sdhi_internal_dmac_complete_tasklet_fn() could access "host"
> > from the tasklet parameter
> > because currently, it is not possible.
> > from the tasklet you can access "dma_priv", from "dma_priv" you can
> > access "priv", then from "priv", you're blocked :)
> >=20
> >=20
> > This is what I have done for now  :
> > https://salsa.debian.org/rperier-guest/linux-tree/commit/a0e5735129b411=
8a1df55b02fead6fa9b7996520
> >    (separately)
> >=20
> > Then the handler would be something like:
> > https://salsa.debian.org/rperier-guest/linux-tree/commit/5fe1eaeb45060a=
7df10d166cc96e0bdcf0024368
> >   (scroll down to renesas_sdhi_internal_dmac_complete_tasklet_fn() ).
>=20
> I did things like this in a few cases for timer_struct, yes. The only
> question I have is if "struct device" is what you want or "struct
> platform_device" is what you want?
>=20
> +	priv->dev =3D &pdev->dev;
>=20
> You're already dereferencing "pdev" to get "dev", and then:
>=20
> +	struct platform_device *pdev =3D container_of(priv->dev, typeof(*pdev),=
 dev);
>=20
> What you really want is the pdev anyway in the handler. Maybe just store
> that instead?

Yup, this is what I have done after sending the previous email ;)

>=20
> Also, I think you can avoid the "dma_priv" variable with a from_tasklet()
> that uses dma_priv.dma_complete. Something like:
>=20
> struct renesas_sdhi *priv =3D from_tasklet(priv, t, dma_priv.dma_complete=
);
>=20

Mhhh, I thought that container_of() was only working for "1-level" (so
just take the pointer of the parent structure), indeed when you take
a look at how the macro is defined, it make sense. It will make the
code easier to read. Interesting... !

> The only other gotcha to check is if it's ever possible for the pointer
> you're storing to change through some other means, which would cause you
> to be doing a use-after-free in this handler? (I assume not, since dma
> completion is tied to the device...)
>=20

I think not in this case, but I agree, that's also preferable for this
reason.

Thanks for your feedbacks,
Regards,
Romain

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbpWHxyX/nlEWTnf8WhIh6CKeimAFAl1RofwACgkQWhIh6CKe
imAozBAAmGGyslm3B5VWQm/MP6Vz72jP+v/Xi2QdZqZgnYl6l+R9knB2jE1k6+Xj
S60CDMWWBApoPjgtdInsi2+Y6atolcVuQiKbFe5EXdOXAP4JdBcoYZc+Yv21Nxdv
tGC633/6fD8tF4wRFPhN0PuIg1zpS10XywBOGs2HQsxtkcVBCV32nZV+DROGns/j
d249rtj+1Lo5aixRfN277oGyZk0IGyOR3GNkrEEob4pDNFEebFsYrvvB3P1zMQW3
RGGOGz4pTIsjABw/U4U2+F+58j47jElqJHe1Os0XrwpG3z0ch+RKxfpQ3iLg3bvP
zv0ld+AGm55vp6wtF3MUvRcua5R1ey1kbqu6jYttbNPEvwT/Wiir6IaYEdVh5Y1r
X0QU2gfaxgqWsk1G+F9f1nVhW5iFluBUgON57m9GbHScsGVV9062ozV0gNP+SWAY
9Y9KwfrfTH2QfyMNcyjTC9OBjByvDHN2yCda7KgDq8cRxJVFNxsSINnqMoNfU/jm
B+H4SjmUDUd1/VpjnGe9wOfUDtnKnAz6S1wmestwMcgFzCKCYTp6qiQmoqGMMOZ6
ukVq3xZoXitBrSV2l7nbJuGoEXv0em5B7QoqM4M0Z1uHUQl5Ebrr7I6VCAAcHpr8
LJIjQQLhwBs4MCBDd1/PFkHF72mDrPvXTsvobIFJVuJNBP/8X/s=
=RFRK
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
