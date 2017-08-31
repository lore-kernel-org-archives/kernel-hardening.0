References: <20170809200755.11234-1-tycho@docker.com>
 <20170809200755.11234-5-tycho@docker.com> <20170812112603.GB16374@remoulade>
 <20170814163536.6njceqc3dip5lrlu@smitten>
 <20170814165047.GB23428@leverpostej>
 <20170823165842.k5lbxom45avvd7g2@smitten>
 <20170823170443.GD12567@leverpostej>
 <2428d66f-3c31-fa73-0d6a-c16fafa99455@canonical.com>
 <20170830164724.m6bbogd46ix4qp4o@docker>
From: Juerg Haefliger <juerg.haefliger@canonical.com>
Message-ID: <b50951e4-0b80-6d0e-39ed-fd9d67a51db3@canonical.com>
Date: Thu, 31 Aug 2017 11:43:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170830164724.m6bbogd46ix4qp4o@docker>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fgLr3fOp4VrViv2VbGqFTf7gU4qfUfePc"
Subject: Re: [kernel-hardening] [PATCH v5 04/10] arm64: Add __flush_tlb_one()
To: Tycho Andersen <tycho@docker.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fgLr3fOp4VrViv2VbGqFTf7gU4qfUfePc
Content-Type: multipart/mixed; boundary="ELp8Cmm8im7pBRAuUGcd7ff4jns2IGKFu";
 protected-headers="v1"
From: Juerg Haefliger <juerg.haefliger@canonical.com>
To: Tycho Andersen <tycho@docker.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-hardening@lists.openwall.com,
 Marco Benatto <marco.antonio.780@gmail.com>
Message-ID: <b50951e4-0b80-6d0e-39ed-fd9d67a51db3@canonical.com>
Subject: Re: [kernel-hardening] [PATCH v5 04/10] arm64: Add __flush_tlb_one()
References: <20170809200755.11234-1-tycho@docker.com>
 <20170809200755.11234-5-tycho@docker.com> <20170812112603.GB16374@remoulade>
 <20170814163536.6njceqc3dip5lrlu@smitten>
 <20170814165047.GB23428@leverpostej>
 <20170823165842.k5lbxom45avvd7g2@smitten>
 <20170823170443.GD12567@leverpostej>
 <2428d66f-3c31-fa73-0d6a-c16fafa99455@canonical.com>
 <20170830164724.m6bbogd46ix4qp4o@docker>
In-Reply-To: <20170830164724.m6bbogd46ix4qp4o@docker>

--ELp8Cmm8im7pBRAuUGcd7ff4jns2IGKFu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/30/2017 06:47 PM, Tycho Andersen wrote:
> On Wed, Aug 30, 2017 at 07:31:25AM +0200, Juerg Haefliger wrote:
>>
>>
>> On 08/23/2017 07:04 PM, Mark Rutland wrote:
>>> On Wed, Aug 23, 2017 at 10:58:42AM -0600, Tycho Andersen wrote:
>>>> Hi Mark,
>>>>
>>>> On Mon, Aug 14, 2017 at 05:50:47PM +0100, Mark Rutland wrote:
>>>>> That said, is there any reason not to use flush_tlb_kernel_range()
>>>>> directly?
>>>>
>>>> So it turns out that there is a difference between __flush_tlb_one()=
 and
>>>> flush_tlb_kernel_range() on x86: flush_tlb_kernel_range() flushes al=
l the TLBs
>>>> via on_each_cpu(), where as __flush_tlb_one() only flushes the local=
 TLB (which
>>>> I think is enough here).
>>>
>>> That sounds suspicious; I don't think that __flush_tlb_one() is
>>> sufficient.
>>>
>>> If you only do local TLB maintenance, then the page is left accessibl=
e
>>> to other CPUs via the (stale) kernel mappings. i.e. the page isn't
>>> exclusively mapped by userspace.
>>
>> We flush all CPUs to get rid of stale entries when a new page is
>> allocated to userspace that was previously allocated to the kernel.
>> Is that the scenario you were thinking of?
>=20
> I think there are two cases, the one you describe above, where the
> pages are first allocated, and a second one, where e.g. the pages are
> mapped into the kernel because of DMA or whatever. In the case you
> describe above, I think we're doing the right thing (which is why my
> test worked correctly, because it tested this case).
>=20
> In the second case, when the pages are unmapped (i.e. the kernel is
> done doing DMA), do we need to flush the other CPUs TLBs? I think the
> current code is not quite correct, because if multiple tasks (CPUs)
> map the pages, only the TLB of the last one is flushed when the
> mapping is cleared, because the tlb is only flushed when ->mapcount
> drops to zero, leaving stale entries in the other TLBs. It's not clear
> to me what to do about this case.

For this to happen, multiple CPUs need to have the same userspace page
mapped at the same time. Is this a valid scenario?

=2E..Juerg


> Thoughts?
>=20
> Tycho
>=20
>> ...Juerg
>>
>>
>>> Thanks,
>>> Mark.
>>>
>>
>=20
>=20
>=20


--ELp8Cmm8im7pBRAuUGcd7ff4jns2IGKFu--

--fgLr3fOp4VrViv2VbGqFTf7gU4qfUfePc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQI7BAEBCAAlBQJZp9paHhxqdWVyZy5oYWVmbGlnZXJAY2Fub25pY2FsLmNvbQAK
CRB1TDqW+fi0jJHMD/9HJQHGTEIXAqEpruwh3NDK/nJgiCkKSmJIf7UeE7mJNmHE
nhkW2IruFD7VN3YkSBdYIu2cA2dA9b7dZeVgz+OQpYeR1JFstJDVKaq6RHP++Dj4
KLVCEInXJDyFnnYWwGxWyrYsgnJhSDiBlkAsAffGNkvMOvyhYJhNv6RdvTI2kHeQ
nArSp5UIMaAFCBX8A+zIdDjWY3BCo3yfNaGDlmxwLKpJ/JsGmSRRANKs7VCWdOfz
ThnokIQWu4z/YhG9jOrknEvFbgxFdvuuRSGlqpO/HENlkQW6dJPohwUOepMequBa
eeVOC1WBvm4k/dYl5xx+J6LKISz1wYw/u0nCBiQJW1MMzCuQzsAjBZ9Xj7WVkaN0
XPky+rwtfODSu80EqonDRl13enBgz6fX8DEtw4KTQhK7aGs0EJ45kiuNdxrUWgux
DHM3tjraDGiMhsyxxznxU5TipDCbJIPr7NCkr4N/t0WFoSf7F2vtCfCgdI1OSU48
lysD+hfVQvuKeG4tXijvjDRsiTyAVzqbIYbXgecmX1YwoGeVR7QOY0QYtMnBIYSh
ZCmE28hykCyAJBrSQByy4kVkWZmKjC6+jMMysZK0DY0kkJ9uqhtBwOsO7sDD1RxM
7KLevGIEcVmLbCC5pbV2ASAZM2LNAQgKQPSmbb+IkLGK54UGiueCQ7cUOjv00w==
=p2Z7
-----END PGP SIGNATURE-----

--fgLr3fOp4VrViv2VbGqFTf7gU4qfUfePc--
