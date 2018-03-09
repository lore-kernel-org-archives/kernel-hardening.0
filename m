MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <877eqli0f0.fsf@anholt.net>
References: <1520576470-20628-1-git-send-email-me@tobin.cc> <877eqli0f0.fsf@anholt.net>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 9 Mar 2018 10:35:55 -0800
Message-ID: <CAGXu5j+k6SkGP19EYxOAvwy+uzvkJ664_Lj_Rz5t8a6Fi60+JQ@mail.gmail.com>
Subject: Re: [PATCH] staging: vchiq_arm: Clear VLA warning
Content-Type: text/plain; charset="UTF-8"
To: Eric Anholt <eric@anholt.net>
Cc: "Tobin C. Harding" <me@tobin.cc>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stefan Wahren <stefan.wahren@i2se.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, driverdev-devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 10:11 AM, Eric Anholt <eric@anholt.net> wrote:
> "Tobin C. Harding" <me@tobin.cc> writes:
>
>> The kernel would like to have all stack VLA usage removed[1].  The
>> array here is fixed (declared with a const variable) but it appears
>> like VLA to the compiler.  We can use a pre-processor define to quiet
>> the compiler.
>>
>> [1]: https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Tobin C. Harding <me@tobin.cc>
>> ---
>>
>> The name of this constant may need changing, there is already a
>> pre-processor constant VCHIQ_MAX_SERVICES
>
> Maybe just use ARRAY_SIZE(local_max_services) and not have the #define?

I think you mean ARRAY_SIZE(service_data) ? In that case, yeah, it
seems like a raw "64" for the array size can be used instead.

-Kees

-- 
Kees Cook
Pixel Security
