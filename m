Sender: Valdis Kletnieks <valdis@vt.edu>
From: valdis.kletnieks@vt.edu
Subject: Re: [RFC] Warn the user when they could overflow mapcount
In-Reply-To: <CAG48ez2-MTJ2YrS5fPZi19RY6P_6NWuK1U5CcQpJ25=xrGSy_A@mail.gmail.com>
References: <20180208021112.GB14918@bombadil.infradead.org>
 <CAG48ez2-MTJ2YrS5fPZi19RY6P_6NWuK1U5CcQpJ25=xrGSy_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1518112722_2958P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Feb 2018 12:58:42 -0500
Message-ID: <24367.1518112722@turing-police.cc.vt.edu>
To: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1518112722_2958P
Content-Type: text/plain; charset=us-ascii

On Thu, 08 Feb 2018 03:56:26 +0100, Jann Horn said:

> I wouldn't be too surprised if there are more 32-bit overflows that
> start being realistic once you put something on the order of terabytes
> of memory into one machine, given that refcount_t is 32 bits wide -
> for example, the i_count. See
> https://bugs.chromium.org/p/project-zero/issues/detail?id=809 for an
> example where, given a sufficiently high RLIMIT_MEMLOCK, it was
> possible to overflow a 32-bit refcounter on a system with just ~32GiB
> of free memory (minimum required to store 2^32 64-bit pointers).
>
> On systems with RAM on the order of terabytes, it's probably a good
> idea to turn on refcount hardening to make issues like that
> non-exploitable for now.

I have at least 10 systems across the hall that have 3T of RAM on them
across our various HPC clusters.  So this is indeed no longer a hypothetical
issue.

--==_Exmh_1518112722_2958P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBWnyP0o0DS38y7CIcAQJvMwgAqINtG3XsiyureZeY7FTqdkwoqxA0BUmM
tUkyfbqu/6bfJmdPUOhV4a62wWIULi9xc/yTUcH3Ve/Y71KQVBWfz+QBeeMIihdr
Qh8b6SWWL5gViGCj0uw0d8pbwgzmX/PplJSgupP8j4tf3CyQ7FcrIBpB3p8PfocO
FINFQ/W8JiCVsTGlgmlcwAlTxTzmNP2EF7JoKp4Ugy/cBpxpN8B35/kawTBWirL4
f2OagdWoDdeyu+XyVEaBhybUuGhGVBnbYGELaaJ5A2uGfPhooVZEMzBDZbFgpesu
9jKlkll5COPF3fozpf6idD5uHYaWGUaYRw5rdH+7+eZ59JdRuYZoiw==
=eDZP
-----END PGP SIGNATURE-----

--==_Exmh_1518112722_2958P--
