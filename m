Subject: Re: [PATCH] x86/xen: Remove use of VLAs
References: <20180413221146.28476-1-labbott@redhat.com>
 <7cf66c00-74c2-62bb-81f5-4332313a5a6e@oracle.com>
 <e63f261b-9ef3-5750-20df-555291a8a0d8@suse.com>
 <9fe26cf5-01dc-1fb0-25fd-29bf8615047f@redhat.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <aa447403-766c-8311-5c95-a352b39e019a@oracle.com>
Date: Tue, 17 Apr 2018 19:40:13 -0400
MIME-Version: 1.0
In-Reply-To: <9fe26cf5-01dc-1fb0-25fd-29bf8615047f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Laura Abbott <labbott@redhat.com>, Juergen Gross <jgross@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 04/17/2018 07:33 PM, Laura Abbott wrote:
> On 04/17/2018 12:16 AM, Juergen Gross wrote:
>> On 16/04/18 15:27, Boris Ostrovsky wrote:
>>> On 04/13/2018 06:11 PM, Laura Abbott wrote:
>>>> There's an ongoing effort to remove VLAs[1] from the kernel to
>>>> eventually
>>>> turn on -Wvla. The few VLAs in use have an upper bound based on a size
>>>> of 64K. This doesn't produce an excessively large stack so just switch
>>>> the upper bound.
>>>>
>>>> [1] https://lkml.org/lkml/2018/3/7/621
>>>>
>>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>>> ---
>>>>   arch/x86/xen/enlighten_pv.c | 6 ++----
>>>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
>>>> index c36d23aa6c35..d96a5a535cbb 100644
>>>> --- a/arch/x86/xen/enlighten_pv.c
>>>> +++ b/arch/x86/xen/enlighten_pv.c
>>>> @@ -421,8 +421,7 @@ static void xen_load_gdt(const struct desc_ptr
>>>> *dtr)
>>>>   {
>>>>       unsigned long va = dtr->address;
>>>>       unsigned int size = dtr->size + 1;
>>>> -    unsigned pages = DIV_ROUND_UP(size, PAGE_SIZE);
>>>
>>>
>>>
>>> Isn't dtr->size always either GDT_SIZE or 0?
>>
>> GDT_SIZE - 1 :-)
>>
>>>> -    unsigned long frames[pages];
>>>> +    unsigned long frames[DIV_ROUND_UP(SZ_64K, PAGE_SIZE)];
>>
>> So we could just go with one frame and modify the BUG_ON() further below
>> accordingly.
>>
>
> Do you want to just remove the loop as well since we're never going
> to do more than one frame? We end up with net code deletion.
>


Yes, the loop, as well as the comment about max size being 64K can all
be removed.

-boris
