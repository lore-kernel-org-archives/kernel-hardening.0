Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 21:55:26 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20161031205526.GA3286@pc.thejh.net>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
 <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
 <20161031162918.GA2994@pc.thejh.net>
 <87mvhks0vs.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <87mvhks0vs.fsf@mid.deneb.enyo.de>
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary
 random
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 31, 2016 at 09:45:59PM +0100, Florian Weimer wrote:
> * Jann Horn:
>=20
> > On Mon, Oct 31, 2016 at 09:04:02AM -0700, Kees Cook wrote:
> >> On Mon, Oct 31, 2016 at 7:04 AM, Jann Horn <jann@thejh.net> wrote:
> >> > On machines with sizeof(unsigned long)=3D=3D8, this ensures that the=
 more
> >> > significant 32 bits of stack_canary are random, too.
> >> > stack_canary is defined as unsigned long, all the architectures with=
 stack
> >> > protector support already pick the stack_canary of init as a random
> >> > unsigned long, and get_random_long() should be as fast as get_random=
_int(),
> >> > so there seems to be no good reason against this.
> >> >
> >> > This should help if someone tries to guess a stack canary with brute=
 force.
> >> >
> >> > (This change has been made in PaX already, with a different RNG.)
> >> >
> >> > Signed-off-by: Jann Horn <jann@thejh.net>
> >>=20
> >> Acked-by: Kees Cook <keescook@chromium.org>
> >>=20
> >> (A separate change might be to make sure that the leading byte is
> >> zeroed. Entropy of the value, I think, is less important than blocking
> >> canary exposures from unbounded str* functions. Brute forcing kernel
> >> stack canaries isn't like it bruting them in userspace...)
> >
> > Yeah, makes sense. Especially on 64bit, 56 bits of entropy ought to be
> > enough anyway.
>=20
> So you two approve of the way glibc does this currently?  (See the
> other thread.)

Well... not really with a 32-bit canary. 2^23 crashes to defeat a
mitigation is not so much, even over the network. With a 64-bit canary,
losing the 8 bits would be no problem at all IMO.

So I guess I should revise what I said: I think the nullbyte thing is
fine for 64-bit canaries, but not for 32-bit ones.

> I was under the impression that the kernel performs far less
> null-terminated string processing the average user space application,
> especially on the stack.

Yes, that's true - the kernel allocates even small-ish temporary string
buffers with kmalloc() to reduce stack usage.

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYF6++AAoJED4KNFJOeCOo4bIP/jl1yWgkpoM7ZOUhhjANAW0Y
f1mUTfBYdZe22cWepLYNrBidTcRa4yqLtGsJmbFB9krykabUUQg9ShLJJSM7Xtui
QwjiIjxGadPF6SU3tvmJS9xj8hI3EM0JN05qZo7HH8x10WiZWYTQPkYxVjkCSZjQ
j7yxnmH8FzC8iEUt5zQJVP090e/M6mbPsYT9+g3EI93gDJ+PRefhIly6s3y8K1BC
2FvEayMa+/+W1TMb3wBoY/d684OQgMXibCps20ERShkzvM2XY78Uu7eyiZWVgxrS
xRbzrMqtJFKGkTVyVHrJo4WL9Di1AXQoqXy9VXedBef43RTuylRDOpnFdiE+E48Y
Qi2RTjt0m4ULa6L06jp6MvVI0g4UPZICNMZfeM0+D8OYE5Mv8883PJoL+0F2QiRg
QkRd+kbDZ+k6ZcC6vMHxEZ4vwJqEe0BtW7Ac9eQIocDSPB4U2LStYgLc7n8O+Xld
ZGTnrouZvNmmO7N42Z5pjtIxmn63rn97INq4LGPclmrxQyPcGGppkcNvGeLGWJ6k
0cGhZq8ONzEE2+hc1J0HgjNFhkE6yMKNyI9OUkkNP+r9DoXpHTGjm247LcMfDU6O
ZCEJ6jN3fp69GmHxERymL3dmiM+RXkVE/oQX2l+4FkKFHoNG8w1YlQEvnEDArmSb
RTL3iWrq9lcPqTCFkJ8T
=Bfqm
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
