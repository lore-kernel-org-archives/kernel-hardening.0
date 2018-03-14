Subject: Re: [PATCH 4/4] gpio: Remove VLA from stmpe driver
References: <20180310001021.6437-1-labbott@redhat.com>
 <20180310001021.6437-5-labbott@redhat.com>
 <9175611d-049d-ec28-0716-e45fccfd579f@electromag.com.au>
 <4e64bbae-e91b-f0c5-ff79-3dde8fbe2119@redhat.com>
 <d37dbce5-43ca-b70a-41da-5ccfc673d3ac@redhat.com>
From: Phil Reid <preid@electromag.com.au>
Message-ID: <9ffedffb-5dd1-a67a-7266-eb480b07a384@electromag.com.au>
Date: Wed, 14 Mar 2018 10:55:29 +0800
MIME-Version: 1.0
In-Reply-To: <d37dbce5-43ca-b70a-41da-5ccfc673d3ac@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Patrice Chotard <patrice.chotard@st.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 14/03/2018 09:16, Laura Abbott wrote:
> On 03/13/2018 05:18 PM, Laura Abbott wrote:
>> On 03/13/2018 02:13 AM, Phil Reid wrote:
>>> On 10/03/2018 08:10, Laura Abbott wrote:
>>>> The new challenge is to remove VLAs from the kernel
>>>> (see https://lkml.org/lkml/2018/3/7/621)
>>>>
>>>> This patch replaces a VLA with an appropriate call to kmalloc_array.
>>>>
>>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>>> ---
>>>>   drivers/gpio/gpio-stmpe.c | 7 ++++++-
>>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
>>>> index f8d7d1cd8488..b7854850bcdb 100644
>>>> --- a/drivers/gpio/gpio-stmpe.c
>>>> +++ b/drivers/gpio/gpio-stmpe.c
>>>> @@ -369,10 +369,14 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
>>>>       struct stmpe *stmpe = stmpe_gpio->stmpe;
>>>>       u8 statmsbreg;
>>>>       int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
>>>> -    u8 status[num_banks];
>>>> +    u8 *status;
>>>>       int ret;
>>>>       int i;
>>>> +    status = kmalloc_array(num_banks, sizeof(*status), GFP_ATOMIC);
>>>> +    if (!status)
>>>> +        return IRQ_NONE;
>>>> +
>>>>       /*
>>>>        * the stmpe_block_read() call below, imposes to set statmsbreg
>>>>        * with the register located at the lowest address. As STMPE1600
>>>> @@ -424,6 +428,7 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
>>>>           }
>>>>       }
>>>> +    kfree(status);
>>>>       return IRQ_HANDLED;
>>>>   }
>>>>
>>>
>>> Doing this in an irq handler seems wrong.
>>> Perhaps better if a buffer is pre-allocated in stmpe_gpio
>>
>> Sure, I can pre-allocate the buffer in the probe.
> 
> Actually I wonder if there would be concurrency problems if we
> tried to pre-allocate a global buffer. But the IRQ handler
> calls stmpe_block_read which takes a mutex to sleep so I think
> doing the (small) kmalloc should be fine and I can change it to
> a GFP_KERNEL.
> 
I'm no expert on this driver, but I wouldn't think there'd be any concurrency
problem if the buffer is only used by the irq handler.
It should never get called concurrently for the same device.

As to the impact, I'll admit I've really got no idea how much potential overhead a
kmalloc has compared to a mutex for the linux kernel.
Just a general rule of thumb, that memory allocations are usually expensive.
-- 
Regards
Phil Reid
