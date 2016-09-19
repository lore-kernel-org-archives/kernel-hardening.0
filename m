Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2016 23:57:17 +0100
From: James Hogan <james.hogan@imgtec.com>
Message-ID: <20160919225717.GO18931@jhogan-linux.le.imgtec.org>
References: <20160916203819.GA29767@roeck-us.net>
 <20160916212720.GA18931@jhogan-linux.le.imgtec.org>
 <20160916213718.GA32384@roeck-us.net>
 <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
 <CAGXu5jLYGcSq0Sdm4Mmd12dAJUbiyrkU-+4RwbHoo=OpWfvNFg@mail.gmail.com>
 <20160919135954.GJ18931@jhogan-linux.le.imgtec.org>
 <CAGXu5jKxULh3+bUPa4vjqSW52xSEHWon9aLgKQ03Vv_DdZs3TA@mail.gmail.com>
 <20160919213741.GN18931@jhogan-linux.le.imgtec.org>
 <CAGXu5jL6J3PNkxMi7UXj7jPVr6AQuHeMb2mygL4Y9thyi5M2TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MmQIYbZiCoQ2kDro"
Content-Disposition: inline
In-Reply-To: <CAGXu5jL6J3PNkxMi7UXj7jPVr6AQuHeMb2mygL4Y9thyi5M2TA@mail.gmail.com>
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow
 to cancel kthread work'
To: Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--MmQIYbZiCoQ2kDro
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 02:51:54PM -0700, Kees Cook wrote:
> On Mon, Sep 19, 2016 at 2:37 PM, James Hogan <james.hogan@imgtec.com> wro=
te:
> > Okay, I just built x86_64 default defconfig (on ef98de028afd, half way
> > through the mm patches on linux-next from the other day where metag
> > stopped booting). Perhaps I'm missing some important config option to
> > enable the memory protection (if so I appologise).
> >
> > For metag:
> >
> > $ readelf -S drivers/tty/pty.o
> >   [Nr] Name              Type            Addr     Off    Size   ES Flg =
Lk Inf Al
> >   [51] .data..ro_after_i PROGBITS        00000000 00f0c0 00007c 00  WA =
 0   0  4
> >
> > $ readelf -S vmlinux.bust:
> >   [Nr] Name              Type            Addr     Off    Size   ES Flg =
Lk Inf Al
> >   [ 4] .rodata           PROGBITS        40190000 194000 04c9c8 00  WA =
 0   0 64
> >
> > And x86_64:
> >
> > $ readelf -S drivers/tty/pty.o
> >   [Nr] Name              Type             Address           Offset
> >        Size              EntSize          Flags  Link  Info  Align
> >   [18] .data..ro_after_i PROGBITS         0000000000000000  00001140
> >        00000000000000f8  0000000000000000  WA       0     0     64
> >
> > $ readelf -S vmlinux
> >   [Nr] Name              Type             Address           Offset
> >        Size              EntSize          Flags  Link  Info  Align
> >   [ 4] .rodata           PROGBITS         ffffffff81a00000  00c00000
> >        00000000002663d0  0000000000000000  WA       0     0     4096
> >
> > Both have WA on that section in the object file and the final vmlinux
> > ELF too.
>=20
> Hm, very true, I never noticed that. Oddly, the LOAD flags don't pay
> any attention on x86:
>=20
> $ readelf -l vmlinux
>=20
> Elf file type is EXEC (Executable file)
> Entry point 0x1000000
> There are 5 program headers, starting at offset 64
>=20
> Program Headers:
>   Type           Offset             VirtAddr           PhysAddr
>                  FileSiz            MemSiz              Flags  Align
>   LOAD           0x0000000000200000 0xffffffff81000000 0x0000000001000000
>                  0x0000000000fdc000 0x0000000000fdc000  R E    200000
>   LOAD           0x0000000001200000 0xffffffff82000000 0x0000000002000000
>                  0x0000000000155000 0x0000000000155000  RW     200000
>   LOAD           0x0000000001400000 0x0000000000000000 0x0000000002155000
>                  0x0000000000019488 0x0000000000019488  RW     200000
>   LOAD           0x000000000156f000 0xffffffff8216f000 0x000000000216f000
>                  0x0000000000122000 0x0000000000eb4000  RWE    200000
>   NOTE           0x0000000000ca0248 0xffffffff81aa0248 0x0000000001aa0248
>                  0x0000000000000024 0x0000000000000024         4
>=20
>  Section to Segment mapping:
>   Segment Sections...
>    00     .text .notes __ex_table .rodata __bug_table .pci_fixup
> .builtin_fw .tracedata __ksymtab __ksymtab_gpl __ksymtab_strings
> __param __modver
>    01     .data .vvar
>    02     .data..percpu
>    03     .init.text .altinstr_aux .init.data .x86_cpu_dev.init
> .altinstructions .altinstr_replacement .iommu_table .apicdrivers
> .exit.text .smp_locks .bss .brk
>    04     .notes
>=20
> The first load (containing .rodata) is "R E".

Aah, right, I think thats because the program headers are specified
explicitly in arch/x86/kernel/vmlinux.lds.S:

PHDRS {
	text PT_LOAD FLAGS(5);          /* R_E */
	data PT_LOAD FLAGS(6);          /* RW_ */
#ifdef CONFIG_X86_64
#ifdef CONFIG_SMP
	percpu PT_LOAD FLAGS(6);        /* RW_ */
#endif
	init PT_LOAD FLAGS(7);          /* RWE */
#endif
	note PT_NOTE FLAGS(0);          /* ___ */
}

The bit I was missing is that RO_DATA() is after .text, but before
=2Edata, so counts as part of the PT_LOAD program header for text.

>=20
> But, the point is: the kernel is what sets up the permissions, so the
> flags are ignored anyway.

Indeed.

Thanks for your patience working through this stuff with me :)

Cheers
James

--MmQIYbZiCoQ2kDro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJX4G1NAAoJEGwLaZPeOHZ6uy0P/icDOnP4LH4h1k1SrOKbi6u9
l17ToTaoa3M2Eicq6JuHADorHsryW10CMHbcDRddhZ1tvTudWl/wLfgKHxYBGvJN
jtwFjMt80xrQRvDegA8OgzCqKPtDvzPCNUroEHYkOmhh3mW0b/6O+HZMDTPKusVZ
ePnlZ6zrrCPn5/VmwBUm5GQRaz1iLtEVyH44EgEO19WbT2xRSV73CykEI+AqLDWy
KmoPHcIBfYQpLJYuoUgpX+WBlEAS2i/xIRsq2QJfeCYmxTIR/Btg/0H6oIwLfmIA
f9t685nj4uqj+GL/IzyyrQl+l8BZptcPLieU0EPdDhAPNcYUnkjrYlrjfvVWQQ2s
gqRytCC6d/64D0AflWpKqewsGDiu9YXQEuco5N7ikpvA7o1RvLlvyZUtFyJVEtnP
QCypDHtGs/C5YaCUTX6bcJbBu/HE0m9QnVGwkNyuwhread2YGi07rDaPiRWlTKto
dv/+m7WVoBmMFNEG9yHHKlclLmvD091/FDiqrzykDXPPVuDEb3ZDCwvJXyuV/W1z
VhjCZaiC+9Z6RtPS1BURTrXLpKhXWLK2PdAkwgUd9Xpx07Q/17MfNbG7LAdpVkAI
vXzTJLbIWfpp8SxRmSEEMa4V6tfU2mkyX7Q8+XdrJw5nXdoVzvd9PCPwbAxiKDW2
QppxtndW+Kn9Qn83p17g
=PDQP
-----END PGP SIGNATURE-----

--MmQIYbZiCoQ2kDro--
