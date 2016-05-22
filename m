Reply-To: kernel-hardening@lists.openwall.com
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
 <57407C98.3090508@iogearbox.net>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <574224FA.9040705@digikod.net>
Date: Sun, 22 May 2016 23:30:34 +0200
MIME-Version: 1.0
In-Reply-To: <57407C98.3090508@iogearbox.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="QexW0u1k5EJEtixm75qEe6P4VjIimaDfW"
Subject: [kernel-hardening] Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to
 sandboxing
To: Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, alexei.starovoitov@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QexW0u1k5EJEtixm75qEe6P4VjIimaDfW
Content-Type: multipart/mixed; boundary="iUbXwptIPx36Ga52lBjvd7F44EIxVJFxF"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
 Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski
 <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>,
 James Morris <jmorris@namei.org>, Jeff Dike <jdike@addtoit.com>,
 Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>,
 "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 alexei.starovoitov@gmail.com
Message-ID: <574224FA.9040705@digikod.net>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to
 sandboxing
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
 <57407C98.3090508@iogearbox.net>
In-Reply-To: <57407C98.3090508@iogearbox.net>

--iUbXwptIPx36Ga52lBjvd7F44EIxVJFxF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On 21/05/2016 17:19, Daniel Borkmann wrote:
> Out of curiosity, did you have a look whether adding some very basic
> eBPF support for seccomp-BPF could also enable you for the option of
> inspecting arguments eventually?
>=20
> With basic, I mean adding new eBPF program type BPF_PROG_TYPE_SECCOMP
> and the only things allowed would be to use a very limited set of
> helpers. No maps, etc allowed for this type. If needed for extracting
> args, you could extend struct seccomp_data for eBPF use, and add new
> set of helper functions that would allow you to extract/walk arguments,=

> and, for example, pass the extracted buffer back to the eBPF prog for
> further inspection.
>=20
> Have a look at samples in [1,2], which are for tracing though, but poss=
ibly
> it could be designed in a more or less similar way, where clang compile=
s
> this policy down into eBPF bytecode. Did you have a look at this direct=
ion
> or any thoughts on it?
>=20
>   [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/t=
ree/samples/bpf/tracex5_kern.c
>   [2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/t=
ree/samples/bpf/tracex1_kern.c

One of my initial goals was to use as much as possible the existing code =
without modifying the BPF part. I use (or abuse) the seccomp BPF stack to=
 be able to run some checks by the kernel outside the BPF but get the res=
ult from each intermediate BPF.

I have not really looked at the eBPF possibilities, but that seems intere=
sting now that I plan to move the kernel object evaluation part only in t=
he LSM. However, the current seccomp code is whitelisting a very small su=
bset of BPF and it would extend the attack surface to add some more comma=
nds. But maybe, as you said, we could create some custom eBPF functions d=
edicated to kernel object inspection and add them (BPF_CALL) to the curre=
nt whitelist (for the LSM). It would be less hacky than the stacked BPF I=
 used, but could be more complex.

Kees, what do your think about this?


--iUbXwptIPx36Ga52lBjvd7F44EIxVJFxF--

--QexW0u1k5EJEtixm75qEe6P4VjIimaDfW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJXQiT6AAoJECLe/t9zvWqVUqkIAIyWRwDAjQzWbPYP40dmpJdB
x9+KxGIIRZ4exuNmxDS+ge3YZL1L+Rz3RGnNTV1TvzqByqQW4JONL1fQMEHIO2XI
fjHqbc6tHRcwXRxD1KSmCGmt3CBiQeaO9uZDmwZ/d/kQ4WXPeyVVnDVxCi1X/yhE
lSGueEJ+KzZu7ObklsejCbGUtffK+PGGEbSRIMlJKXsy2d7+0VcVlO4WRHzjFx9J
pwTvOOBvQnNnPs+yJEadUpQFxci5BCiSa9M6p5BKSy8KEEuynE0d+scSx7XWsaCF
S+U5GlnGQbyjXkDYPS2wriKRcMg3BvYb6axy1llDD+QAHLoZP3lCegKe3QPy0jU=
=5EHH
-----END PGP SIGNATURE-----

--QexW0u1k5EJEtixm75qEe6P4VjIimaDfW--
