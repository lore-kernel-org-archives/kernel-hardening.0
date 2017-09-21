Message-ID: <1506026489.5486.25.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Thu, 21 Sep 2017 16:41:29 -0400
In-Reply-To: <20170921185239.88398-4-ebiggers3@gmail.com>
References: <20170921185239.88398-1-ebiggers3@gmail.com>
	 <20170921185239.88398-4-ebiggers3@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kXFdnAkjQf5T/VuiUR8S"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH v3 3/3] x86/fpu: reinitialize FPU
 registers if restoring FPU state fails
To: Eric Biggers <ebiggers3@gmail.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-kXFdnAkjQf5T/VuiUR8S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-09-21 at 11:52 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Userspace can change the FPU state of a task using the ptrace() or
> rt_sigreturn() system calls.=C2=A0=C2=A0Because reserved bits in the FPU =
state
> can
> cause the XRSTOR instruction to fail, the kernel has to carefully
> validate that no reserved bits or other invalid values are being set.
>=20
> Unfortunately, there have been bugs in this validation code.=C2=A0=C2=A0F=
or
> example, we were not checking that the 'xcomp_bv' field in the
> xstate_header was 0.=C2=A0=C2=A0As-is, such bugs are exploitable to read =
the
> FPU
> registers of other processes on the system.=C2=A0=C2=A0To do so, an attac=
ker
> can
> create a task, assign to it an invalid FPU state, then spin in a loop
> and monitor the values of the FPU registers.=C2=A0=C2=A0Because the task'=
s FPU
> registers are not being restored, sometimes the FPU registers will
> have
> the values from another process.
>=20

Reviewed-by: Rik van Riel <riel@redhat.com>

--=20
All rights reversed
--=-kXFdnAkjQf5T/VuiUR8S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZxCP5AAoJEM553pKExN6DjccIAKO9BT4h/MENjBlAzekFjzDY
nviNItE1sp4lNuiX7cbxAChuv+opGXUpy+Y8fYuPs/N8Iuwd6HLcX1O/bAQXiF6f
2B4UfVYRM7tswdg/wSpg4AkOKOb4gaJKeANrdfErDCLCmvlVT7pDnvVOoOWcnden
gLv/Uivl3Y4x9jwyaY/M3/piEu+AOiOQD2LKu8LJ/4hKb1T6EKPNkN5W+5TCb6gm
eR47jpvxIdib9199pdZuJMgNMoCzKEoxY5C9KPRP+EJh6+nSo0Dimob8zA00Ueiu
WFbEU3I8nkwxW/BfMt3PY8B48Ry/PE/WMgBbMp92vjkf+mQmJJXxOpTvz5PeI9U=
=VmsX
-----END PGP SIGNATURE-----

--=-kXFdnAkjQf5T/VuiUR8S--
