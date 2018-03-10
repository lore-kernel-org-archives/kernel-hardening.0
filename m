Subject: Re: [PATCH] rtc: s5m: Remove VLA usage
References: <20180308172031.GA14541@embeddedgus>
 <CAGXu5jLjKcYOPxQOV6GO1oaLj1M_K=cFu-kHLLEzP=ZOXaAtfA@mail.gmail.com>
 <23757731-bfa5-cb4c-ddc0-04103f9a72e0@embeddedor.com>
 <CAJKOXPf+4tF4oq5ePsgcpUAQS_M2Vi6b1+J-8D9CVemO-6ve5g@mail.gmail.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <4f25592d-e805-b81e-b518-4b60867ef32a@embeddedor.com>
Date: Fri, 9 Mar 2018 22:34:55 -0600
MIME-Version: 1.0
In-Reply-To: <CAJKOXPf+4tF4oq5ePsgcpUAQS_M2Vi6b1+J-8D9CVemO-6ve5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Sangbeom Kim <sbkim73@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, LKML <linux-kernel@vger.kernel.org>, linux-samsung-soc@vger.kernel.org, linux-rtc@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


Hi Krzysztof,

On 03/09/2018 07:04 AM, Krzysztof Kozlowski wrote:
> On Thu, Mar 8, 2018 at 7:03 PM, Gustavo A. R. Silva
> <garsilva@embeddedor.com> wrote:
>>
>>
>> On 03/08/2018 11:58 AM, Kees Cook wrote:
>>>
>>> On Thu, Mar 8, 2018 at 9:20 AM, Gustavo A. R. Silva
>>> <gustavo@embeddedor.com> wrote:
>>>>
>>>> In preparation to enabling -Wvla, remove VLAs and replace them
>>>> with fixed-length arrays instead.
>>>>
>>>>   From a security viewpoint, the use of Variable Length Arrays can be
>>>> a vector for stack overflow attacks. Also, in general, as the code
>>>> evolves it is easy to lose track of how big a VLA can get. Thus, we
>>>> can end up having segfaults that are hard to debug.
>>>>
>>>> Also, fixed as part of the directive to remove all VLAs from
>>>> the kernel: https://lkml.org/lkml/2018/3/7/621
>>>>
>>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>>> ---
>>>>    drivers/rtc/rtc-s5m.c | 15 +++++++++------
>>>>    1 file changed, 9 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
>>>> index 6deae10..2b5f4f7 100644
>>>> --- a/drivers/rtc/rtc-s5m.c
>>>> +++ b/drivers/rtc/rtc-s5m.c
>>>> @@ -38,6 +38,9 @@
>>>>     */
>>>>    #define UDR_READ_RETRY_CNT     5
>>>>
>>>> +/* Maximum number of registers for setting time/alarm0/alarm1 */
>>>> +#define MAX_NUM_TIME_REGS      8
>>>
>>>
>>> I would adjust the various const struct s5m_rtc_reg_config's
>>> .regs_count to be represented by this new define, so the stack and the
>>> structures stay in sync. Something like:
>>>
>>> static const struct s5m_rtc_reg_config s2mps13_rtc_regs = {
>>>           .regs_count             = MAX_NUM_TIME_REGS - 1,
>>>
>>> ?
>>>
>>
>> Yep. I thought about that and decided to wait for some feedback first. But
>> yeah, I think is that'd be a good change.
> 
> Define and these assignments should be somehow connected with enum
> defining the offsets for data[] (from
> include/linux/mfd/samsung/rtc.h). Otherwise we define the same in two
> places. The enum could be itself (in separate patch) moved to the
> driver because it is meaningless for others.
>

I got it.

I'll move the enum to rtc-s5m.c and add RTC_MAX_NUM_TIME_REGS at the end 
of it. I'll send a patch series for this.

Thanks for the feedback.
--
Gustavo

> Best regards,
> Krzysztof
> 
