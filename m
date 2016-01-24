Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 24 Jan 2016 02:56:43 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20160124015643.GA6601@pc.thejh.net>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <1453502345-30416-2-git-send-email-keescook@chromium.org>
 <87oacdyos0.fsf@x220.int.ebiederm.org>
 <20160123222540.GA9740@pc.thejh.net>
 <87mvrvwz72.fsf@x220.int.ebiederm.org>
 <20160124014342.GW17997@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20160124014342.GW17997@ZenIV.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] sysctl: expand use of
 proc_dointvec_minmax_sysadmin
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 24, 2016 at 01:43:42AM +0000, Al Viro wrote:
> On Sat, Jan 23, 2016 at 07:20:17PM -0600, Eric W. Biederman wrote:
>=20
> > Yep.  That is about the size of it.  file * used to be passed to the
> > sysctl methods but it was removed several years ago because no one was
> > using it.
>=20
> Generally cred would be better...

> Alternatively we could eat one more
> pointer in task_struct and stash a reference to that sucker there, rather
> than adding an explicit argument (again, with cred instead of file).
> Not sure...

I think it makes sense to do this the same way as the rest of the VFS code
here (which passes the creds down through an argument).

And adding the arguments everywhere doesn't really mean more work - either
way, someone should probably go through all of those sysctl handlers and
fix them up to use the file creds.

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWpC9bAAoJED4KNFJOeCOoaAEQAMunAJcKuUVNfv23dUSSABfl
emn+AAYPyGJHYcklhCssby9xh/AIlwLPAd7dT/J7qG4UsmsJxppQn+SiSZPrCSb6
M9KqXnQdMP6xhRahx0FxoPDX1GsLimxOta29ZjLXMPewAplMZGOYkzEOy8KFGdUL
xQ6ysZM+9WIbxaN0nY5UAdADEqmi+XIy3lDtygzxFbEZ8VRzKDnbN56C0a4K8U8A
4jYHoE1YZ/3mJCLOIdJfDLD16pdLF3muGli7nyuRFlqTsTcJ2Hyj8fAO6kS21sZ0
v9Z/vgjZoRg79WyLW82CeVRk7Plpyq1h8HReHKDt9XrEO0wSEzEv9GoBAeGccJQ7
NDpad/hpltBGKRAn2SQGEK/werF1T/+dbWB4kegLiiA0rcoc0C3fdkyuyF0PUP+w
/zxHHRDyeMhW7bK+HglBFj0HjJ8Mxv+3FKB9u7PCPFE1yF5eg9go0lzCHmupZmGg
PKx+spFQyzukSFbmz+SiMLnBR1Qmqa/LtWvNm8kyN1UMW0DkRZH6u5oVV5E7pi3s
dDjymHtxqajF3TLYvTjbUcv7Gr9NI2tAu6rHuo3+atGYphVgYMET35jjfg/g1T/+
+/CTqFlfgz7xACh08w0FkQRHvc8ZM76EYEacOooJnECsXIqwi4UeEEGCI6jIQhgH
hR49nvI7d/cgKP4mnatC
=6Ms7
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
