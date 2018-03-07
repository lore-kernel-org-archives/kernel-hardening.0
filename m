Date: Wed, 07 Mar 2018 19:44:28 +0200
In-Reply-To: <54e95716-9d61-51a3-9ae8-196e60625b76@huawei.com>
References: <20180228200620.30026-1-igor.stoppa@huawei.com> <20180228200620.30026-2-igor.stoppa@huawei.com> <20180306131856.GD19349@rapoport-lnx> <54e95716-9d61-51a3-9ae8-196e60625b76@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/7] genalloc: track beginning of allocations
From: Mike Rapoprt <rppt@linux.vnet.ibm.com>
Message-Id: <E69B22D6-8E5F-44EB-8C2B-C93960C08510@linux.vnet.ibm.com>
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On March 7, 2018 4:48:25 PM GMT+02:00, Igor Stoppa <igor=2Estoppa@huawei=
=2Ecom> wrote:
>
>
>On 06/03/18 15:19, Mike Rapoport wrote:
>> On Wed, Feb 28, 2018 at 10:06:14PM +0200, Igor Stoppa wrote:
>
>[=2E=2E=2E]
>
>> If I'm not mistaken, several kernel-doc descriptions are duplicated
>now=2E
>> Can you please keep a single copy? ;-)
>
>What's the preferred approach?
>Document the functions that are API in the =2Eh file and leave in the =2E=
c
>those which are not API?

I aggree with Matthew: "we usually recommend putting it with the definitio=
n so it's more likely to be updated=2E"

I couldn't find the doc with this recommendation, though :)


>[=2E=2E=2E]
>
>>> + * The alignment at which to perform the research for sequence of
>empty
>>=20
>>                                            ^ search?
>
>yes
>
>>> + * get_boundary() - verifies address, then measure length=2E
>>=20
>> There's some lack of consistency between the name and implementation
>and
>> the description=2E
>> It seems that it would be simpler to actually make it get_length()
>and
>> return the length of the allocation or nentries if the latter is
>smaller=2E
>> Then in gen_pool_free() there will be no need to recalculate nentries
>> again=2E
>
>There is an error in the documentation=2E I'll explain below=2E
>
>>=20
>>>   * @map: pointer to a bitmap
>>> - * @start: a bit position in @map
>>> - * @nr: number of bits to set
>>> + * @start_entry: the index of the first entry in the bitmap
>>> + * @nentries: number of entries to alter
>>=20
>> Maybe: "maximal number of entries to check"?
>
>No, it's actually the total number of entries in the chunk=2E
>
>[=2E=2E=2E]
>
>>> +	return nentries - start_entry;
>>=20
>> Shouldn't it be "nentries + start_entry"?
>
>And in the light of the correct comment, also what I am doing should be
>now more clear:
>
>* start_entry is the index of the initial entry
>* nentries is the number of entries in the chunk
>
>If I iterate over the rest of the chunk:
>
>(i =3D start_entry + 1; i < nentries; i++)
>
>without finding either another HEAD or an empty slot, then it means I
>was measuring the length of the last allocation in the chunk, which was
>taking up all the space, to the end=2E
>
>Simple example:
>
>- chunk with 7 entries -> nentries is 7
>- start_entry is 2, meaning that the last allocation starts from the
>3rd
>element, iow it occupies indexes from 2 to 6, for a total of 5 entries
>- so the length is (nentries - start_entry) =3D (7 - 2) =3D 5
>
>
>But yeah, the kerneldoc was wrong=2E
>
>[=2E=2E=2E]
>
>>> - * gen_pool_alloc_algo - allocate special memory from the pool
>>> + * gen_pool_alloc_algo() - allocate special memory from the pool
>>=20
>> + using specified algorithm
>
>ok
>
>>=20
>>>   * @pool: pool to allocate from
>>>   * @size: number of bytes to allocate from the pool
>>>   * @algo: algorithm passed from caller
>>> @@ -285,14 +502,18 @@ EXPORT_SYMBOL(gen_pool_alloc);
>>>   * Uses the pool allocation function (with first-fit algorithm by
>default)=2E
>>=20
>> "uses the provided @algo function to find room for the allocation"
>
>ok
>
>--
>igor

--=20
Sincerely yours,
Mike=2E
