Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2016 22:37:41 +0100
From: James Hogan <james.hogan@imgtec.com>
Message-ID: <20160919213741.GN18931@jhogan-linux.le.imgtec.org>
References: <20160916203819.GA29767@roeck-us.net>
 <20160916212720.GA18931@jhogan-linux.le.imgtec.org>
 <20160916213718.GA32384@roeck-us.net>
 <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
 <CAGXu5jLYGcSq0Sdm4Mmd12dAJUbiyrkU-+4RwbHoo=OpWfvNFg@mail.gmail.com>
 <20160919135954.GJ18931@jhogan-linux.le.imgtec.org>
 <CAGXu5jKxULh3+bUPa4vjqSW52xSEHWon9aLgKQ03Vv_DdZs3TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kUBUi7JBpjcBtem/"
Content-Disposition: inline
In-Reply-To: <CAGXu5jKxULh3+bUPa4vjqSW52xSEHWon9aLgKQ03Vv_DdZs3TA@mail.gmail.com>
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow
 to cancel kthread work'
To: Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--kUBUi7JBpjcBtem/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 12:53:49PM -0700, Kees Cook wrote:
> On Mon, Sep 19, 2016 at 6:59 AM, James Hogan <james.hogan@imgtec.com> wro=
te:
> > On Fri, Sep 16, 2016 at 07:58:12PM -0700, Kees Cook wrote:
> >> On Fri, Sep 16, 2016 at 4:32 PM, James Hogan <james.hogan@imgtec.com> =
wrote:
> >> > On Fri, Sep 16, 2016 at 02:37:18PM -0700, Guenter Roeck wrote:
> >> >> On Fri, Sep 16, 2016 at 10:27:20PM +0100, James Hogan wrote:
> >> >> > On Fri, Sep 16, 2016 at 01:38:19PM -0700, Guenter Roeck wrote:
> >> >> > > Hi,
> >> >> > >
> >> >> > > I see the following runtime error in -next when running a metag=
 qemu emulation.
> >> >> > >
> >> >> > > [ ... ]
> >> >> > > workingset: timestamp_bits=3D30 max_order=3D16 bucket_order=3D0
> >> >> > > io scheduler noop registered (default)
> >> >> > > brd: module loaded
> >> >> > > Warning: unable to open an initial console.
> >> >> > > List of all partitions:
> >> >> > > 0100           16384 ram0  (driver?)
> >> >> > > No filesystem could mount root, tried:
> >> >> > > Kernel panic - not syncing: VFS: Unable to mount root fs on unk=
nown-block(1,0)
> >> >> > >
> >> >> > > An example for a complete log is at:
> >> >> > > http://kerneltests.org/builders/qemu-metag-next/builds/489/step=
s/qemubuildcommand/logs/stdio
> >> >> > >
> >> >> > > bisect points to commit ef98de028afde ("kthread: allow to cance=
l kthread work").
> >> >> > > I don't know (yet) if other architectures are affected. bisect =
log is attached.
> >> >> > >
> >> >> > > The scripts to run this test are available at
> >> >> > > https://github.com/groeck/linux-build-test/tree/master/rootfs/m=
etag.
> >> >> > >
> >> >> > > Guenter
> >> >> >
> >> >> > Thanks Guenter,
> >> >> >
> >> >> > It appears to be related to the command line. After that commit t=
he
> >> >> > command line is shown as empty (rather than your "rdinit=3D/sbin/=
init
> >> >> > doreboot"), but it can still be overridden in the config and then=
 it
> >> >> > continues to work.
> >> >> >
> >> >> Weird.
> >> >
> >> > Previously the Elf had a single load program header:
> >> >
> >> > Program Headers:
> >> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg =
Align
> >> >   LOAD           0x004000 0x40000000 0x40000000 0x34b304 0x376230 RW=
E 0x4000
> >> >   NOTE           0x1ecc08 0x401e8c08 0x401e8c08 0x00000 0x00000 R   =
0x4
> >> >
> >> > QEMU puts the args at 40376230, straight after the load region (unli=
ke a
> >> > real Meta Linux bootloader).
> >> >
> >> > After the above commit the ELF gets two load program headers, with a
> >> > small alignment gap in the middle:
> >> >
> >> > Program Headers:
> >> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg =
Align
> >> >   LOAD           0x004000 0x40000000 0x40000000 0x18f118 0x18f118 R =
E 0x4000
> >> >   LOAD           0x194000 0x40190000 0x40190000 0x1bd304 0x1e8230 RW=
E 0x4000
> >> >   NOTE           0x1eec08 0x401eac08 0x401eac08 0x00000 0x00000 R   =
0x4
> >> >
> >> > Here this version of QEMU puts the args at where it thinks the end of
> >> > the loaded image is, which is based on the number of bytes copied fr=
om
> >> > the ELF, i.e. the total MemSiz's, not taking into account the alignm=
ent
> >> > gap in between, so it puts them at 0x40377348.
> >> >
> >> > But of course:
> >> > 40378230 B ___bss_stop
> >> >
> >> > so it wipes them out while clearing bss during early init.
> >> >
> >> > Previously:
> >> > 4018ebd0 T __sdata
> >> > 4018f000 R ___start_rodata
> >> >
> >> > now:
> >> > 4018ed98 T __sdata
> >> > 40190000 R ___start_rodata
> >> >
> >> > So I'm thinking this may have been triggered by c74ba8b3480d ("arch:
> >> > Introduce post-init read-only memory").
> >> >
> >> > The hack below does indeed reduce it to a single load section and th=
is
> >> > version of QEMU then succeeds:
> >> >
> >> > Program Headers:
> >> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg =
Align
> >> >   LOAD           0x004000 0x40000000 0x40000000 0x34d304 0x378230 RW=
E 0x4000
> >> >   NOTE           0x1eec88 0x401eac88 0x401eac88 0x00000 0x00000 R   =
0x4
> >> >
> >> > diff --git a/arch/metag/include/asm/cache.h b/arch/metag/include/asm=
/cache.h
> >> > index a43b650cfdc0..b5c7364a94da 100644
> >> > --- a/arch/metag/include/asm/cache.h
> >> > +++ b/arch/metag/include/asm/cache.h
> >> > @@ -20,4 +20,6 @@
> >> >
> >> >  #define __read_mostly __attribute__((__section__(".data..read_mostl=
y")))
> >> >
> >> > +#define __ro_after_init        __read_mostly
> >> > +
> >> >  #endif
> >> >
> >> > Kees: Is it expected to get multiple load headers like this since yo=
ur
> >> > patch c74ba8b3480d ("arch: Introduce post-init read-only memory"),
> >> > depending on alignment of the read only section?
> >>
> >> I'm not expecting that, and I'm especially not expecting any LOAD to
> >> have "RWE" flags. It looks like metag's vmlinux.lds.S is using the
> >> common RO_DATA_SECTION, so that doesn't jump out at me as a reason for
> >> RO_AFTER_INIT_DATA to end up in the wrong place. Also the second LOAD
> >> in the ELF is really huge, so it's not just the RO_AFTER_INIT_DATA
> >> section (which is currently very small).
> >>
> >> Could the metag linker be failing to override the section flags when
> >> putting RO_AFTER_INIT_DATA into RO_DATA_SECTION and this cuts the LOAD
> >> in half? This smells like a linker glitch.
> >
> > Where is that section flags override supposed to be happening?
> >
> > The .rodata section is indeed becoming slightly larger to fit the
> > ptmx_fops __ro_after_init, and in the process changing from flag A to
> > flag WA (presumably means becoming writable).
> >
> > This then appears to be hitting the condition in the linker whereby a
> > new segment is started if a writable section is found after a readonly
> > section, and the sections are on separate pages:
> >
> > https://sourceware.org/git/?p=3Dbinutils.git;a=3Dblob;f=3Dbfd/elf.c;h=
=3D8df38ee37923c020994715f111a0ffc6bae83c8c;hb=3DHEAD#l3952
>=20
> Hm, well, I think x86, arm, and arm64 don't do this. They just clobber
> the flags from the section and force it to match the master section
> (i.e. ro_after_init gets rodata's flags).

Okay. Please forgive my ignorance, I'm just trying to understand the
mechanism, but is that thought to happen automatically due to
*(.data..ro_after_init) being in a section after *(.rodata) in the
linker script?

The definition in question is:
static struct file_operations ptmx_fops __ro_after_init;

Which isn't const or anything, so I'm not sure how else the linker is
supposed to know to make a section read-only that contains non-read-only
data.


Okay, I just built x86_64 default defconfig (on ef98de028afd, half way
through the mm patches on linux-next from the other day where metag
stopped booting). Perhaps I'm missing some important config option to
enable the memory protection (if so I appologise).

For metag:

$ readelf -S drivers/tty/pty.o
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk I=
nf Al
  [51] .data..ro_after_i PROGBITS        00000000 00f0c0 00007c 00  WA  0  =
 0  4

$ readelf -S vmlinux.bust:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk I=
nf Al
  [ 4] .rodata           PROGBITS        40190000 194000 04c9c8 00  WA  0  =
 0 64

And x86_64:

$ readelf -S drivers/tty/pty.o
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [18] .data..ro_after_i PROGBITS         0000000000000000  00001140
       00000000000000f8  0000000000000000  WA       0     0     64

$ readelf -S vmlinux
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 4] .rodata           PROGBITS         ffffffff81a00000  00c00000
       00000000002663d0  0000000000000000  WA       0     0     4096

Both have WA on that section in the object file and the final vmlinux
ELF too.

Thanks
James


>=20
> >> However, since metag doesn't support CONFIG_DEBUG_RODATA, your above
> >> patch is likely correct. If metag marks memory read-only at kernel
> >> load time, it's doing it early enough that __ro_after_init will fail
> >> to work. If it never marks memory read-only, then __ro_after_init will
> >> have no effect.
> >
> > Yes, metag doesn't make that memory read only yet, although it would be
> > possible to do so (maybe delaying the switch to 4MB pages until
> > afterwards).
> >
> > Either way it doesn't sound that unreasonable to have multiple load
> > segments generated.
>=20
> The bug here is that the ro_after_init portion of .rodata shouldn't be
> writable according to the ELF headers. It should be writable only
> because memory protection of .rodata hasn't happened yet. :)
>=20
> >> (i.e. Both situations need the proposed patch).
> >
> > purely to avoid the curious linker segment behaviour (which only trips
> > up that QEMU because its broken), or for other reasons too?
>=20
> Well, it means the linker behavior will go away since there will be no
> mixing of sections with different flags, and it'll match current
> expectations: __ro_after_init won't be read-only ever (same as
> .rodata).
>=20
> Fixing memory permissions for metag would be nice, though! :)
>=20
> -Kees
>=20
> >
> > Thanks
> > James
> >
> >>
> >> Probably the best solution for all architectures is to invent a new
> >> CONFIG_ARCH_HAS... to identify the style of kernel memory protection a
> >> given architecture has so that the default for __ro_after_init can be
> >> more sensible (and the warnings about mark_rodata_ro() can better
> >> reflect reality).
> >>
> >> -Kees
> >>
> >> --
> >> Kees Cook
> >> Nexus Security
>=20
>=20
>=20
> --=20
> Kees Cook
> Nexus Security

--kUBUi7JBpjcBtem/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJX4FqkAAoJEGwLaZPeOHZ65DoQAK6huk+JNIP1yZ4l4zs+nYwK
2EEc6T6z2qiXGgzVtHrn3PIa25sRq5f+L3pRd4W/8/ygp/ldRq54aPNGmZixoN9b
AUwvgMl6PbXWcRLE5Bc1X3iV8STiDzSjRJDvyx8Xi5ZHG5BKIaOMyH8J+DBsIJov
1SNE7YAJoxmKGeSkNGRREqRHH5u/tRhJVVe9z5IXr6NBUSV0x+WWiaix10p/oSEO
UhFKHTMnxOqTJXcdEqIZ3dJCPBZLd7FkexwN0XNUbeOo1O+pZA5D5X7q8M5uHj7i
+tEvk9D8gxbkivkqaTm+IQW0vKfM8+M0QDlfEPWQGi+94vOhpkQf15ymt2EEtkDD
f7QueHRO1OtzfoDPXeUQm2iKgrhgHGEohJq4A/Q2SEleGd5o2Zkamg8CRCUtLeT0
t9y7uwm50DTdYEm6CzMuRAxoUGJXl5A6Ulpn0V6/xD+rkO0CHte2H+O+kup+zt2H
Qaiiww7/bqRwUlAkzAW+TgIP0iQeTjqF2j5xmtpuiyBNxRjs54yXWsnTPtGWWFsF
Wk5sY2687g3RY5/pm63slXf3hRnm/UB5QUBrZJx3N9SuqnYKRSWmsYaPkOiFa1Pc
jUk7yt9+XzXyIrcARq4f0nuoljxWvNjqHecP+v3HpkEqcS6QmFl5Oqy3w8LsQuo9
fKEelXaFoARFtKgT/bHZ
=o3Io
-----END PGP SIGNATURE-----

--kUBUi7JBpjcBtem/--
