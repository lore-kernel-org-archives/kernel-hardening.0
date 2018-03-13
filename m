Subject: Re: [PATCH 0/2] Remove VLA usage in rtc-s5m
References: <cover.1520660422.git.gustavo@embeddedor.com>
 <20180313003540.GF3795@piout.net>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <4323fb5d-0b26-441f-3d7b-3008108f20e0@embeddedor.com>
Date: Mon, 12 Mar 2018 20:17:39 -0500
MIME-Version: 1.0
In-Reply-To: <20180313003540.GF3795@piout.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alessandro Zummo <a.zummo@towertech.it>, Lee Jones <lee.jones@linaro.org>, linux-samsung-soc@vger.kernel.org, linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/12/2018 07:35 PM, Alexandre Belloni wrote:
> Hi,
> 
> On 10/03/2018 at 00:27:02 -0600, Gustavo A. R. Silva wrote:
>> This patchset aims to remove VLA usage from rtc-s5m.
>>
>> The first patch moves an enum from rtc.h to rtc-s5m.c, as this is the
>> only driver in which such enum is actually being used [1].
>>
>> The second patch adds the enum name RTC_MAX_NUM_TIME_REGS, which will
>> be used as a maximum length to the current VLAs, hence turning them
>> into fixed-length arrays instead.
>>
>> [1] https://marc.info/?l=linux-rtc&m=152060068925948&w=2
>>
>> Thanks
>>
>> Gustavo A. R. Silva (2):
>>    rtc: s5m: move enum from rtc.h to rtc-s5m.c
>>    rtc: s5m: Remove VLA usage
>>
> 
> Both applied, thanks.
> 

Awesome.

Thank you.
--
Gustavo
