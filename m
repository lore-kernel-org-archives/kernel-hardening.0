References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net>
Date: Sun, 9 Jul 2017 21:35:03 +0200
MIME-Version: 1.0
In-Reply-To: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Tx0uEnSVJ4u7C39rOrvHthw4EHSAbX0cr"
Subject: Re: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Matt Brown <matt@nmatt.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tx0uEnSVJ4u7C39rOrvHthw4EHSAbX0cr
Content-Type: multipart/mixed; boundary="Vw7SOoxAvdutwJJUH8VXU4ju1V01NHSXg";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
 kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>,
 PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>,
 Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>,
 "Serge E. Hallyn" <serge@hallyn.com>, Matt Brown <matt@nmatt.com>,
 Mimi Zohar <zohar@linux.vnet.ibm.com>
Message-ID: <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net>
Subject: Re: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>

--Vw7SOoxAvdutwJJUH8VXU4ju1V01NHSXg
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I think it make sense to merge the W^X features with the TPE/shebang LSM
[1].

Regards,
 Micka=EBl

[1]
https://lkml.kernel.org/r/d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.ne=
t

On 12/06/2017 18:56, Salvatore Mesoraca wrote:
> S.A.R.A. (S.A.R.A. is Another Recursive Acronym) is a stacked Linux
> Security Module that aims to collect heterogeneous security measures,
> providing a common interface to manage them.
> It can be useful to allow minor security features to use advanced
> management options, like user-space configuration files and tools, with=
out
> too much overhead.
> Some submodules that use this framework are also introduced.
> The code is quite long, I apologize for this. Thank you in advance to
> anyone who will take the time to review this patchset.
>=20
> S.A.R.A. is meant to be stacked but it needs cred blobs and the procatt=
r
> interface, so I temporarily implemented those parts in a way that won't=

> be acceptable for upstream, but it works for now. I know that there
> is some ongoing work to make cred blobs and procattr stackable, as soon=

> as the new interfaces will be available I'll reimplement the involved
> parts.
> At the moment I've been able to test it only on x86.
>=20
> S.A.R.A. submodules introduced in this patchset are: USB Filtering and
> WX Protection.
>=20
> The kernel-space part is complemented by its user-space counterpart:
> saractl [1].
> A test suite for WX Protection, called sara-test [2], is also available=
=2E
>=20
> USB Filtering aims to provide a mechanism to decide which USB devices
> should be authorized to connect to the system and which shouldn't. The =
main
> goal is to narrow the attack surface for custom USB devices designed to=

> exploit vulnerabilities found in some USB device drivers.
> Via configuration it's possible to allow or to deny authorization, base=
d
> on one or more of: Vendor ID, Product ID, bus name and port number. The=
re
> is also limited support for wildcards.
> Depending on the configuration, it can work both as a white list or as =
a
> black list.
> With the help of "saractl" it's also possible to completely disable new=

> USB devices when the screen is "locked".
> The original idea is inspired by the Grsecurity "Deny USB" feature.
>=20
> WX Protection aims to improve user-space programs security by applying:=

> - W^X enforcement: program can't have a page of memory that is marked, =
at
> 		   the same time, writable and executable.
> - W!->X restriction: any page that could have been marked as writable i=
n
> 		     the past won't ever be allowed to be marked as
> 		     executable.
> - Executable MMAP prevention: prevents the creation of new executable m=
maps
> 			      after the dynamic libraries have been loaded.
> All of the above features can be enabled or disabled both system wide
> or on a per executable basis through the use of configuration files man=
aged
> by "saractl".
> It is important to note that some programs may have issues working with=

> WX Protection. In particular:
> - W^X enforcement will cause problems to any programs that needs
>   memory pages mapped both as writable and executable at the same time =
e.g.
>   programs with executable stack markings in the PT_GNU_STACK segment.
> - W!->X restriction will cause problems to any program that
>   needs to generate executable code at run time or to modify executable=

>   pages e.g. programs with a JIT compiler built-in or linked against a
>   non-PIC library.
> - Executable MMAP prevention can work only with programs that have at l=
east
>   partial RELRO support. It's disabled automatically for programs that
>   lack this feature. It will cause problems to any program that uses dl=
open
>   or tries to do an executable mmap. Unfortunately this feature is the =
one
>   that could create most problems and should be enabled only after care=
ful
>   evaluation.
> To extend the scope of the above features, despite the issues that they=
 may
> cause, they are complemented by:
> - procattr interface: can be used by a program to discover which WX
> 		      Protection features are enabled and/or to tighten
> 		      them.
> - Trampoline emulation: emulates the execution of well-known "trampolin=
es"
> 			even when they are placed in non-executable memory.
> Parts of WX Protection are inspired by some of the features available i=
n
> PaX.
>=20
> More information can be found in the documentation introduced in the fi=
rst
> patch and in the "commit message" of the following emails.
>=20
> [1] https://github.com/smeso/saractl
> [2] https://github.com/smeso/sara-test
>=20
> Salvatore Mesoraca (11):
>   S.A.R.A. Documentation
>   S.A.R.A. framework creation
>   Creation of "usb_device_auth" LSM hook
>   S.A.R.A. USB Filtering
>   Creation of "check_vmflags" LSM hook
>   S.A.R.A. cred blob management
>   S.A.R.A. WX Protection
>   Creation of "pagefault_handler_x86" LSM hook
>   Trampoline emulation
>   Allowing for stacking procattr support in S.A.R.A.
>   S.A.R.A. WX Protection procattr interface
>=20
>  Documentation/admin-guide/kernel-parameters.txt |  40 ++
>  Documentation/security/00-INDEX                 |   2 +
>  Documentation/security/SARA.rst                 | 192 +++++
>  arch/x86/mm/fault.c                             |   6 +
>  drivers/usb/core/hub.c                          |   4 +
>  drivers/usb/core/sysfs.c                        |   6 +-
>  fs/proc/base.c                                  |  38 +
>  include/linux/cred.h                            |   3 +
>  include/linux/lsm_hooks.h                       |  26 +
>  include/linux/security.h                        |  24 +
>  mm/mmap.c                                       |   9 +
>  security/Kconfig                                |   1 +
>  security/Makefile                               |   2 +
>  security/sara/Kconfig                           | 175 +++++
>  security/sara/Makefile                          |   5 +
>  security/sara/include/sara.h                    |  29 +
>  security/sara/include/sara_data.h               |  47 ++
>  security/sara/include/securityfs.h              |  59 ++
>  security/sara/include/trampolines.h             | 171 +++++
>  security/sara/include/usb_filtering.h           |  27 +
>  security/sara/include/utils.h                   |  69 ++
>  security/sara/include/wxprot.h                  |  27 +
>  security/sara/main.c                            | 113 +++
>  security/sara/sara_data.c                       |  79 +++
>  security/sara/securityfs.c                      | 558 +++++++++++++++
>  security/sara/usb_filtering.c                   | 410 +++++++++++
>  security/sara/utils.c                           | 151 ++++
>  security/sara/wxprot.c                          | 902 ++++++++++++++++=
++++++++
>  security/security.c                             |  42 +-
>  29 files changed, 3214 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/security/SARA.rst
>  create mode 100644 security/sara/Kconfig
>  create mode 100644 security/sara/Makefile
>  create mode 100644 security/sara/include/sara.h
>  create mode 100644 security/sara/include/sara_data.h
>  create mode 100644 security/sara/include/securityfs.h
>  create mode 100644 security/sara/include/trampolines.h
>  create mode 100644 security/sara/include/usb_filtering.h
>  create mode 100644 security/sara/include/utils.h
>  create mode 100644 security/sara/include/wxprot.h
>  create mode 100644 security/sara/main.c
>  create mode 100644 security/sara/sara_data.c
>  create mode 100644 security/sara/securityfs.c
>  create mode 100644 security/sara/usb_filtering.c
>  create mode 100644 security/sara/utils.c
>  create mode 100644 security/sara/wxprot.c
>=20


--Vw7SOoxAvdutwJJUH8VXU4ju1V01NHSXg--

--Tx0uEnSVJ4u7C39rOrvHthw4EHSAbX0cr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAllihWgACgkQIt7+33O9
apUP7QgAqbZNW3Oi7yfM89eKX49la3OdonpbxR5p8SdbZOYn1lAJH5x/hX6z8efB
Qeq4FzC1jNijaTeaJc3Dd/Dp2KrwqBKrqScg50b6z5c+4dFS3zwUSSCZkH2BrzOg
d92nSo+ATHHV1YL1V60jMT2v1Y2+X6VmrDqAK3SsxYZ4Ln5VP9PD4Nv/ouyyKXI9
/FaZzPE6jwPGF89LOcHduGL/bLgtJ3gbNoTQCOZe1f22o4YOrD2RNU8O0sPhq354
u1wiBOIYZYvncE83uIwwJeKqrVuK1nXC+3VU3uMZr3jVNvoIbta2Gyd/CvOgKG/w
OQzjZzN9Is5M/GTltCKXjKLMk1Wy6Q==
=m135
-----END PGP SIGNATURE-----

--Tx0uEnSVJ4u7C39rOrvHthw4EHSAbX0cr--
