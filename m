Subject: Re: [PATCHv2 4/4] gpio: Remove VLA from stmpe driver
References: <20180315180030.20001-1-labbott@redhat.com>
 <20180315180030.20001-5-labbott@redhat.com>
 <21a2e869-62fb-75ef-ae7b-a27e136696f7@electromag.com.au>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <90e40062-cedb-be32-ab17-56136c78dbad@redhat.com>
Date: Thu, 22 Mar 2018 14:43:39 -0700
MIME-Version: 1.0
In-Reply-To: <21a2e869-62fb-75ef-ae7b-a27e136696f7@electromag.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Phil Reid <preid@electromag.com.au>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Patrice Chotard <patrice.chotard@st.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 03/18/2018 06:29 PM, Phil Reid wrote:
> On 16/03/2018 02:00, Laura Abbott wrote:
>> The new challenge is to remove VLAs from the kernel
>> (see https://lkml.org/lkml/2018/3/7/621)
>>
>> This patch replaces a VLA with an appropriate call to kmalloc_array.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>> v2: Switch to GFP_KERNEL. There was some discussion about if we should
>> be doing the allocation at all but given a) the allocation is pretty
>> small and b) we can possibly take a mutex in a called function I think
>> this is fine.
> 
> I still think it's a bad idea. It's simple to preallocate the buffer.
> But it's up to the maintainer.
> 

I'd feel a lot more confident about doing the global buffer with
guidance from the maintainer. But looking at the platform data, the
maximum number of GPIOs is 24, or 3 banks. Maybe we should just always
stack allocate the maximum since it's fairly small.

Thanks,
Laura

> 
>> ---
>>   drivers/gpio/gpio-stmpe.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
>> index f8d7d1cd8488..c2bb20ace6f5 100644
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
>> +    status = kmalloc_array(num_banks, sizeof(*status), GFP_KERNEL);
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
> 
