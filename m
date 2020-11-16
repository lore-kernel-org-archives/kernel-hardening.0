Return-Path: <SRS0=sKgP=EW=lists.openwall.com=kernel-hardening-return-20403-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40368C63697
	for <kernel-hardening@archiver.kernel.org>; Mon, 16 Nov 2020 21:26:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 084E120A8B
	for <kernel-hardening@archiver.kernel.org>; Mon, 16 Nov 2020 21:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 084E120A8B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20403-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32660 invoked by uid 550); 16 Nov 2020 21:26:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32624 invoked from network); 16 Nov 2020 21:26:22 -0000
Date: Mon, 16 Nov 2020 22:26:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v22 01/12] landlock: Add object management
Message-ID: <20201116212609.GA13063@amd>
References: <20201027200358.557003-1-mic@digikod.net>
 <20201027200358.557003-2-mic@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20201027200358.557003-2-mic@digikod.net>
User-Agent: Mutt/1.5.23 (2014-03-12)


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> A Landlock object enables to identify a kernel object (e.g. an inode).
> A Landlock rule is a set of access rights allowed on an object.  Rules
> are grouped in rulesets that may be tied to a set of processes (i.e.
> subjects) to enforce a scoped access-control (i.e. a domain).
>=20
> Because Landlock's goal is to empower any process (especially
> unprivileged ones) to sandbox themselves, we cannot rely on a
> system-wide object identification such as file extended attributes.


> +config SECURITY_LANDLOCK
> +	bool "Landlock support"
> +	depends on SECURITY
> +	select SECURITY_PATH
> +	help
> +	  Landlock is a safe sandboxing mechanism which enables processes to
> +	  restrict themselves (and their future children) by gradually
> +	  enforcing tailored access control policies.  A security policy is a
> +	  set of access rights (e.g. open a file in read-only, make a
> +	  directory, etc.) tied to a file hierarchy.  Such policy can be config=
ured
> +	  and enforced by any processes for themselves thanks to dedicated syst=
em
> +	  calls: landlock_create_ruleset(), landlock_add_rule(), and
> +	  landlock_enforce_ruleset_current().

How does it interact with setuid binaries? Being able to exec passwd
in a sandbox sounds like ... fun way to get root? :-).

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+y7nAACgkQMOfwapXb+vJFfQCdHLSXWQS49bTl69HbD8dnhWOY
ddEAnjooP/7zpi9Jvz2z3cUDPwsLBIua
=fSBm
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
