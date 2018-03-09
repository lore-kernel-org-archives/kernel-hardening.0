Subject: Re: [PATCH] power: supply: da9150-fg: remove VLA usage
References: <20180309045813.GA11964@embeddedgus>
 <2E89032DDAA8B9408CB92943514A0337014C1D771E@SW-EX-MBX01.diasemi.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <b657eeff-ba9d-c40c-24f3-b971c893b6c3@embeddedor.com>
Date: Fri, 9 Mar 2018 11:55:40 -0600
MIME-Version: 1.0
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337014C1D771E@SW-EX-MBX01.diasemi.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Support Opensource <Support.Opensource@diasemi.com>, Sebastian Reichel <sre@kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/09/2018 05:36 AM, Adam Thomson wrote:
> On 09 March 2018 04:58, Gustavo A. R. Silva wrote:
> 
>> In preparation to enabling -Wvla, remove VLA usage and replace it
>> with fixed-length arrays.
>>
>> It seems that the length of array 'buf' will not exceed
>> DA9150_QIF_SHORT_SIZE bytes (2 bytes). But a fixed length
>> of DA9150_QIF_BYTE_SIZE bytes (8 bytes) was chosen in case
>> this change in the future.
>>
>> Fixed as part of the directive to remove all VLAs from
>> the kernel: https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/power/supply/da9150-fg.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/power/supply/da9150-fg.c b/drivers/power/supply/da9150-fg.c
>> index 8b8ce97..96893be 100644
>> --- a/drivers/power/supply/da9150-fg.c
>> +++ b/drivers/power/supply/da9150-fg.c
>> @@ -92,7 +92,7 @@ struct da9150_fg {
>>   static u32 da9150_fg_read_attr(struct da9150_fg *fg, u8 code, u8 size)
>>
>>   {
>> -	u8 buf[size];
>> +	u8 buf[DA9150_QIF_BYTE_SIZE];
> 
> You can use DA9150_QIF_LONG_SIZE as that's the biggest size of an attribute
> which can be accessed. This will also save a little space.
> 

I got it. I'll send v2 shortly.

Thanks for the feedback, Adam.
--
Gustavo
