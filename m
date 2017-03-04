Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CAGXu5jKwDdwrdZ8z90e4Q5Xv4KeHjBoVtb7btxPGfmHpdaEwMQ@mail.gmail.com>
Date: Sat, 4 Mar 2017 14:53:20 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <E00348D0-114B-4803-B80E-0500BF3D96D7@gmail.com>
References: <1488466831-13918-1-git-send-email-hoeun.ryu@gmail.com> <CAGXu5jKwDdwrdZ8z90e4Q5Xv4KeHjBoVtb7btxPGfmHpdaEwMQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC] arm64: support HAVE_ARCH_RARE_WRITE
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, PaX Team <pageexec@freemail.hu>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On Mar 3, 2017, at 1:02 PM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Thu, Mar 2, 2017 at 7:00 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>> This RFC is a quick and dirty arm64 implementation for Kees Cook's RFC fo=
r
>> rare_write infrastructure [1].
>=20
> Awesome! :)
>=20
>> This implementation is based on Mark Rutland's suggestions, which is that=

>> a special userspace mm that maps only __start/end_rodata as RW permission=

>> is prepared during early boot time (paging_init) and __arch_rare_write_ma=
p()
>> switches to the mm [2].
>>=20
>> Due to the limit of implementation (the mm having RW mapping is userspace=

>> mm), we need a new arch-specific __arch_rare_write_ptr() to convert RO
>> address to RW address (CONFIG_HAVE_RARE_WRITE_PTR is added), which is
>> general for all architectures (__rare_write_ptr()) in Kees's RFC . So all=

>> writes should be instrumented by __rare_write().
>=20
> Cool, yeah, I'll get all this fixed up in my next version.

I'll send the next version of this when you send yours.

>> One caveat for arm64 is CONFIG_ARM64_SW_TTBR0_PAN.
>> Because __arch_rare_write_map() installes a special user mm to ttbr0,
>> usercopy inside  __arch_rare_write_map/unmap() pair will break rare_write=
.
>> (uaccess_enable() replaces the special mm and RW alias is no longer valid=
.)
>=20
> That's totally fine constraint: this case should never happen for so
> many reasons. :)
>=20

OK. Thank you for the review.

>> A similar problem could rise in general usercopy inside
>> __arch_rare_write_map/unmap(). __arch_rare_write_map() replaces current->=
mm,
>> so we loose the address space of the `current` process.
>>=20
>> It passes LKDTM's rare write test.
>>=20
>> [1] : http://www.openwall.com/lists/kernel-hardening/2017/02/27/5
>> [2] : https://lkml.org/lkml/2017/2/22/254
>>=20
>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>=20
> -Kees
>=20
> --=20
> Kees Cook
> Pixel Security
