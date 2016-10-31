Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477947674.8761.4.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 31 Oct 2016 17:01:14 -0400
In-Reply-To: <1477947388.8761.3.camel@gmail.com>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	 <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	 <20161031162918.GA2994@pc.thejh.net> <87mvhks0vs.fsf@mid.deneb.enyo.de>
	 <1477947388.8761.3.camel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-bue6goUNRCpf1i2AqixE"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary
 random
To: Florian Weimer <fw@deneb.enyo.de>, Jann Horn <jann@thejh.net>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-bue6goUNRCpf1i2AqixE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> It makes a lot of sense on x86_64 where it means the canary is still
> 56
> bits. Also, you want -fstack-check for protecting again stack
> overflows
> rather than stack *buffer* overflow. SSP won't really help you in that
> regard. Sadly, while -fstack-check now works well in GCC 6 with little
> performance cost, it's not really a complete feature (and Clang impls
> it
> as a no-op!).

Note: talking about userspace after the entropy bit. The kernel doesn't
really -fstack-check, at least in even slightly sane code...
--=-bue6goUNRCpf1i2AqixE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYF7EaFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8irdPw//cJyJrVyudTYPTZewQuUq4EKmpw5zAjtHgDccUfQY09xj7dVILAkk36Bz
8eCllqVexenw31HYtKzfV8Jg4KWa62aBYx2KP9domyCQeh/0czXVo3lwGmAO7Yg6
yFQ1ZYeCMk8xKDxYNqWUI1lbrRcFbWoduIdb1T9I42JM/GLGt2EOLWTZhPS2lHJ+
rtoyAhCpia3OacjIHq0/YAbO2jvg8ghFEreswY1N9hf0GA+I89VYtiGdpRnWerxT
psDiSFZW1l1JX4/BWM5H7bn9zdSSILGylGx+0zQnEZWzgRxqRvV1hCIBQH1GGuyO
ZGAyCA8KYhD8OaLkKbLMRg+STX+Sb+x+F2KL9cxziIMKu69u0lGKbkzexzZYWQpl
cI5D70i2dcPY170vkNYiMAq/+1cclTK75N3PjaG4N54CJ8ChLMdb42O3MxetTXF5
XI/z3sE1NWtgXNKREeE2NauVD+7T10R1B1M8eANXh+DYNDmxi47HKY7iyvWh8byJ
vCiXY/7aAc0ot9sBvrOKivjqAOzwCX4SZDv1v78oESl6mv+kTg7G+dPjnQ3tpBQC
7C79mCLvkA21flsagZ/lzcmtejQuWz8CQgloqnY+snHqxxSrmLs/zZAtSpY8Ifs6
4rvyLhxFzTAYzRmMWzYrJmFbzZV/0rTazzwU9LK7UQbyksdtbxM=
=Zjix
-----END PGP SIGNATURE-----

--=-bue6goUNRCpf1i2AqixE--
