Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 24 Jan 2016 07:32:29 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20160124063229.GA21717@pc.thejh.net>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <1453502345-30416-2-git-send-email-keescook@chromium.org>
 <87oacdyos0.fsf@x220.int.ebiederm.org>
 <20160123222540.GA9740@pc.thejh.net>
 <87mvrvwz72.fsf@x220.int.ebiederm.org>
 <20160124014342.GW17997@ZenIV.linux.org.uk>
 <20160124015643.GA6601@pc.thejh.net>
 <87wpqzv7jy.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <87wpqzv7jy.fsf@x220.int.ebiederm.org>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] sysctl: expand use of
 proc_dointvec_minmax_sysadmin
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 24, 2016 at 12:02:41AM -0600, Eric W. Biederman wrote:
> Jann Horn <jann@thejh.net> writes:
>=20
> > On Sun, Jan 24, 2016 at 01:43:42AM +0000, Al Viro wrote:
> >> On Sat, Jan 23, 2016 at 07:20:17PM -0600, Eric W. Biederman wrote:
> >>=20
> >> > Yep.  That is about the size of it.  file * used to be passed to the
> >> > sysctl methods but it was removed several years ago because no one w=
as
> >> > using it.
> >>=20
> >> Generally cred would be better...
> >
> >> Alternatively we could eat one more
> >> pointer in task_struct and stash a reference to that sucker there, rat=
her
> >> than adding an explicit argument (again, with cred instead of file).
> >> Not sure...
> >
> > I think it makes sense to do this the same way as the rest of the VFS c=
ode
> > here (which passes the creds down through an argument).
> >
> > And adding the arguments everywhere doesn't really mean more work - eit=
her
> > way, someone should probably go through all of those sysctl handlers and
> > fix them up to use the file creds.
>=20
> Not all of them need it.  It might be worth figuring out the necessary
> rigamarole to hook into sysctl_perm the way the networking code does and
> have that require the capability at open time.
>=20
> The advantage is that open time is when it is actually appropraite to
> check permissions.  I could be wrong but I doubt there is enough madness
> with the handful of sysctl users that call capable to require the checks
> to happen on write and not on open.

That would work - if all sysctls know whether a capability will be needed
for writing later on and don't decide it based on the written data. Is that
always true?

Looking through some of the sysctl handlers, I found proc_do_uts_string and
pid_ns_ctl_handler, which operate on a namespace looked up through current
at write time. I think that's buggy and ought to be done using the file
opener creds and on the file opener's namespaces, but where can those be
stored?

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWpG/9AAoJED4KNFJOeCOo7mcQAJgns5XDEnw9zAJxF5VPJry6
Zkp+LCGJa8Jy514h3db4PLW0QY0tnXTS4Kqgm2GNm8bdJpd8p8nvfAfz8lIAGbGb
LFnLOiTIkR+draW4XHzt9oKiS0nhv+QBGOsRv0sra/w5t/erNp1mD47tOTMMGPYy
gNMIdoXz+tWnZmORIfc9+cym504gBrh64m+d55vMcI8w210Ty5qLKMXDfj1vpO8F
Jvymynr10shh8jU1PfnBOeWZMpe8FHVy/gn32AVX4FLZaMtF/AtfrBtYaYBJ0jPP
VFVxOSN9Gfh6LjqzsTRBogqx2nieGC5kuQv3T8RKutCtiqj9QcH5eIcET//rpt48
1xCAl82QVaERtNxKtX541qcxnuYJ2GnPH4oCpRHUH9XciW+zgC5lON6XqM4wJckS
yvNQJhz04lWGFi+4Vsry8IP5VPOIWvfZymuGUdzYVZ9UfFrMCwI3Ygu5aQG1dBVy
NPGXHvUIL4yqhfWU8QD0kEqeJJsm8mnxMgTa2lRImE9AXxwPN9C6l3GkK8+vTJkT
QJv6LJvkYkdn2xFLi7KuYVZ5bH9lF/mIqERw4io1OVfdrbQSKj6PkwRNlq1vO2fF
6aB5E4dLsYtEJJGgx8qo1Kez396xdFgaieffcJrS2RzFgf7Fx2pBUPIGpiWh3Yc0
DNwBvUZZ34yirn5gQkPX
=1wDU
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
