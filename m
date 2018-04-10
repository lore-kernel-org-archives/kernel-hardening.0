Subject: Re: [PATCH] misc: tifm: Remove VLA
References: <20180409210732.3919-1-labbott@redhat.com>
 <CAK8P3a3Yo0riMroM3x4EVz8FkMakdPkkJ-mCTYW0qOji+MCCiQ@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <799e8f9a-0aa1-6f5d-8421-7c768d70f562@redhat.com>
Date: Tue, 10 Apr 2018 11:49:02 -0700
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3Yo0riMroM3x4EVz8FkMakdPkkJ-mCTYW0qOji+MCCiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Dubov <oakad@yahoo.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/10/2018 12:57 AM, Arnd Bergmann wrote:
> On Mon, Apr 9, 2018 at 11:07 PM, Laura Abbott <labbott@redhat.com> wrote:
>> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
>> turn on -Wvla. The single VLA can either take a value of 2 or 4 so switch
>> to the upper bound.
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>   drivers/misc/tifm_7xx1.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
>> index e5f108713dd8..690eaaea5ce4 100644
>> --- a/drivers/misc/tifm_7xx1.c
>> +++ b/drivers/misc/tifm_7xx1.c
>> @@ -239,7 +239,8 @@ static int tifm_7xx1_resume(struct pci_dev *dev)
>>          unsigned long timeout;
>>          unsigned int good_sockets = 0, bad_sockets = 0;
>>          unsigned long flags;
>> -       unsigned char new_ids[fm->num_sockets];
>> +       /* Maximum number of entries is 4 */
>> +       unsigned char new_ids[4];
>>          DECLARE_COMPLETION_ONSTACK(finish_resume);
>>
> 
> I like the idea of removing all the VLAs, but this one appears to make
> the code less robust rather than more: In case of an unexpected
> fm->num_sockets value, we now not only overflow the kernel stack
> area but also the local variable into the neighboring stack slots.
> 
> Maybe add an extra overflow check?
> 

Sure.

>         Arnd
> 
> diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
> index e5f108713dd8..c702cd92d396 100644
> --- a/drivers/misc/tifm_7xx1.c
> +++ b/drivers/misc/tifm_7xx1.c
> @@ -239,9 +239,12 @@ static int tifm_7xx1_resume(struct pci_dev *dev)
>          unsigned long timeout;
>          unsigned int good_sockets = 0, bad_sockets = 0;
>          unsigned long flags;
> -       unsigned char new_ids[fm->num_sockets];
> +      /* Maximum number of entries is 4 */
> +       unsigned char new_ids[4];
>          DECLARE_COMPLETION_ONSTACK(finish_resume);
> 
> +       if (WARN_ON(fm->num_sockets > ARRAY_SIZE(new_ids)))
> +               return -ENXIO;
> +
>          pci_set_power_state(dev, PCI_D0);
>          pci_restore_state(dev);
>          rc = pci_enable_device(dev);
> 
