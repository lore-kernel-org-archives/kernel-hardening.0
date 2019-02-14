Subject: Re: [RFC PATCH v8 03/14] mm, x86: Add support for eXclusive Page
 Frame Ownership (XPFO)
References: <cover.1550088114.git.khalid.aziz@oracle.com>
 <8275de2a7e6b72d19b1cd2ec5d71a42c2c7dd6c5.1550088114.git.khalid.aziz@oracle.com>
 <20190214105631.GJ32494@hirez.programming.kicks-ass.net>
From: Khalid Aziz <khalid.aziz@oracle.com>
Message-ID: <e157e274-1bdf-0987-bfe9-21c9301578ab@oracle.com>
Date: Thu, 14 Feb 2019 10:13:54 -0700
MIME-Version: 1.0
In-Reply-To: <20190214105631.GJ32494@hirez.programming.kicks-ass.net>
Content-Type: multipart/mixed;
 boundary="------------5EB9E0AEF4F8AD7EE9E16E15"
To: Peter Zijlstra <peterz@infradead.org>, juergh@gmail.com, jsteckli@amazon.de
Cc: tycho@tycho.ws, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com, Juerg Haefliger <juerg.haefliger@canonical.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Tycho Andersen <tycho@docker.com>, Marco Benatto <marco.antonio.780@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is a multi-part message in MIME format.
--------------5EB9E0AEF4F8AD7EE9E16E15
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2/14/19 3:56 AM, Peter Zijlstra wrote:
> On Wed, Feb 13, 2019 at 05:01:26PM -0700, Khalid Aziz wrote:
>>  static inline void *kmap_atomic(struct page *page)
>>  {
>> +	void *kaddr;
>> +
>>  	preempt_disable();
>>  	pagefault_disable();
>> +	kaddr =3D page_address(page);
>> +	xpfo_kmap(kaddr, page);
>> +	return kaddr;
>>  }
>>  #define kmap_atomic_prot(page, prot)	kmap_atomic(page)
>> =20
>>  static inline void __kunmap_atomic(void *addr)
>>  {
>> +	xpfo_kunmap(addr, virt_to_page(addr));
>>  	pagefault_enable();
>>  	preempt_enable();
>>  }
>=20
> How is that supposed to work; IIRC kmap_atomic was supposed to be
> IRQ-safe.
>=20

Ah, the spin_lock in in xpfo_kmap() can be problematic in interrupt
context. I will see if I can fix that.

Juerg, you wrote the original code and understand what you were trying
to do here. If you have ideas on how to tackle this, I would very much
appreciate it.

>> +/* Per-page XPFO house-keeping data */
>> +struct xpfo {
>> +	unsigned long flags;	/* Page state */
>> +	bool inited;		/* Map counter and lock initialized */
>=20
> What's sizeof(_Bool) ? Why can't you use a bit in that flags word?
>=20
>> +	atomic_t mapcount;	/* Counter for balancing map/unmap requests */
>> +	spinlock_t maplock;	/* Lock to serialize map/unmap requests */
>> +};
>=20
> Without that bool, the structure would be 16 bytes on 64bit, which seem=
s
> like a good number.
>=20

Patch 11 ("xpfo, mm: remove dependency on CONFIG_PAGE_EXTENSION") cleans
all this up. If the original authors of these two patches, Juerg
Haefliger and Julian Stecklina, are ok with it, I would like to combine
the two patches in one.

>> +void xpfo_kmap(void *kaddr, struct page *page)
>> +{
>> +	struct xpfo *xpfo;
>> +
>> +	if (!static_branch_unlikely(&xpfo_inited))
>> +		return;
>> +
>> +	xpfo =3D lookup_xpfo(page);
>> +
>> +	/*
>> +	 * The page was allocated before page_ext was initialized (which mea=
ns
>> +	 * it's a kernel page) or it's allocated to the kernel, so nothing t=
o
>> +	 * do.
>> +	 */
>> +	if (!xpfo || unlikely(!xpfo->inited) ||
>> +	    !test_bit(XPFO_PAGE_USER, &xpfo->flags))
>> +		return;
>> +
>> +	spin_lock(&xpfo->maplock);
>> +
>> +	/*
>> +	 * The page was previously allocated to user space, so map it back
>> +	 * into the kernel. No TLB flush required.
>> +	 */
>> +	if ((atomic_inc_return(&xpfo->mapcount) =3D=3D 1) &&
>> +	    test_and_clear_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags))
>> +		set_kpte(kaddr, page, PAGE_KERNEL);
>> +
>> +	spin_unlock(&xpfo->maplock);
>> +}
>> +EXPORT_SYMBOL(xpfo_kmap);
>> +
>> +void xpfo_kunmap(void *kaddr, struct page *page)
>> +{
>> +	struct xpfo *xpfo;
>> +
>> +	if (!static_branch_unlikely(&xpfo_inited))
>> +		return;
>> +
>> +	xpfo =3D lookup_xpfo(page);
>> +
>> +	/*
>> +	 * The page was allocated before page_ext was initialized (which mea=
ns
>> +	 * it's a kernel page) or it's allocated to the kernel, so nothing t=
o
>> +	 * do.
>> +	 */
>> +	if (!xpfo || unlikely(!xpfo->inited) ||
>> +	    !test_bit(XPFO_PAGE_USER, &xpfo->flags))
>> +		return;
>> +
>> +	spin_lock(&xpfo->maplock);
>> +
>> +	/*
>> +	 * The page is to be allocated back to user space, so unmap it from =
the
>> +	 * kernel, flush the TLB and tag it as a user page.
>> +	 */
>> +	if (atomic_dec_return(&xpfo->mapcount) =3D=3D 0) {
>> +		WARN(test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags),
>> +		     "xpfo: unmapping already unmapped page\n");
>> +		set_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
>> +		set_kpte(kaddr, page, __pgprot(0));
>> +		xpfo_flush_kernel_tlb(page, 0);
>> +	}
>> +
>> +	spin_unlock(&xpfo->maplock);
>> +}
>> +EXPORT_SYMBOL(xpfo_kunmap);
>=20
> And these here things are most definitely not IRQ-safe.
>=20

Got it. I will work on this.

Thanks,
Khalid


--------------5EB9E0AEF4F8AD7EE9E16E15
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

--------------5EB9E0AEF4F8AD7EE9E16E15--
