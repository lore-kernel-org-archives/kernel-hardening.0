Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 23:50:46 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160729215046.GA31618@pc.thejh.net>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
 <1469777680-3687-6-git-send-email-elena.reshetova@intel.com>
 <20160729185317.GF11621@pc.thejh.net>
 <f2fcb76e-f843-cd78-0552-6709b34827e3@schaufler-ca.com>
 <20160729205354.GA13090@pc.thejh.net>
 <6ff8fdb1-247b-1f58-bded-c6f274feb20c@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <6ff8fdb1-247b-1f58-bded-c6f274feb20c@schaufler-ca.com>
Subject: Re: [kernel-hardening] [RFC] [PATCH 5/5] Hardchroot LSM
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2016 at 02:10:31PM -0700, Casey Schaufler wrote:
> On 7/29/2016 1:53 PM, Jann Horn wrote:
> > On Fri, Jul 29, 2016 at 12:20:56PM -0700, Casey Schaufler wrote:
> >> On 7/29/2016 11:53 AM, Jann Horn wrote:
[...]
> > And when you look at Linux 0.10, you'll see that already back
> > then, sys_chroot() just updated current->root; sending signals
> > to other processes, setting the system time and so on just did
> > UID checks.
> >
> >
> >>> and chroot "jails" break in a number
> >>> of different ways.
> >> All of which were introduced after the fact, and most of which
> >> have been introduced in spite of the objections of the security
> >> community. Even sockets, which are the biggest single breakage
> >> (followed closely by the process namespace and SVIPC) came along
> >> well after chroot and really should have taken the "root" into
> >> account.
> > Namespaces on Linux actually take chroots into account - you can't
> > create a new namespace if you're unprivileged and inside a chroot,
> > see commit 3151527ee0. I'm not sure whether that was added before
> > or after unprivileged user namespaces were enabled.
> >
> >
> >>> A lot of effort went into making bind mounts
> >>> actually secure with reasonable performance, and I doubt that
> >>> something like this can provide anything close to that, at least
> >>> not without gigantic runtime overhead. Instead of making people
> >>> believe that it's now okay to use chroot for security, I would
> >>> very much prefer to keep the "never use this for security
> >>> purposes" warning in the chroot() manpage and encourage people
> >>> to use namespaces with bind mounts instead.
> >> There is merit to the argument that namespaces are better than
> >> chroot jails. Nonetheless, we're all aware of just how much
> >> legacy code we're going to have to deal with for the next
> >> forever, and some of that can benefit from this work.
> > Eh. For that, you could also make a shim that turns chroot into
> > namespace creation automatically
>=20
> Right. Why carry a tent when you can pull a 24' Airsteam trailer? :)

Because that "tent" would be a lot of messy parts all over your house
while the "Airsteam trailer" could maybe be parked outside and
wouldn't be in the way every time you want to make coffee?

And besides, since lots of people are going to build their own
trailers, it might make sense to have your own so that you can show
people what a proper trailer looks like.

(And if multithreaded namespace creation is needed for this, it
might be nice to have anyway, considering that people want to use
namespaces from languages like Go, where they currently have to
implement the unsharing in C before the runtime starts up - I think
that was e.g. the case in subgraph's oz. This could probably be
implemented similar to grsecurity's GRKERNSEC_SETXID. I think this
isn't exactly a priority at the moment, but as people start using
memory-safe languages with GC for low-level stuff like this, it
might become more important - I don't know.)

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm8+2AAoJED4KNFJOeCOowyUP/RR8DV0B8X+5EewEuTbQNNAW
h+ghtY8syY7qrNujHcIc/GTKmdrm396F374iE+37gyeNs4M5UVuGodDk1ZSx6FUI
37zXrqhCV8jRwUg9t2fKOaUVN6ipIMliIvaYEmxgLO8wBi3s53mdliyzXGMZZbIU
+o4NVlO+g8xfz9z5GQ3cmk4747CCD9+3UmdPnoiD+XqqpsIhUmyCfyU5a4bx7wpe
RC/K2uW6szkysdUkW3cMTHT7BYu+oF4QbrTkAn/LKvBjH703m++dCFCuSBhpq3IL
zAOGRx+Tm0gnxWzxNRVlRQjJ7sf/JlXmL9VG+cpFaqfQEaLaTjP9kxoD0pxSnuXa
cW1KikTklGOJHmcQPTknVZyrra48IpbzQwYN67czlGc8I0HxRaZpTMpWPzDKNUAG
apumqJM4Ir3wZ//jndXe2GHr9Frw5SRWyDWxDW6AmIkQuBK0GjJ0BBnL+BXA+N02
YALwvYo9GZ3hqcsEL+aXhyUwF/ocO9JuI6uB9yPYD1HjMcqL74DO+8MQ1asZkwJX
B1SRPbk2LeqVfIe478m4OAK0UuT4hBWKEGQ6g9r4+kAM3HAbgaJxgP+7/sN8q6NH
6CLZUB917/xxAX5gozz5uSyZbBM3EacHLG+s8Gn0I0Pidsmtkeucdty0J6zq+Irp
M9DNv+4xupero8qQtqQc
=Lzo1
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
