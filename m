Reply-To: kernel-hardening@lists.openwall.com
References: <20160914071901.8127-1-juerg.haefliger@hpe.com>
 <20161104144534.14790-1-juerg.haefliger@hpe.com>
 <20161104144534.14790-2-juerg.haefliger@hpe.com>
 <20161124105629.GA23034@linaro.org>
From: Juerg Haefliger <juerg.haefliger@hpe.com>
Message-ID: <795a34a6-ed04-dea3-73f5-d23e48f69de6@hpe.com>
Date: Mon, 28 Nov 2016 12:15:10 +0100
MIME-Version: 1.0
In-Reply-To: <20161124105629.GA23034@linaro.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xK83457Tl0b0VsjtiEgrgA8md3HirLXVv"
Subject: [kernel-hardening] Re: [RFC PATCH v3 1/2] Add support for eXclusive Page Frame Ownership
 (XPFO)
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org, vpk@cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xK83457Tl0b0VsjtiEgrgA8md3HirLXVv
Content-Type: multipart/mixed; boundary="7nt0D3PUfp44460FfNLT0gAFB4oxfXvll";
 protected-headers="v1"
From: Juerg Haefliger <juerg.haefliger@hpe.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org,
 vpk@cs.columbia.edu
Message-ID: <795a34a6-ed04-dea3-73f5-d23e48f69de6@hpe.com>
Subject: Re: [RFC PATCH v3 1/2] Add support for eXclusive Page Frame Ownership
 (XPFO)
References: <20160914071901.8127-1-juerg.haefliger@hpe.com>
 <20161104144534.14790-1-juerg.haefliger@hpe.com>
 <20161104144534.14790-2-juerg.haefliger@hpe.com>
 <20161124105629.GA23034@linaro.org>
In-Reply-To: <20161124105629.GA23034@linaro.org>

--7nt0D3PUfp44460FfNLT0gAFB4oxfXvll
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/24/2016 11:56 AM, AKASHI Takahiro wrote:
> Hi,
>=20
> I'm trying to give it a spin on arm64, but ...

Thanks for trying this.


>> +/*
>> + * Update a single kernel page table entry
>> + */
>> +static inline void set_kpte(struct page *page, unsigned long kaddr,
>> +			    pgprot_t prot) {
>> +	unsigned int level;
>> +	pte_t *kpte =3D lookup_address(kaddr, &level);
>> +
>> +	/* We only support 4k pages for now */
>> +	BUG_ON(!kpte || level !=3D PG_LEVEL_4K);
>> +
>> +	set_pte_atomic(kpte, pfn_pte(page_to_pfn(page), canon_pgprot(prot)))=
;
>> +}
>=20
> As lookup_address() and set_pte_atomic() (and PG_LEVEL_4K), are arch-sp=
ecific,
> would it be better to put the whole definition into arch-specific part?=


Well yes but I haven't really looked into splitting up the arch specific =
stuff.


>> +		/*
>> +		 * Map the page back into the kernel if it was previously
>> +		 * allocated to user space.
>> +		 */
>> +		if (test_and_clear_bit(PAGE_EXT_XPFO_UNMAPPED,
>> +				       &page_ext->flags)) {
>> +			kaddr =3D (unsigned long)page_address(page + i);
>> +			set_kpte(page + i,  kaddr, __pgprot(__PAGE_KERNEL));
>=20
> Why not PAGE_KERNEL?

Good catch, thanks!


>> +	/*
>> +	 * The page is to be allocated back to user space, so unmap it from =
the
>> +	 * kernel, flush the TLB and tag it as a user page.
>> +	 */
>> +	if (atomic_dec_return(&page_ext->mapcount) =3D=3D 0) {
>> +		BUG_ON(test_bit(PAGE_EXT_XPFO_UNMAPPED, &page_ext->flags));
>> +		set_bit(PAGE_EXT_XPFO_UNMAPPED, &page_ext->flags);
>> +		set_kpte(page, (unsigned long)kaddr, __pgprot(0));
>> +		__flush_tlb_one((unsigned long)kaddr);
>=20
> Again __flush_tlb_one() is x86-specific.
> flush_tlb_kernel_range() instead?

I'll take a look. If you can tell me what the relevant arm64 equivalents =
are for the arch-specific
functions, that would help tremendously.

Thanks for the comments!

=2E..Juerg



> Thanks,
> -Takahiro AKASHI


--=20
Juerg Haefliger
Hewlett Packard Enterprise


--7nt0D3PUfp44460FfNLT0gAFB4oxfXvll--

--xK83457Tl0b0VsjtiEgrgA8md3HirLXVv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYPBG+AAoJEHVMOpb5+LSMYaUP/ivlQhGWbPz1scInxJxIBSSL
dHPcug/WEH2XjLIfm1BEhWVNMBYSUrVN/eWWcWE7BjYh7O+/makinUSIESNcbTPw
uuA5NiMtsBEBgjgReq+hWC/yLJg0P3HFxFIdlg6nl8QnbGe3xT31UUm3/KxowaEb
QcCvONwXl46FxpCMoQxq8Y4+2oSJm7Skaxp3lP3zPPuLClOvucxtbWOFM77nompO
1GagLX+kssFGKYNlUdkNlEK487hbLNkOx4Ipz9IqoPLvRNiYSJCjVlelFYkV6dfz
UzBPbchD/HHiGIs8jPZFucGeFgMr9SMRNhJ6yMDfHjNXGsw1PycW93MVU3h2wIUH
y+jW1IXmMiOI8q89sHPIAJtBYxRxDIStYmmd6XpdFhEmdhQwTJpR0uObwigDxcHz
qvy88HvWepH8OnT/XkKfNNT7/HuVkg/jYbmraiLYP+ALWQBJg+iStaQ5bsRGtosh
eQ17odAAs1438iWIaqSr84KtffSsKO+bNARWXAOhd2RPOoJAsWudpl/EkNQ+fyWd
Lm0X2UfLQJ9MPRIdfXhFL0LkHGOYHfzut/8yG9KKTglV/sSoxDjtkbsWIm9TgyYT
wpVs1zRAU9JUOfMkPeb+ih0oYZy7KZ1dJNSYPuBcfsQhHEeAAWYu539L51kmbPyu
sB/zTqnSlUBfM71Ha3fV
=GxFB
-----END PGP SIGNATURE-----

--xK83457Tl0b0VsjtiEgrgA8md3HirLXVv--
