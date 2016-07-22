Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <fb3254e25e38790c538cca0f46c4a7a714c77ddf.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org> <cover.1468270393.git.luto@kernel.org>
 <fb3254e25e38790c538cca0f46c4a7a714c77ddf.1468270393.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1469162592_1957P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Jul 2016 00:43:12 -0400
Message-ID: <5741.1469162592@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] [PATCH v5 03/32] x86/cpa: In populate_pgd, don't set the pgd entry until it's populated
To: kernel-hardening@lists.openwall.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1469162592_1957P
Content-Type: text/plain; charset=us-ascii

On Mon, 11 Jul 2016 13:53:36 -0700, Andy Lutomirski said:
> This avoids pointless races in which another CPU or task might see a
> partially populated global pgd entry.  These races should normally
> be harmless, but, if another CPU propagates the entry via
> vmalloc_fault and then populate_pgd fails (due to memory allocation
> failure, for example), this prevents a use-after-free of the pgd
> entry.
>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/mm/pageattr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

I just bisected a failure to boot down to this patch.  On my Dell Latitude
laptop, it results in the kernel being loaded and then just basically sitting
there dead in the water - as far as I can tell, it dies before the kernel
ever gets going far enough to do any console I/O (even with ignore_loglevel).
Nothing in /sys/fs/pstore either.  I admit not understanding the VM code
at all, so I don't have a clue *why* this causes indigestion...

CPU is an Intel Core i5-3340M in case that matters....


--==_Exmh_1469162592_1957P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV5GkXwdmEQWDXROgAQKZcQ//fZizDH7AE5FDFMhX+f4VCcVMS3G/M0w7
gAxH1KK4BDaRWLIGvSftT3htXgFkWaVUeYMsO5y+70No7QCm15Sph0PcqBVw19uj
SOENWbkuZV236udRgHQuUFMphna47486zYZCDsKheLwa56FoEOKvFTM2cM9NZKHX
virghvACBoT1DfF40J0kC0olQyG3mZQQarLTAqKD8zW70UVBhCz+BfjLlSlyqzBo
f229nRGsSh4se8+wAfhIEqg19+sG7YCVihLCpvHckBV+jh/akQ33pDKhQno1/RIq
yLxXUf7IWvxQJ+sLozPIZ3XDRm+zdQOmidBFracbMc/XQEI7c498BU+5SVbX0PGL
DG18YyDh3El2lUdb8Ssrm5vz25iVcZmZC3F+GXG+ZlEdkByG0BZv15ZQgdrCLdP7
G1PbOabazj2V64tdpkBpYKaWctpAriDzoPxb2IyheLOwsm/iGqx8INP56955D/Xe
gFMthic+snix6Qdhk7p9vjXCX35Ewj0wqGXwq9ZqtuJLWG0HLODVEfE703Vud5Ef
uKBta9lhxrmsNqdvLZIynBineSBIxgk7CfhhcJjXu3TCt4SXwaZY0HET7fvoE4tp
agpIZQG6hZAfeLXXFZ+OELk1Nma4fPA562ptdhI56n9QbELbk8KxiLXn5ntH7XUU
jaIm7aUU2S0=
=WhBH
-----END PGP SIGNATURE-----

--==_Exmh_1469162592_1957P--
