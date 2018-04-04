MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAPDyKFobX6U4_st0nE7-yHt1SPFu4diLhzTaswY6Xt3BrruvAA@mail.gmail.com>
References: <1522045994-21913-1-git-send-email-me@tobin.cc> <CAPDyKFobX6U4_st0nE7-yHt1SPFu4diLhzTaswY6Xt3BrruvAA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 4 Apr 2018 09:23:05 -0700
Message-ID: <CAGXu5jJgt+sUtTPpqiFVx19mNXs-asjTUQJABrLBf_g8q=FQAA@mail.gmail.com>
Subject: Re: [PATCH] mmc: pwrseq: Use kmalloc_array instead of stack VLA
Content-Type: text/plain; charset="UTF-8"
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 4, 2018 at 5:45 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 26 March 2018 at 08:33, Tobin C. Harding <me@tobin.cc> wrote:
>> The use of stack Variable Length Arrays needs to be avoided, as they
>> can be a vector for stack exhaustion, which can be both a runtime bug
>> (kernel Oops) or a security flaw (overwriting memory beyond the
>> stack). Also, in general, as code evolves it is easy to lose track of
>> how big a VLA can get. Thus, we can end up having runtime failures
>> that are hard to debug. As part of the directive[1] to remove all VLAs
>> from the kernel, and build with -Wvla.
>>
>> Currently driver is using a VLA declared using the number of descriptors.  This
>> array is used to store integer values and is later used as an argument to
>> `gpiod_set_array_value_cansleep()` This can be avoided by using
>> `kmalloc_array()` to allocate memory for the array of integer values.  Memory is
>> free'd before return from function.
>>
>> From the code it appears that it is safe to sleep so we can use GFP_KERNEL
>> (based _cansleep() suffix of function `gpiod_set_array_value_cansleep()`.
>>
>> It can be expected that this patch will result in a small increase in overhead
>> due to the use of `kmalloc_array()`
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Tobin C. Harding <me@tobin.cc>
>
> Thanks, queued for 3.18!

Time travel! ;)

-Kees

-- 
Kees Cook
Pixel Security
