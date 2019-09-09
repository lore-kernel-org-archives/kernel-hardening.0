Return-Path: <SRS0=83I4=XE=lists.openwall.com=kernel-hardening-return-16886-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE85C433EF
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Sep 2019 12:28:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 80BC92084D
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Sep 2019 12:28:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80BC92084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cyphar.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16886-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28385 invoked by uid 550); 9 Sep 2019 12:28:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28367 invoked from network); 9 Sep 2019 12:28:27 -0000
X-Virus-Scanned: amavisd-new at heinlein-support.de
Date: Mon, 9 Sep 2019 22:28:02 +1000
From: Aleksa Sarai <cyphar@cyphar.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>
Cc: James Morris <jmorris@namei.org>, Jeff Layton <jlayton@kernel.org>,
	Florian Weimer <fweimer@redhat.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Chiang <ericchiang@google.com>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Message-ID: <20190909122802.imfx6wp4zeroktuz@yavin>
References: <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
 <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
 <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr>
 <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org>
 <alpine.LRH.2.21.1909061202070.18660@namei.org>
 <49e98ece-e85f-3006-159b-2e04ba67019e@ssi.gouv.fr>
 <alpine.LRH.2.21.1909090309260.27895@namei.org>
 <073cb831-7c6b-1882-9b7d-eb810a2ef955@ssi.gouv.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="no5u7udk75jfhvvn"
Content-Disposition: inline
In-Reply-To: <073cb831-7c6b-1882-9b7d-eb810a2ef955@ssi.gouv.fr>


--no5u7udk75jfhvvn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-09, Micka=EBl Sala=FCn <mickael.salaun@ssi.gouv.fr> wrote:
> On 09/09/2019 12:12, James Morris wrote:
> > On Mon, 9 Sep 2019, Micka=EBl Sala=FCn wrote:
> >> As I said, O_MAYEXEC should be ignored if it is not supported by the
> >> kernel, which perfectly fit with the current open(2) flags behavior, a=
nd
> >> should also behave the same with openat2(2).
> >
> > The problem here is programs which are already using the value of
> > O_MAYEXEC, which will break.  Hence, openat2(2).
>=20
> Well, it still depends on the sysctl, which doesn't enforce anything by
> default, hence doesn't break existing behavior, and this unused flags
> could be fixed/removed or reported by sysadmins or distro developers.

Okay, but then this means that new programs which really want to enforce
O_MAYEXEC (and know that they really do want this feature) won't be able
to unless an admin has set the relevant sysctl. Not to mention that the
old-kernel fallback will not cover the "it's disabled by the sysctl"
case -- so the fallback handling would need to be:

    int fd =3D open("foo", O_MAYEXEC|O_RDONLY);
    if (!(fcntl(fd, F_GETFL) & O_MAYEXEC))
        fallback();
    if (!sysctl_feature_is_enabled)
        fallback();

However, there is still a race here -- if an administrator enables
O_MAYEXEC after the program gets the fd, then you still won't hit the
fallback (and you can't tell that O_MAYEXEC checks weren't done).

You could fix the issue with the sysctl by clearing O_MAYEXEC from
f_flags if the sysctl is disabled. You could also avoid some of the
problems with it being a global setting by making it a prctl(2) which
processes can opt-in to (though this has its own major problems).

Sorry, but I'm just really not a fan of this.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--no5u7udk75jfhvvn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXXZFTwAKCRCdlLljIbnQ
EtYQAP92uUzYfjG2cN2Nhj9vRhmas2XNnL0JbyC5U6zyFRSNVgEAwyjwWaK6kTQb
EJallcqZNlIhaATVDcNFHXkpq0QtTQ0=
=Hxqm
-----END PGP SIGNATURE-----

--no5u7udk75jfhvvn--
