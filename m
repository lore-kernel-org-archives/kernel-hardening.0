MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170325004235.rzpwhvh6h2eapllj@jeyu>
References: <20170323025549.19588-1-ewk@edkovsky.org> <20170323025549.19588-2-ewk@edkovsky.org>
 <CAGXu5j+iwUYhU13D0pWA_LHdBX9z48fO4aK-9sSdJ=TZaMSsrQ@mail.gmail.com> <20170325004235.rzpwhvh6h2eapllj@jeyu>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 24 Mar 2017 18:59:40 -0700
Message-ID: <CAGXu5j+xzVPq6dN6MFkmqX7r1xMH0xtt3D+PmQHryeP1KCgXAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 1/2] module: verify address is read-only
To: Jessica Yu <jeyu@redhat.com>
Cc: Eddie Kovsky <ewk@edkovsky.org>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 24, 2017 at 5:42 PM, Jessica Yu <jeyu@redhat.com> wrote:
> +++ Kees Cook [23/03/17 14:13 -0700]:
>>
>> On Wed, Mar 22, 2017 at 7:55 PM, Eddie Kovsky <ewk@edkovsky.org> wrote:
>>>
>>> Implement a mechanism to check if a module's address is in
>>> the rodata or ro_after_init sections. It mimics the exsiting functions
>>> that test if an address is inside a module's text section.
>>>
>>> Functions that take a module as an argument will be able to
>>> verify that the module is in a read-only section.
>>>
>>> Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
>>
>>
>> Awesome! I'll be glad to have these.
>>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>
>> Jessica, if this looks good to you, should this go via modules or via
>> my tree? If mine, can I have your Ack?
>
>
> Sure, would be happy to let you take this patch through your tree. I
> only had a few minor comments left, so I think just one more small
> respin and it'll be good to go.

Awesome, I'll wait for v4 and your Ack and put it through the kspp tree. :)

Thanks for the review!

-Kees

-- 
Kees Cook
Pixel Security
