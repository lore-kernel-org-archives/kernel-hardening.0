Return-Path: <kernel-hardening-return-21595-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 17D05C4332F
	for <kernel-hardening@archiver.kernel.org>; Sat,  3 Dec 2022 08:51:44 +0000 (UTC)
Received: (qmail 1056 invoked by uid 550); 3 Dec 2022 08:51:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32765 invoked from network); 3 Dec 2022 08:51:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1670057477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cveCfaQdqG1vHDIGKoiHSh0Rw6hx4sOM3mA9zIYHxdo=;
	b=NGDv8yUfd0KqWoh+aA4BEna8ZOyFkrNadZ0TuW+5XpvT7mvGQYTIv6ulzPEzN8wdZRrk5s
	m27DzI1mkwUrzZnD4Gty2DX7eHlKSzYtfeZJv5aDSUmOSNVET176foo4L8Zo+qR8t6dSuJ
	fmu3phcCaZNr8q9MUmGRewy8N262e1llwX0bGBpiPzieknUhlUarx10xWE0kECBUMRdZdW
	xBGJhzMSaEPc+PuXcEPZBOZR82gljOvIN0cjsGk/+2k2z26BXqAF+WqhaieyFGiR5DJZlH
	l11Vj4uItS1GWlt2Pq7yWmIjdODvAfg/f2iS7Y/N3wbHeBsbHo6Dt9f9svOL7g==
Date: Sat, 3 Dec 2022 09:51:12 +0100
From: Stefan Bavendiek <stefan.bavendiek@mailbox.org>
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Subject: Re: Reducing runtime complexity
Message-ID: <Y4sOAAJPivaLNzt/@mailbox.org>
References: <Y4kJ4Hw0DVfy7S37@mailbox.org>
 <202212011520.F7FE481@keescook>
 <Y4mbqmsMjTA63SlP@mailbox.org>
 <202212021208.04CE21D1AE@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GKWtZWeVdIpczgEH"
Content-Disposition: inline
In-Reply-To: <202212021208.04CE21D1AE@keescook>
X-MBO-RS-META: 6ep5am96nkm35818b5mqnjxwy95s3wkh
X-MBO-RS-ID: 129047620a5f10884ed


--GKWtZWeVdIpczgEH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 02, 2022 at 12:13:48PM -0800, Kees Cook wrote:
> On Fri, Dec 02, 2022 at 07:31:06AM +0100, Stefan Bavendiek wrote:
> > On Thu, Dec 01, 2022 at 03:21:37PM -0800, Kees Cook wrote:
> > > On Thu, Dec 01, 2022 at 09:09:04PM +0100, Stefan Bavendiek wrote:
> > > > Some time ago I wrote a thesis about complexity in the Linux kernel=
 and how to reduce it in order to limit the attack surface[1].
> > > > While the results are unlikely to bring news to the audience here, =
it did indicate some possible ways to avoid exposing optional kernel featur=
es when they are not needed.
> > > > The basic idea would be to either build or configure parts of the k=
ernel after or during the installation on a specific host.
> > > >=20
> > > > Distributions are commonly shipping the kernel as one large binary =
that includes support for nearly every hardware driver and optional feature=
, but the end user will normally use very little of this.
> > > > In comparison, a custom kernel build for a particular device and us=
e case, would be significantly smaller. While the reduced complexity won't =
be directly linked with reduction in attack surface, from my understanding =
the difference would make a relevant impact.
> > > >=20
> > > > The question I keep wondering about is how feasible this is for gen=
eral purpose distributions to have the kernel "rebuild" in this way when it=
 is installed on a particular machine.
> > >=20
> > > Much of the functionality is modules, so once a system is booted and
> > > running the expected workloads, one can set the modules_disabled sysc=
tl
> > > and block everything else from being loaded.
> > >=20
> > > -Kees
> > >=20
> > > --=20
> > > Kees Cook
> >=20
> > Disableing modules in general will prevent quite a lot of functionality=
 that would still be expected to work, like plugging in a usb device.
> > One approach may be to load everything that may possibly be required in=
 the future as well based on the use case of the specific system and then d=
isable loading additional modules, but that does not seem like a good solut=
ion either.
> >=20
> > Perhaps exploring embedded device deployments is an idea, but in genera=
l the idea is to ship a smaller kernel to something like Linux desktops wit=
hout limiting functionality that likely to be required.
>=20
> What I mean is that we already have a good middle-ground. It doesn't
> need to be all (general distro) or nothing (embedded build). Once the
> workload for the system is known, load the needed modules and block
> everything else. i.e. set up a module alias named "disable", and then
> fill /etc/modules with whatever you might want that isn't automatically
> loaded at boot and end the list with "disable". I wrote this up almost
> exactly 10 years ago:
>=20
> https://outflux.net/blog/archives/2012/11/28/clean-module-disabling/
>=20
> :)
>=20
> -Kees
>=20
> --=20
> Kees Cook

This does look quite similar to what I had in mind.
Thank you for the response.

- Stefan

--GKWtZWeVdIpczgEH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEjLwAv8xLYF1doyZLdIuckz2DLQMFAmOLDfQACgkQdIuckz2D
LQN++Q//dvAhf+uwS0SA3mlylDAADGymjtWVSioO00FTWQ8OeAhhgA+2uhk0QzD+
d61jvt3gNLfdW/D5pesukit+9sId8zl51Q8MqOlQgmmWHXEA5rLDS8NsKSldX7UL
A8iJ4sutT3AEIm2LFX1jUGZ/g60rqKL3g3P2TyXXVayiIgtWUCE79LCdZXEJReqV
2i8i3LkMZgRzsHqvQHkQNY84wJc6hHLfmX065gW/1k2XRuyc5Xjh4s5/VfoI/Gc8
2tMDxATHQOD9k4R2ST/6QRn3BQryWEa2sXxwXkws+DvUKwJwVnvUqToocMP0H1Ex
75s+dTXGO8L40D4YcFDlQ+wBQGMBhUpd4rDY6jB4hAzPsLmYxnhFgzjgB6EBnb2Q
8BgGIq9rgxFtFOmWlrfKb/PrPqVs08CevI1tYPlfse636McahMBQLM1S6QwBvDcg
BTCSMoLMb3xC3eixPzjd8bGyZKr1qD19s51uU10d0ASa/jw4DZMj3ljhp83Ts5nF
ZvTu63oyJuNlLBPSAnoPyS3tkfNMDHrdRkv2HweDSQXNjXmi8v3ALSnbw7yk9AFX
ec4xabRCplEQF/qgtpKxZg216WJTgmhvOfjwFdiB+TaMQGxjyE75AZ75YqUeBvPI
TwvA6AGnZfBu1tW181nqDJ4YPKg/bZcF0wrkIYZSRK5oOFcqWuc=
=VOkn
-----END PGP SIGNATURE-----

--GKWtZWeVdIpczgEH--
