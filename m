Return-Path: <kernel-hardening-return-21990-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 87ED5CA0FED
	for <kernel-hardening@archiver.kernel.org>; Thu, 28 Aug 2025 00:14:49 +0000 (UTC)
Received: (qmail 7925 invoked by uid 550); 28 Aug 2025 00:14:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7864 invoked from network); 28 Aug 2025 00:14:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
	t=1756340067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7PK3Ez1Rfnej7jNOPYQs5y3Mm6w6Khoe08rct6ODjuA=;
	b=ko6VF2kAjcFV7/loAFG3DijKDdEZnWAtqyqZx+AM6VAnZjb1ZghYykty/sdRM4Z84qHq7G
	Vt+lgdCqKZkwdNjUQkGH5Tt3q5zsG5t9TFRidcCvLdRy93pl5L1y1mPIyvpYl7/XsyvEPb
	4W1bn1ZNCnyPWikIrT9pwa/G8ySTKhRBr0b7NM90oYn2k3dqdpgtl03kgYZ4Gsl9Q5OjYE
	RXyIhGD8eglc5O/AnEurlOOObC5p660YfCXGnUfjHpYiAhlJL+eqcidEw+p9UgJKIsiw5m
	rCTYOh5LQf2S3+nhRH2KFDc577NbG8zpFjrFhqYk3dqXKSejYKBBmEYjhSaBFw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of cyphar@cyphar.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=cyphar@cyphar.com
Date: Thu, 28 Aug 2025 10:14:00 +1000
From: Aleksa Sarai <cyphar@cyphar.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Matt Bobrowski <mattbobrowski@google.com>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, 
	Robert Waite <rowait@microsoft.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Scott Shell <scottsh@microsoft.com>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
Message-ID: <2025-08-27-obscene-great-toy-diary-X1gVRV@cyphar.com>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4tazkxltbygkcgo4"
Content-Disposition: inline
In-Reply-To: <20250826.aig5aiShunga@digikod.net>
X-Rspamd-Queue-Id: 4cC22W3nCMz9tSp


--4tazkxltbygkcgo4
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
MIME-Version: 1.0

On 2025-08-26, Micka=EBl Sala=FCn <mic@digikod.net> wrote:
> On Tue, Aug 26, 2025 at 11:07:03AM +0200, Christian Brauner wrote:
> > Nothing has changed in that regard and I'm not interested in stuffing
> > the VFS APIs full of special-purpose behavior to work around the fact
> > that this is work that needs to be done in userspace. Change the apps,
> > stop pushing more and more cruft into the VFS that has no business
> > there.
>=20
> It would be interesting to know how to patch user space to get the same
> guarantees...  Do you think I would propose a kernel patch otherwise?

You could mmap the script file with MAP_PRIVATE. This is the *actual*
protection the kernel uses against overwriting binaries (yes, ETXTBSY is
nice but IIRC there are ways to get around it anyway). Of course, most
interpreters don't mmap their scripts, but this is a potential solution.
If the security policy is based on validating the script text in some
way, this avoids the TOCTOU.

Now, in cases where you have IMA or something and you only permit signed
binaries to execute, you could argue there is a different race here (an
attacker creates a malicious script, runs it, and then replaces it with
a valid script's contents and metadata after the fact to get
AT_EXECVE_CHECK to permit the execution). However, I'm not sure that
this is even possible with IMA (can an unprivileged user even set
security.ima?). But even then, I would expect users that really need
this would also probably use fs-verity or dm-verity that would block
this kind of attack since it would render the files read-only anyway.

This is why a more detailed threat model of what kinds of attacks are
relevant is useful. I was there for the talk you gave and subsequent
discussion at last year's LPC, but I felt that your threat model was
not really fleshed out at all. I am still not sure what capabilities you
expect the attacker to have nor what is being used to authenticate
binaries (other than AT_EXECVE_CHECK). Maybe I'm wrong with my above
assumptions, but I can't know without knowing what threat model you have
in mind, *in detail*.

For example, if you are dealing with an attacker that has CAP_SYS_ADMIN,
there are plenty of ways for an attacker to execute their own code
without using interpreters (create a new tmpfs with fsopen(2) for
instance). Executable memfds are even easier and don't require
privileges on most systems (yes, you can block them with vm.memfd_noexec
but CAP_SYS_ADMIN can disable that -- and there's always fsopen(2) or
mount(2)).

(As an aside, it's a shame that AT_EXECVE_CHECK burned one of the
top-level AT_* bits for a per-syscall flag -- the block comment I added
in b4fef22c2fb9 ("uapi: explain how per-syscall AT_* flags should be
allocated") was meant to avoid this happening but it seems you and the
reviewers missed that...)

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/

--4tazkxltbygkcgo4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQS2TklVsp+j1GPyqQYol/rSt+lEbwUCaK+fRBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQKJf60rfpRG+uowD/Sqmo+gatXLeikpI5XmZo
OTzPamUQKF6Qc1cYyy2INK8BAPK2BcHkJfcGbfBSjW2CshX9cc5oZuhvWEtz4TDD
XzYA
=FdMM
-----END PGP SIGNATURE-----

--4tazkxltbygkcgo4--
