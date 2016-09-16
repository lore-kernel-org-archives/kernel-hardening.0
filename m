Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 17 Sep 2016 00:32:49 +0100
From: James Hogan <james.hogan@imgtec.com>
Message-ID: <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
References: <20160916203819.GA29767@roeck-us.net>
 <20160916212720.GA18931@jhogan-linux.le.imgtec.org>
 <20160916213718.GA32384@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <20160916213718.GA32384@roeck-us.net>
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow
 to cancel kthread work'
To: Guenter Roeck <linux@roeck-us.net>, Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2016 at 02:37:18PM -0700, Guenter Roeck wrote:
> On Fri, Sep 16, 2016 at 10:27:20PM +0100, James Hogan wrote:
> > On Fri, Sep 16, 2016 at 01:38:19PM -0700, Guenter Roeck wrote:
> > > Hi,
> > >=20
> > > I see the following runtime error in -next when running a metag qemu =
emulation.
> > >=20
> > > [ ... ]
> > > workingset: timestamp_bits=3D30 max_order=3D16 bucket_order=3D0
> > > io scheduler noop registered (default)
> > > brd: module loaded
> > > Warning: unable to open an initial console.
> > > List of all partitions:
> > > 0100           16384 ram0  (driver?)
> > > No filesystem could mount root, tried:=20
> > > Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-b=
lock(1,0)
> > >=20
> > > An example for a complete log is at:
> > > http://kerneltests.org/builders/qemu-metag-next/builds/489/steps/qemu=
buildcommand/logs/stdio
> > >=20
> > > bisect points to commit ef98de028afde ("kthread: allow to cancel kthr=
ead work").
> > > I don't know (yet) if other architectures are affected. bisect log is=
 attached.
> > >=20
> > > The scripts to run this test are available at
> > > https://github.com/groeck/linux-build-test/tree/master/rootfs/metag.
> > >=20
> > > Guenter
> >=20
> > Thanks Guenter,
> >=20
> > It appears to be related to the command line. After that commit the
> > command line is shown as empty (rather than your "rdinit=3D/sbin/init
> > doreboot"), but it can still be overridden in the config and then it
> > continues to work.
> >=20
> Weird.

Previously the Elf had a single load program header:

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x004000 0x40000000 0x40000000 0x34b304 0x376230 RWE 0x4000
  NOTE           0x1ecc08 0x401e8c08 0x401e8c08 0x00000 0x00000 R   0x4

QEMU puts the args at 40376230, straight after the load region (unlike a
real Meta Linux bootloader).

After the above commit the ELF gets two load program headers, with a
small alignment gap in the middle:

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x004000 0x40000000 0x40000000 0x18f118 0x18f118 R E 0x4000
  LOAD           0x194000 0x40190000 0x40190000 0x1bd304 0x1e8230 RWE 0x4000
  NOTE           0x1eec08 0x401eac08 0x401eac08 0x00000 0x00000 R   0x4

Here this version of QEMU puts the args at where it thinks the end of
the loaded image is, which is based on the number of bytes copied from
the ELF, i.e. the total MemSiz's, not taking into account the alignment
gap in between, so it puts them at 0x40377348.

But of course:
40378230 B ___bss_stop

so it wipes them out while clearing bss during early init.

Previously:
4018ebd0 T __sdata
4018f000 R ___start_rodata

now:
4018ed98 T __sdata
40190000 R ___start_rodata

So I'm thinking this may have been triggered by c74ba8b3480d ("arch:
Introduce post-init read-only memory").

The hack below does indeed reduce it to a single load section and this
version of QEMU then succeeds:

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x004000 0x40000000 0x40000000 0x34d304 0x378230 RWE 0x4000
  NOTE           0x1eec88 0x401eac88 0x401eac88 0x00000 0x00000 R   0x4

diff --git a/arch/metag/include/asm/cache.h b/arch/metag/include/asm/cache.h
index a43b650cfdc0..b5c7364a94da 100644
--- a/arch/metag/include/asm/cache.h
+++ b/arch/metag/include/asm/cache.h
@@ -20,4 +20,6 @@
=20
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
=20
+#define __ro_after_init        __read_mostly
+
 #endif

Kees: Is it expected to get multiple load headers like this since your
patch c74ba8b3480d ("arch: Introduce post-init read-only memory"),
depending on alignment of the read only section?

Cheers
James

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJX3IEhAAoJEGwLaZPeOHZ68EUP/1+IxpxdqITXxGooeYOtGUzi
nwfcx8xhGTu69XTPF0azOlRyiL9oZSiPofyIjrziiZUpOJ5XTqYmbp3nbBOSRuXr
f87frUhsqU4tV9Wa1SOtri3/kYdIWGLanOI0qNjKZG5SOWpCl3llhhjIQ//bCPj+
UBwhUSJEO3h5cNd94qFNECa8A3CVE7BUSFppM2x1u8FoB/YsTOJPDI6iK5GSImYE
ZIjFhtVJFT8kqTIsLGfYedge5MjI/s2xdSt/NU7shcDDXoHvBUQ6ACMC9toEk+bp
+LPa6d+lavGHdDUFO5I/pSfXTyaC+Gh7LPUBymcO+OnhoISyMck12ugMH3Ze9TRP
5eyaT/v7QBzkGpHWl1HkYj9345eKZiLGzhDnhGL5tNWjWyEtnNih7DCEzlhXCiGa
FoWXsoQkHkqMyGHtivzFjn7saPDp+LSKq0anZELL6xpF/nUi7ibngVqTa7g3h+Vc
XcVM06u8yLe6Hut86dvBkNKgxHC0cyyfOPolrI/ZaWkwuK1jJlUuu+y22pTLso2d
xIS/uFxUaf0vrxxHyNublfIkYXRLmC1Dr0c3LEEkROppkQ0SXbOhQJEMwJmeQsea
WtERhwsrwifXviY1tQkun4SsEH73qrJw4j1IF3W9wZ4KyuUhMGfy49u/Da5q4kN1
burUjLKPlLMnH5t2hgo4
=NdO6
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
