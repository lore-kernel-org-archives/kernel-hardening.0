MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170407015819.djxqzd2e5i3dd2dt@jeyu>
References: <20170406033550.32525-1-ewk@edkovsky.org> <20170406033550.32525-2-ewk@edkovsky.org>
 <20170407015819.djxqzd2e5i3dd2dt@jeyu>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 7 Apr 2017 13:46:07 -0700
Message-ID: <CAGXu5j+QsQYkheYU6PxPmyp53nCuwfiuwPE7Q=DsYca9pydRyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 1/2] module: verify address is read-only
To: Jessica Yu <jeyu@redhat.com>
Cc: Eddie Kovsky <ewk@edkovsky.org>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 6, 2017 at 6:58 PM, Jessica Yu <jeyu@redhat.com> wrote:
> +++ Eddie Kovsky [05/04/17 21:35 -0600]:
>>
>> Implement a mechanism to check if a module's address is in
>> the rodata or ro_after_init sections. It mimics the existing functions
>> that test if an address is inside a module's text section.
>>
>> Functions that take a module as an argument will be able to verify that
>> the
>> module address is in a read-only section. The idea is to prevent
>> structures
>> (including modules) that are not read-only from being passed to functions.
>>
>> This implements the first half of a suggestion made by Kees Cook for
>> the Kernel Self Protection Project:
>>
>>    - provide mechanism to check for ro_after_init memory areas, and
>>      reject structures not marked ro_after_init in vmbus_register()
>>
>> Suggested-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
>
>
> Acked-by: Jessica Yu <jeyu@redhat.com>

Thanks! I'll either get these into my kspp tree or ask akpm to carry
these since they depend on the renaming in his tree already.

-Kees

-- 
Kees Cook
Pixel Security
