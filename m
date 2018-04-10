Subject: Re: [PATCH] drm/amdkfd: Remove vla
References: <20180409210620.3647-1-labbott@redhat.com>
 <71ff5078-713c-ff8b-8c8d-6d24a7d84c02@amd.com>
From: Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <ad009206-2202-ad01-c7ee-6ce296df56ba@amd.com>
Date: Tue, 10 Apr 2018 14:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <71ff5078-713c-ff8b-8c8d-6d24a7d84c02@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Laura Abbott <labbott@redhat.com>, Oded Gabbay <oded.gabbay@gmail.com>, Alex Deucher <alexander.deucher@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
List-ID: <kernel-hardening.lists.openwall.com>

Thanks Christian for catching that. I'm working on a patch series to
upstream Vega10 support, about 95% done. It will add this ASIC info for
Vega10:

static const struct kfd_device_info vega10_device_info = {
	.asic_family = CHIP_VEGA10,
	.max_pasid_bits = 16,
	.max_no_of_hqd  = 24,
	.doorbell_size  = 8,
	.ih_ring_entry_size = 8 * sizeof(uint32_t), /* !!! IH ring entry size is bigger on Vega10 !!! */
	.event_interrupt_class = &event_interrupt_class_v9,
	.num_of_watch_points = 4,
	.mqd_size_aligned = MQD_SIZE_ALIGNED,
	.supports_cwsr = true,
	.needs_iommu_device = false,
	.needs_pci_atomics = false,
};

If you change it to uint32_t ih_ring_entry[8] and update the check, it
should be reasonably future proof.

Regards,
  Felix


On 2018-04-10 02:38 AM, Christian König wrote:
> Am 09.04.2018 um 23:06 schrieb Laura Abbott:
>> There's an ongoing effort to remove VLAs[1] from the kernel to
>> eventually
>> turn on -Wvla. The single VLA usage in the amdkfd driver is actually
>> constant across all current platforms.
>
> Actually that isn't correct.
>
> Could be that we haven't upstreamed KFD support for them, but Vega10
> have a different interrupt ring entry size and so would cause the
> error message here.
>
>> Switch to a constant size array
>> instead.
>
> I would say to just make make the array bigger.
>
> Regards,
> Christian.
>
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>   drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> index 035c351f47c5..c9863858f343 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> @@ -139,10 +139,12 @@ static void interrupt_wq(struct work_struct *work)
>>   {
>>       struct kfd_dev *dev = container_of(work, struct kfd_dev,
>>                           interrupt_work);
>> +    uint32_t ih_ring_entry[4];
>>   -    uint32_t ih_ring_entry[DIV_ROUND_UP(
>> -                dev->device_info->ih_ring_entry_size,
>> -                sizeof(uint32_t))];
>> +    if (dev->device_info->ih_ring_entry_size > (4 *
>> sizeof(uint32_t))) {
>> +        dev_err(kfd_chardev(), "Ring entry too small\n");
>> +        return;
>> +    }
>>         while (dequeue_ih_ring_entry(dev, ih_ring_entry))
>>           dev->device_info->event_interrupt_class->interrupt_wq(dev,
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
