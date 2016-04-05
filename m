Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Apr 2016 10:09:23 +0100
From: James Hogan <james.hogan@imgtec.com>
Message-ID: <20160405090923.GF31316@jhogan-linux.le.imgtec.org>
References: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
 <CAGXu5jKMLcRmMkowF=fUEQdtccTJLR9FEWT4g_zeyZMW4BWQOg@mail.gmail.com>
 <20160404233721.GB26295@linux-mips.org>
 <CAGXu5jJ7P95T0ZyAVZagQ0LZhSg28wxkQxR-tRFkhZsHekrN_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7cm2iqirTL37Ot+N"
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ7P95T0ZyAVZagQ0LZhSg28wxkQxR-tRFkhZsHekrN_Q@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v2 00/11] MIPS relocatable kernel &
 KASLR
To: Kees Cook <keescook@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Aaro
 Koskinen <aaro.koskinen@nokia.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexander Sverdlin <alexander.sverdlin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, David Daney <ddaney@caviumnetworks.com>, Jaedon Shin <jaedon.shin@gmail.com>, Jonas Gorski <jogo@openwrt.org>, Paul
 Burton <paul.burton@imgtec.com>
List-ID: <kernel-hardening.lists.openwall.com>

--7cm2iqirTL37Ot+N
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 04, 2016 at 04:56:58PM -0700, Kees Cook wrote:
> On Mon, Apr 4, 2016 at 4:37 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> > On Mon, Apr 04, 2016 at 12:46:29PM -0700, Kees Cook wrote:
> >
> >> This is great! Thanks for working on this! :)
> >>
> >> Without actually reading the code yet, I wonder if the x86 and MIPS
> >> relocs tool could be merged at all? Sounds like it might be more
> >> difficult though -- the relocation output is different and its storage
> >> location is different...
> >>
> >> > Restrictions:
> >> > * The new kernel is not allowed to overlap the old kernel, such that
> >> >   the original kernel can still be booted if relocation fails.
> >>
> >> This sounds like physical-only relocation then? Is the virtual offset
> >> randomized as well (like arm64) or just physical (like x86 currently
> >> -- though there is a series to fix this).
> >
> > On MIPS we normally place the kernel in KSEG0 or XKPHYS which address
> > segments which are not mapped through the TLB so the difference is
> > kinda moot.
>=20
> Ah-ha, excellent. Does this mean that MIPS is effectively doing memory
> segmentation between userspace and kernel space (or some version of
> x86's SMEP/SMAP or ARM's PXN/PAN)? I don't know much about the MIPS
> architecture yet.

User and kernel virtual address spaces don't traditionally overlap, so
you don't get that sort of protection at the moment.

MIPS TLBs do have ASIDs though, and kernel mappings are marked global,
so it could easily reserve an ASID with no mappings, and switch to that
while in kernel mode. It'd have to keep switching between them when
reading/writing userland though, as you can't directly access another
ASID, and I don't think thats a particularly cheap operation, especially
on cores with hardware page table walkers.

EVA (enhanced virtual addressing) is a feature present on recent MIPS
32-bit i-class and p-class cores (and p6600 too which is 64-bit),
intended to make better use of 32-bit virtual address space. It can
actually overlap kernel and virtual address space, requiring special
instructions for accessing userland mappings, however each segment can't
have distinct TLB mappings for kernel and user mode (if kernel and user
view of segment differs, kernel would need to see it unmapped, i.e. a
window into physical memory). As such its generally better to keep the
lowest segment visible to both kernel and user, so that kernel NULL
dereferences can still be caught, which would negate the point of using
it for security. It is possible to make it work with watchpoints to
catch NULL dereferences in lowest 4KB, so kernel can't access any user
address space directly, but thats a bit of a hack really. Also since EVA
is aimed at making better use of 32-bit address space, it doesn't
address 64-bit.

>=20
> What do I need to fill in on these tables for MIPS?
>=20
> http://kernsec.org/wiki/index.php/Exploit_Methods/Userspace_execution
> http://kernsec.org/wiki/index.php/Exploit_Methods/Userspace_data_usage

Both are best addressed using ASID switching in my opinion at the
moment.

Cheers
James

>=20
> >
> >> > * Relocation is supported only by multiples of 64k bytes. This
> >> >   eliminates the need to handle R_MIPS_LO16 relocations as the bottom
> >> >   16bits will remain the same at the relocated address.
> >>
> >> IIUC, that's actually better than x86, which needs to be 2MB aligned.
> >
> > On MIPS a key concern was maintaining a reasonable size for the final
> > kernel image.  The R_MIPS_LO16 relocatio records make a significant
> > portion of the relocations in a relocatable .o file, so we wanted to
> > get rid of them.  This results in a relocation granularity of 64kB.
> > If we were truely, truely stingy we could come up with a relocation for=
mat
> > to save a few more bits but I doubt that'd make any sense.
> >
> >> > * In 64 bit kernels, relocation is supported only within the same 4Gb
> >> >   memory segment as the kernel link address (CONFIG_PHYSICAL_START).
> >> >   This eliminates the need to handle R_MIPS_HIGHEST and R_MIPS_HIGHER
> >> >   relocations as the top 32bits will remain the same at the relocated
> >> >   address.
> >>
> >> Interesting. Could the relocation code be updated in the future to
> >> bump the high addresses too?
> >
> > It could but yet again, the idea was to keep the size of the final
> > generated file under control.  The R_MIPS_HIGHER and R_MIPS_HIGHEST
> > relocations can be discarded if we constrain the addresses to be in
> > a single 4GB segment.  Removing this constraint would make a kernel
> > image much bigger so I suggested to add this restriction at least for
> > this initial version.
>=20
> Awesome, thanks for the details.
>=20
> -Kees
>=20
> --=20
> Kees Cook
> Chrome OS & Brillo Security

--7cm2iqirTL37Ot+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXA4DDAAoJEGwLaZPeOHZ689sQAJgT4L9JXFTxyfQNT5V88Ceo
IKGwpq6Z+wXljj+X+M7qpyNq8tSQIQiInc8Eh29s81KZCd+CURhX2PjGU0m2wpJF
vSXMzwMhOPV+nN3PR8n6elMJxR21v6gKQeeJkjVJs2DcHdWwe1HJOZK4Es/02dEo
ltWT6RPjetfto+AtIbtTByvqY9vq1Kgk7AyWkAw3vBmXZQ+9fNYVd46KlIs8+4Wa
9yTFTBvp5a5/Sw+4rmH7uoy626QVzm5pJ7tFp+PiPd+cJOQiSpxri9wtluBwTVMP
dUs9MefcdlLBA3L7KqtinUV0jN3sNi4e5OOXgyEef/qE9XXEQ/xoDh4cibxG1jEX
dVKQxnUuViOV36kYVVHb30xscuD6EsapDxNUW2cI8N0GsTHrqJeWnW/LAxSJPeWL
MdOlbALhjoQK0JwDfG/pbMBaEudMB7d6I0u6U2x80CmPuM+shCTvNmJrtZDNfo4N
XvHzxvS5/HyPzGKqpwjLSCY1vXOUPx1TMSoLuO3m1l8bqMKhZe0P+7oLWO7rOc/Y
bXCdWgF++msjTALTnJ7MccxJx+LBkw57LhifnOAkshzpHfCr0+laYtnqOdr9Htel
a4lKM4CNldwUU0yIZXgg351VD3sTLvfp2etRq5kQ949l6JmIoEU/YLcqA/SpKf2b
u8q5EBv/6ee09ultPufS
=8b4a
-----END PGP SIGNATURE-----

--7cm2iqirTL37Ot+N--
