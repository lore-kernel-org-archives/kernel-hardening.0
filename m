Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 6 Sep 2016 18:19:21 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20160906161921.GB31384@pc.thejh.net>
References: <cover.1466466093.git.luto@kernel.org>
 <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com>
 <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <CALCETrU2B0QYBgTTSAFiK026Bx96+Bk=k64bhrDT+TiXsV7D4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <CALCETrU2B0QYBgTTSAFiK026Bx96+Bk=k64bhrDT+TiXsV7D4A@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 23, 2016 at 09:41:11AM -0700, Andy Lutomirski wrote:
> 3. Free stacks immediately and cache them (really easy).

Random note: task_current_syscall() (via /proc/$pid/syscall) will probably need additional
locking when the stack is freed before the task.

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXzuyJAAoJED4KNFJOeCOoA8AQAN8Hyj3k+FZaBTAr4+q175lV
oJBc+5VcV3JdenMRaVkSPEyOb40bo5TKuPV7gOpSajbOAxO95Y4UEu1iPvLFnm1D
Z2bz1k8vk7JseGooHlkPDDLYlQNH0ilbSEhh4ysj0F/1TrT+Wrf7pFum/F7uGZgl
zjnZ6qf+MjZbvBSsYAftXHwLHANGkR6fTOl4UaZUgZm7vtshLcSp/pSoL00m5UN5
i54k26Ccs9RH8zO42lUiiDm3MeXRmzZ3E9akdsLgumZinui36nZqoEExEbE+U+Y+
PAnHGwu2gsniNn/dPtfAsalPC4Z5wRgyB0S9aiW6ehchXXnNJhETX6QbvQfJ2MJ/
RoWWvcr/lIWinc842M2elQjPRBpg5O1ObwdytbGR42uII9vtG4zSC4ZnbFANXWPp
jvFWnbjZu1nG1qd2lz+msLdtYO+d8v6W9exijz5TkelXwXYu5fu3OfoX1+ZDUzfv
XjYX4mzBJMZzLrN2KE851RjpDyhCaJrVi+jjD5uapRl1GnugK/8nivv1cDZDJcEJ
YOh+AOLQYttcYq2amGJSGg5kZNor8qxtB7O0bfB4IexUHgJpbt7/7Bct97O7S6qw
0wmOMMrQhXDsgPSd47FHSMI/i+5gTcQZVwxJwoVuy3jeXAcdQiyuDXsoKwa1hkpu
oVHyNbgpw3OdXCCPKdAC
=GyiT
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
