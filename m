Return-Path: <kernel-hardening-return-21992-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 515A7CA0EFF
	for <kernel-hardening@archiver.kernel.org>; Thu, 28 Aug 2025 00:53:23 +0000 (UTC)
Received: (qmail 25660 invoked by uid 550); 28 Aug 2025 00:53:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25635 invoked from network); 28 Aug 2025 00:53:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
	t=1756342383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nkOVSTJeGMrXnWxpGpCSqeWsWiSvBuOe+MZ2w3etRU=;
	b=IjykoAQqWYQXRZz4Xn49InWy8P9wskh17pgP4b5aQ35Z4D48ODkQay3K09Nob+X0BaCp5w
	jx41jaJ3Pf4M4/zNR86ugRZyrBFQBOmqAz7N2Vc8wnCBwbhJfmrepDjg2a+QwFGu5MtyM3
	AZXaxFlqcyiBbZF1N0gw0ePo6/JX/AlNJNc5i0mNd1z0ywmkgvv10Xcl264sTwtfm5HIf6
	Bhk1QJuKol+hI+LYmKQY1NzQfmoU56kcgEdeZ0FMIn4FxaccZTisU/zeeS7124dztDMfsg
	CAVgyvvwhy1GjpX3yvVhmPcNAIVUgynEHOeMCnvZTjgATZFrlOa2yqTcEls94w==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of cyphar@cyphar.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=cyphar@cyphar.com
Date: Thu, 28 Aug 2025 10:52:42 +1000
From: Aleksa Sarai <cyphar@cyphar.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, 
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
Message-ID: <2025-08-28-alert-groggy-mugs-lapse-IWqeR7@cyphar.com>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net>
 <2025-08-27-obscene-great-toy-diary-X1gVRV@cyphar.com>
 <CALCETrWHKga33bvzUHnd-mRQUeNXTtXSS8Y8+40d5bxv-CqBhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t3uldpk5vmc35wcr"
Content-Disposition: inline
In-Reply-To: <CALCETrWHKga33bvzUHnd-mRQUeNXTtXSS8Y8+40d5bxv-CqBhw@mail.gmail.com>
X-Rspamd-Queue-Id: 4cC2v30ggvz9tQQ


--t3uldpk5vmc35wcr
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
MIME-Version: 1.0

On 2025-08-27, Andy Lutomirski <luto@kernel.org> wrote:
> On Wed, Aug 27, 2025 at 5:14=E2=80=AFPM Aleksa Sarai <cyphar@cyphar.com> =
wrote:
> >
> > On 2025-08-26, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wrote:
> > > On Tue, Aug 26, 2025 at 11:07:03AM +0200, Christian Brauner wrote:
> > > > Nothing has changed in that regard and I'm not interested in stuffi=
ng
> > > > the VFS APIs full of special-purpose behavior to work around the fa=
ct
> > > > that this is work that needs to be done in userspace. Change the ap=
ps,
> > > > stop pushing more and more cruft into the VFS that has no business
> > > > there.
> > >
> > > It would be interesting to know how to patch user space to get the sa=
me
> > > guarantees...  Do you think I would propose a kernel patch otherwise?
> >
> > You could mmap the script file with MAP_PRIVATE. This is the *actual*
> > protection the kernel uses against overwriting binaries (yes, ETXTBSY is
> > nice but IIRC there are ways to get around it anyway).
>=20
> Wait, really?  MAP_PRIVATE prevents writes to the mapping from
> affecting the file, but I don't think that writes to the file will
> break the MAP_PRIVATE CoW if it's not already broken.

Oh I guess you're right -- that's news to me. And from mmap(2):

> MAP_PRIVATE
> [...] It is unspecified whether changes made to the file after the
> mmap() call are visible in the mapped region.

But then what is the protection mechanism (in the absence of -ETXTBSY)
that stops you from overwriting the live text of a binary by just
writing to it?

I would need to go trawling through my old scripts to find the
reproducer that let you get around -ETXTBSY (I think it involved
executable memfds) but I distinctly remember that even if you overwrote
the binary you would not see the live process's mapped mm change value.
(Ditto for the few kernels when we removed -ETXTBSY.) I found this
surprising, but assumed that it was because of MAP_PRIVATE.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/

--t3uldpk5vmc35wcr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQS2TklVsp+j1GPyqQYol/rSt+lEbwUCaK+oWhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQKJf60rfpRG9YOwD+IgeIsIsIT209gc6p0UJ+
RpiujJ3PHk79u8piCbNs9GIA/2I0ge/RGvNochLLI17BW1sMdgZdclwN/rf+cUxC
cnwF
=FhJ0
-----END PGP SIGNATURE-----

--t3uldpk5vmc35wcr--
