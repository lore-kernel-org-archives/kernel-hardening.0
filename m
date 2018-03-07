Subject: Re: [PATCH 1/7] genalloc: track beginning of allocations
From: Igor Stoppa <igor.stoppa@huawei.com>
References: <20180228200620.30026-1-igor.stoppa@huawei.com>
 <20180228200620.30026-2-igor.stoppa@huawei.com>
 <20180306131856.GD19349@rapoport-lnx>
 <54e95716-9d61-51a3-9ae8-196e60625b76@huawei.com>
Message-ID: <98df3380-a142-871e-5a18-b356088e33ea@huawei.com>
Date: Wed, 7 Mar 2018 17:46:53 +0200
MIME-Version: 1.0
In-Reply-To: <54e95716-9d61-51a3-9ae8-196e60625b76@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 07/03/18 16:48, Igor Stoppa wrote:
> 
> 
> On 06/03/18 15:19, Mike Rapoport wrote:
>> On Wed, Feb 28, 2018 at 10:06:14PM +0200, Igor Stoppa wrote:

[...]

>>> + * get_boundary() - verifies address, then measure length.
>>
>> There's some lack of consistency between the name and implementation and
>> the description.
>> It seems that it would be simpler to actually make it get_length() and
>> return the length of the allocation or nentries if the latter is smaller.
>> Then in gen_pool_free() there will be no need to recalculate nentries
>> again.
> 
> There is an error in the documentation. I'll explain below.

Argh, I do not know why I came out with that.

Yes, your comment is correct. I've modified the function accordingly and
it is simpler.

I will post it in the next revision.

--
igor
