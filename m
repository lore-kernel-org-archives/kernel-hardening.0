Subject: Re: [PATCH] rtc: s5m: Remove VLA usage
References: <20180308172031.GA14541@embeddedgus>
 <CAGXu5jLjKcYOPxQOV6GO1oaLj1M_K=cFu-kHLLEzP=ZOXaAtfA@mail.gmail.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <23757731-bfa5-cb4c-ddc0-04103f9a72e0@embeddedor.com>
Date: Thu, 8 Mar 2018 12:03:29 -0600
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLjKcYOPxQOV6GO1oaLj1M_K=cFu-kHLLEzP=ZOXaAtfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, LKML <linux-kernel@vger.kernel.org>, linux-samsung-soc@vger.kernel.org, linux-rtc@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/08/2018 11:58 AM, Kees Cook wrote:
> On Thu, Mar 8, 2018 at 9:20 AM, Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>> In preparation to enabling -Wvla, remove VLAs and replace them
>> with fixed-length arrays instead.
>>
>>  From a security viewpoint, the use of Variable Length Arrays can be
>> a vector for stack overflow attacks. Also, in general, as the code
>> evolves it is easy to lose track of how big a VLA can get. Thus, we
>> can end up having segfaults that are hard to debug.
>>
>> Also, fixed as part of the directive to remove all VLAs from
>> the kernel: https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/rtc/rtc-s5m.c | 15 +++++++++------
>>   1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
>> index 6deae10..2b5f4f7 100644
>> --- a/drivers/rtc/rtc-s5m.c
>> +++ b/drivers/rtc/rtc-s5m.c
>> @@ -38,6 +38,9 @@
>>    */
>>   #define UDR_READ_RETRY_CNT     5
>>
>> +/* Maximum number of registers for setting time/alarm0/alarm1 */
>> +#define MAX_NUM_TIME_REGS      8
> 
> I would adjust the various const struct s5m_rtc_reg_config's
> .regs_count to be represented by this new define, so the stack and the
> structures stay in sync. Something like:
> 
> static const struct s5m_rtc_reg_config s2mps13_rtc_regs = {
>          .regs_count             = MAX_NUM_TIME_REGS - 1,
> 
> ?
> 

Yep. I thought about that and decided to wait for some feedback first. 
But yeah, I think is that'd be a good change.

--
Gustavo

> -Kees
> 
>> +
>>   /*
>>    * Registers used by the driver which are different between chipsets.
>>    *
>> @@ -367,7 +370,7 @@ static void s5m8763_tm_to_data(struct rtc_time *tm, u8 *data)
>>   static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
>>   {
>>          struct s5m_rtc_info *info = dev_get_drvdata(dev);
>> -       u8 data[info->regs->regs_count];
>> +       u8 data[MAX_NUM_TIME_REGS];
>>          int ret;
>>
>>          if (info->regs->read_time_udr_mask) {
>> @@ -413,7 +416,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
>>   static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
>>   {
>>          struct s5m_rtc_info *info = dev_get_drvdata(dev);
>> -       u8 data[info->regs->regs_count];
>> +       u8 data[MAX_NUM_TIME_REGS];
>>          int ret = 0;
>>
>>          switch (info->device_type) {
>> @@ -450,7 +453,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
>>   static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>>   {
>>          struct s5m_rtc_info *info = dev_get_drvdata(dev);
>> -       u8 data[info->regs->regs_count];
>> +       u8 data[MAX_NUM_TIME_REGS];
>>          unsigned int val;
>>          int ret, i;
>>
>> @@ -500,7 +503,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>>
>>   static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
>>   {
>> -       u8 data[info->regs->regs_count];
>> +       u8 data[MAX_NUM_TIME_REGS];
>>          int ret, i;
>>          struct rtc_time tm;
>>
>> @@ -545,7 +548,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
>>   static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
>>   {
>>          int ret;
>> -       u8 data[info->regs->regs_count];
>> +       u8 data[MAX_NUM_TIME_REGS];
>>          u8 alarm0_conf;
>>          struct rtc_time tm;
>>
>> @@ -598,7 +601,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
>>   static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>>   {
>>          struct s5m_rtc_info *info = dev_get_drvdata(dev);
>> -       u8 data[info->regs->regs_count];
>> +       u8 data[MAX_NUM_TIME_REGS];
>>          int ret;
>>
>>          switch (info->device_type) {
>> --
>> 2.7.4
>>
> 
> 
> 
