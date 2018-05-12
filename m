MIME-Version: 1.0
In-Reply-To: <CAGXu5jJW2h4PqMkRFEc1G1yqxXm+oZyDfE13pkVxJJjDw6XS3A@mail.gmail.com>
References: <20180413212412.18205-1-labbott@redhat.com> <CAGXu5jJW2h4PqMkRFEc1G1yqxXm+oZyDfE13pkVxJJjDw6XS3A@mail.gmail.com>
From: Oded Gabbay <oded.gabbay@gmail.com>
Date: Sat, 12 May 2018 14:11:53 +0300
Message-ID: <CAFCwf12_WPFpX6Vr-aLcNgtW6ySi_OfW-hajgX_iNfnWn633+A@mail.gmail.com>
Subject: Re: [PATCHv3] drm/amdkfd: Remove vla
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Felix Kuehling <felix.kuehling@amd.com>, David Airlie <airlied@linux.ie>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 3, 2018 at 12:49 AM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Apr 13, 2018 at 2:24 PM, Laura Abbott <labbott@redhat.com> wrote:
>>
>> There's an ongoing effort to remove VLAs[1] from the kernel to eventuall=
y
>> turn on -Wvla. Switch to a constant value that covers all hardware.
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
>> Acked-by: Christian K=C3=B6nig <christian.koenig@amd.com>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>
> Friendly ping -- I don't see this in -next yet. Oded, does this look
> okay to apply?
>
> Thanks!
>
> -Kees

Thanks!
Applied to amdkfd-next

Oded

>
>> ---
>> v3: Introduced a #define for the max value, switched to pr_err_once to
>> avoid log flood, switched to sizeof(array) per private suggestion.
>> ---
>>  drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c | 8 +++++---
>>  drivers/gpu/drm/amd/amdkfd/kfd_priv.h      | 2 ++
>>  2 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c b/drivers/gpu/dr=
m/amd/amdkfd/kfd_interrupt.c
>> index 035c351f47c5..db6d9336b80d 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
>> @@ -139,10 +139,12 @@ static void interrupt_wq(struct work_struct *work)
>>  {
>>         struct kfd_dev *dev =3D container_of(work, struct kfd_dev,
>>                                                 interrupt_work);
>> +       uint32_t ih_ring_entry[KFD_MAX_RING_ENTRY_SIZE];
>>
>> -       uint32_t ih_ring_entry[DIV_ROUND_UP(
>> -                               dev->device_info->ih_ring_entry_size,
>> -                               sizeof(uint32_t))];
>> +       if (dev->device_info->ih_ring_entry_size > sizeof(ih_ring_entry)=
) {
>> +               dev_err_once(kfd_chardev(), "Ring entry too small\n");
>> +               return;
>> +       }
>>
>>         while (dequeue_ih_ring_entry(dev, ih_ring_entry))
>>                 dev->device_info->event_interrupt_class->interrupt_wq(de=
v,
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd=
/amdkfd/kfd_priv.h
>> index 96a9cc0f02c9..a90db05dfe61 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
>> @@ -39,6 +39,8 @@
>>
>>  #include "amd_shared.h"
>>
>> +#define KFD_MAX_RING_ENTRY_SIZE        8
>> +
>>  #define KFD_SYSFS_FILE_MODE 0444
>>
>>  #define KFD_MMAP_DOORBELL_MASK 0x8000000000000ull
>> --
>> 2.14.3
>>
>
>
>
> --
> Kees Cook
> Pixel Security
