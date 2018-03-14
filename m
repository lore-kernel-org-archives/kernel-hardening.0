Subject: Re: [PATCH 4/4] gpio: Remove VLA from stmpe driver
References: <20180310001021.6437-1-labbott@redhat.com>
 <20180310001021.6437-5-labbott@redhat.com>
 <9175611d-049d-ec28-0716-e45fccfd579f@electromag.com.au>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <4e64bbae-e91b-f0c5-ff79-3dde8fbe2119@redhat.com>
Date: Tue, 13 Mar 2018 17:18:22 -0700
MIME-Version: 1.0
In-Reply-To: <9175611d-049d-ec28-0716-e45fccfd579f@electromag.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Phil Reid <preid@electromag.com.au>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Patrice Chotard <patrice.chotard@st.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 03/13/2018 02:13 AM, Phil Reid wrote:
> On 10/03/2018 08:10, Laura Abbott wrote:
>> The new challenge is to remove VLAs from the kernel
>> (see https://lkml.org/lkml/2018/3/7/621)
>>
>> This patch replaces a VLA with an appropriate call to kmalloc_array.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>   drivers/gpio/gpio-stmpe.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
>> index f8d7d1cd8488..b7854850bcdb 100644
>> --- a/drivers/gpio/gpio-stmpe.c
>> +++ b/drivers/gpio/gpio-stmpe.c
>> @@ -369,10 +369,14 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
>>       struct stmpe *stmpe = stmpe_gpio->stmpe;
>>       u8 statmsbreg;
>>       int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
>> -    u8 status[num_banks];
>> +    u8 *status;
>>       int ret;
>>       int i;
>> +    status = kmalloc_array(num_banks, sizeof(*status), GFP_ATOMIC);
>> +    if (!status)
>> +        return IRQ_NONE;
>> +
>>       /*
>>        * the stmpe_block_read() call below, imposes to set statmsbreg
>>        * with the register located at the lowest address. As STMPE1600
>> @@ -424,6 +428,7 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
>>           }
>>       }
>> +    kfree(status);
>>       return IRQ_HANDLED;
>>   }
>>
> 
> Doing this in an irq handler seems wrong.
> Perhaps better if a buffer is pre-allocated in stmpe_gpio
> 
> 

Sure, I can pre-allocate the buffer in the probe.

Thanks,
Laura
