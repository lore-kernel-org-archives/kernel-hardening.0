Subject: Re: [PATCH] x86/xen: Remove use of VLAs
References: <20180413221146.28476-1-labbott@redhat.com>
 <7cf66c00-74c2-62bb-81f5-4332313a5a6e@oracle.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <e63f261b-9ef3-5750-20df-555291a8a0d8@suse.com>
Date: Tue, 17 Apr 2018 09:16:41 +0200
MIME-Version: 1.0
In-Reply-To: <7cf66c00-74c2-62bb-81f5-4332313a5a6e@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, Laura Abbott <labbott@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 16/04/18 15:27, Boris Ostrovsky wrote:
> On 04/13/2018 06:11 PM, Laura Abbott wrote:
>> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
>> turn on -Wvla. The few VLAs in use have an upper bound based on a size
>> of 64K. This doesn't produce an excessively large stack so just switch
>> the upper bound.
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>  arch/x86/xen/enlighten_pv.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
>> index c36d23aa6c35..d96a5a535cbb 100644
>> --- a/arch/x86/xen/enlighten_pv.c
>> +++ b/arch/x86/xen/enlighten_pv.c
>> @@ -421,8 +421,7 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
>>  {
>>  	unsigned long va = dtr->address;
>>  	unsigned int size = dtr->size + 1;
>> -	unsigned pages = DIV_ROUND_UP(size, PAGE_SIZE);
> 
> 
> 
> Isn't dtr->size always either GDT_SIZE or 0?

GDT_SIZE - 1 :-)

>> -	unsigned long frames[pages];
>> +	unsigned long frames[DIV_ROUND_UP(SZ_64K, PAGE_SIZE)];

So we could just go with one frame and modify the BUG_ON() further below
accordingly.


Juergen
