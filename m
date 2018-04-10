Subject: Re: [PATCH] drm/amdkfd: Remove vla
References: <20180409210620.3647-1-labbott@redhat.com>
 <71ff5078-713c-ff8b-8c8d-6d24a7d84c02@amd.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <7aba566e-ed84-91ae-78f1-01659ef7907d@redhat.com>
Date: Tue, 10 Apr 2018 11:43:57 -0700
MIME-Version: 1.0
In-Reply-To: <71ff5078-713c-ff8b-8c8d-6d24a7d84c02@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Oded Gabbay <oded.gabbay@gmail.com>, Alex Deucher <alexander.deucher@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/09/2018 11:38 PM, Christian König wrote:
> Am 09.04.2018 um 23:06 schrieb Laura Abbott:
>> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
>> turn on -Wvla. The single VLA usage in the amdkfd driver is actually
>> constant across all current platforms.
> 
> Actually that isn't correct.
> 
> Could be that we haven't upstreamed KFD support for them, but Vega10 have a different interrupt ring entry size and so would cause the error message here.
> 
>> Switch to a constant size array
>> instead.
> 
> I would say to just make make the array bigger.
> 
> Regards,
> Christian.
> 

What array size would accommodate future chips?

>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>   drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> index 035c351f47c5..c9863858f343 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> @@ -139,10 +139,12 @@ static void interrupt_wq(struct work_struct *work)
>>   {
>>       struct kfd_dev *dev = container_of(work, struct kfd_dev,
>>                           interrupt_work);
>> +    uint32_t ih_ring_entry[4];
>> -    uint32_t ih_ring_entry[DIV_ROUND_UP(
>> -                dev->device_info->ih_ring_entry_size,
>> -                sizeof(uint32_t))];
>> +    if (dev->device_info->ih_ring_entry_size > (4 * sizeof(uint32_t))) {
>> +        dev_err(kfd_chardev(), "Ring entry too small\n");
>> +        return;
>> +    }
>>       while (dequeue_ih_ring_entry(dev, ih_ring_entry))
>>           dev->device_info->event_interrupt_class->interrupt_wq(dev,
> 
