Subject: Re: [RFC PATCH v7 05/16] arm64/mm: Add support for XPFO
References: <cover.1547153058.git.khalid.aziz@oracle.com>
 <89f03091af87f5ab27bd6cafb032236d5bd81d65.1547153058.git.khalid.aziz@oracle.com>
 <20190123142047.GB19289@Konrads-MacBook-Pro.local>
From: Khalid Aziz <khalid.aziz@oracle.com>
Message-ID: <0ea68b21-ac03-e9d1-3285-14e6084e10fa@oracle.com>
Date: Tue, 12 Feb 2019 08:45:41 -0700
MIME-Version: 1.0
In-Reply-To: <20190123142047.GB19289@Konrads-MacBook-Pro.local>
Content-Type: multipart/mixed;
 boundary="------------CE9BD2F746D7F2667607891B"
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, Juerg Haefliger <juerg.haefliger@canonical.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, joao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is a multi-part message in MIME format.
--------------CE9BD2F746D7F2667607891B
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 1/23/19 7:20 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 10, 2019 at 02:09:37PM -0700, Khalid Aziz wrote:
>> From: Juerg Haefliger <juerg.haefliger@canonical.com>
>>
>> Enable support for eXclusive Page Frame Ownership (XPFO) for arm64 and=

>> provide a hook for updating a single kernel page table entry (which is=

>> required by the generic XPFO code).
>>
>> v6: use flush_tlb_kernel_range() instead of __flush_tlb_one()
>>
>> CC: linux-arm-kernel@lists.infradead.org
>> Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
>> Signed-off-by: Tycho Andersen <tycho@docker.com>
>> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
>> ---
>>  arch/arm64/Kconfig     |  1 +
>>  arch/arm64/mm/Makefile |  2 ++
>>  arch/arm64/mm/xpfo.c   | 58 +++++++++++++++++++++++++++++++++++++++++=
+
>>  3 files changed, 61 insertions(+)
>>  create mode 100644 arch/arm64/mm/xpfo.c
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index ea2ab0330e3a..f0a9c0007d23 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -171,6 +171,7 @@ config ARM64
>>  	select SWIOTLB
>>  	select SYSCTL_EXCEPTION_TRACE
>>  	select THREAD_INFO_IN_TASK
>> +	select ARCH_SUPPORTS_XPFO
>>  	help
>>  	  ARM 64-bit (AArch64) Linux support.
>> =20
>> diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
>> index 849c1df3d214..cca3808d9776 100644
>> --- a/arch/arm64/mm/Makefile
>> +++ b/arch/arm64/mm/Makefile
>> @@ -12,3 +12,5 @@ KASAN_SANITIZE_physaddr.o	+=3D n
>> =20
>>  obj-$(CONFIG_KASAN)		+=3D kasan_init.o
>>  KASAN_SANITIZE_kasan_init.o	:=3D n
>> +
>> +obj-$(CONFIG_XPFO)		+=3D xpfo.o
>> diff --git a/arch/arm64/mm/xpfo.c b/arch/arm64/mm/xpfo.c
>> new file mode 100644
>> index 000000000000..678e2be848eb
>> --- /dev/null
>> +++ b/arch/arm64/mm/xpfo.c
>> @@ -0,0 +1,58 @@
>> +/*
>> + * Copyright (C) 2017 Hewlett Packard Enterprise Development, L.P.
>> + * Copyright (C) 2016 Brown University. All rights reserved.
>> + *
>> + * Authors:
>> + *   Juerg Haefliger <juerg.haefliger@hpe.com>
>> + *   Vasileios P. Kemerlis <vpk@cs.brown.edu>
>> + *
>> + * This program is free software; you can redistribute it and/or modi=
fy it
>> + * under the terms of the GNU General Public License version 2 as pub=
lished by
>> + * the Free Software Foundation.
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <linux/module.h>
>> +
>> +#include <asm/tlbflush.h>
>> +
>> +/*
>> + * Lookup the page table entry for a virtual address and return a poi=
nter to
>> + * the entry. Based on x86 tree.
>> + */
>> +static pte_t *lookup_address(unsigned long addr)
>=20
> The x86 also has level. Would it make sense to include that in here?
>=20

Possibly. ARM64 does not define page levels (as in the enum for page
levels) at this time but that can be added easily. Adding level to
lookup_address() for arm will make it uniform with x86 but is there any
other rationale besides that? Do you see a future use for this
information? The only other architecture I could see that defines
lookup_address() is sh but it uses it for trapped io only.

Thanks,
Khalid

--------------CE9BD2F746D7F2667607891B
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

mQGNBFwdSxMBDACs4wtsihnZ9TVeZBZYPzcj1sl7hz41PYvHKAq8FfBOl4yC6ghp
U0FDo3h8R7ze0VGU6n5b+M6fbKvOpIYT1r02cfWsKVtcssCyNhkeeL5A5X9z5vgt
QnDDhnDdNQr4GmJVwA9XPvB/Pa4wOMGz9TbepWfhsyPtWsDXjvjFLVScOorPddrL
/lFhriUssPrlffmNOMKdxhqGu6saUZN2QBoYjiQnUimfUbM6rs2dcSX4SVeNwl9B
2LfyF3kRxmjk964WCrIp0A2mB7UUOizSvhr5LqzHCXyP0HLgwfRd3s6KNqb2etes
FU3bINxNpYvwLCy0xOw4DYcerEyS1AasrTgh2jr3T4wtPcUXBKyObJWxr5sWx3sz
/DpkJ9jupI5ZBw7rzbUfoSV3wNc5KBZhmqjSrc8G1mDHcx/B4Rv47LsdihbWkeeB
PVzB9QbNqS1tjzuyEAaRpfmYrmGM2/9HNz0p2cOTsk2iXSaObx/EbOZuhAMYu4zH
y744QoC+Wf08N5UAEQEAAbQkS2hhbGlkIEF6aXogPGtoYWxpZC5heml6QG9yYWNs
ZS5jb20+iQHUBBMBCAA+FiEErS+7JMqGyVyRyPqp4t2wFa8wz0MFAlwdSxQCGwMF
CQHhM4AFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQ4t2wFa8wz0PaZwv/b55t
AIoG8+KHig+IwVqXwWTpolhs+19mauBqRAK+/vPU6wvmrzJ1cz9FTgrmQf0GAPOI
YZvSpH8Z563kAGRxCi9LKX1vM8TA60+0oazWIP8epLudAsQ3xbFFedc0LLoyWCGN
u/VikES6QIn+2XaSKaYfXC/qhiXYJ0fOOXnXWv/t2eHtaGC1H+/kYEG5rFtLnILL
fyFnxO3wf0r4FtLrvxftb6U0YCe4DSAed+27HqpLeaLCVpv/U+XOfe4/Loo1yIpm
KZwiXvc0G2UUK19mNjp5AgDKJHwZHn3tS/1IV/mFtDT9YkKEzNs4jYkA5FzDMwB7
RD5l/EVf4tXPk4/xmc4Rw7eB3X8z8VGw5V8kDZ5I8xGIxkLpgzh56Fg420H54a7m
714aI0ruDWfVyC0pACcURTsMLAl4aN6E0v8rAUQ1vCLVobjNhLmfyJEwLUDqkwph
rDUagtEwWgIzekcyPW8UaalyS1gG7uKNutZpe/c9Vr5Djxo2PzM7+dmSMB81uQGN
BFwdSxMBDAC8uFhUTc5o/m49LCBTYSX79415K1EluskQkIAzGrtLgE/8DHrt8rtQ
FSum+RYcA1L2aIS2eIw7M9Nut9IOR7YDGDDP+lcEJLa6L2LQpRtO65IHKqDQ1TB9
la4qi+QqS8WFo9DLaisOJS0jS6kO6ySYF0zRikje/hlsfKwxfq/RvZiKlkazRWjx
RBnGhm+niiRD5jOJEAeckbNBhg+6QIizLo+g4xTnmAhxYR8eye2kG1tX1VbIYRX1
3SrdObgEKj5JGUGVRQnf/BM4pqYAy9szEeRcVB9ZXuHmy2mILaX3pbhQF2MssYE1
KjYhT+/U3RHfNZQq5sUMDpU/VntCd2fN6FGHNY0SHbMAMK7CZamwlvJQC0WzYFa+
jq1t9ei4P/HC8yLkYWpJW2yuxTpD8QP9yZ6zY+htiNx1mrlf95epwQOy/9oS86Dn
MYWnX9VP8gSuiESUSx87gD6UeftGkBjoG2eX9jcwZOSu1YMhKxTBn8tgGH3LqR5U
QLSSR1ozTC0AEQEAAYkBvAQYAQgAJhYhBK0vuyTKhslckcj6qeLdsBWvMM9DBQJc
HUsTAhsMBQkB4TOAAAoJEOLdsBWvMM9D8YsL/0rMCewC6L15TTwer6GzVpRwbTuP
rLtTcDumy90jkJfaKVUnbjvoYFAcRKceTUP8rz4seM/R1ai78BS78fx4j3j9qeWH
rX3C0k2aviqjaF0zQ86KEx6xhdHWYPjmtpt3DwSYcV4Gqefh31Ryl5zO5FIz5yQy
Z+lHCH+oBD51LMxrgobUmKmT3NOhbAIcYnOHEqsWyGrXD9qi0oj1Cos/t6B2oFaY
IrLdMkklt+aJYV4wu3gWRW/HXypgeo0uDWOowfZSVi/u5lkn9WMUUOjIeL1IGJ7x
U4JTAvt+f0BbX6b1BIC0nygMgdVe3tgKPIlniQc24Cj8pW8D8v+K7bVuNxxmdhT4
71XsoNYYmmB96Z3g6u2s9MY9h/0nC7FI6XSk/z584lGzzlwzPRpTOxW7fi/E/38o
E6wtYze9oihz8mbNHY3jtUGajTsv/F7Jl42rmnbeukwfN2H/4gTDV1sB/D8z5G1+
+Wrj8Rwom6h21PXZRKnlkis7ibQfE+TxqOI7vg=3D=3D
=3DnPqY
-----END PGP PUBLIC KEY BLOCK-----

--------------CE9BD2F746D7F2667607891B--
