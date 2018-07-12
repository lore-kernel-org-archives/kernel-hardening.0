MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <08f1c1d4-52a8-6d42-fe56-241c255ba934@redhat.com>
References: <20180712000337.GA4022@beast> <08f1c1d4-52a8-6d42-fe56-241c255ba934@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 11 Jul 2018 19:06:25 -0700
Message-ID: <CAGXu5jJtuut1E4DKB=AVs-pq8H9Jvwr3Ve6eskraBL3ekfUzqA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Add support for STACKLEAK gcc plugin
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Alexander Popov <alex.popov@linux.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 11, 2018 at 6:45 PM, Laura Abbott <labbott@redhat.com> wrote:
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +#define MIN_STACK_LEFT 256
>> +
>> +void __used stackleak_check_alloca(unsigned long size)
>> +{
>> +       unsigned long sp, stack_left;
>> +
>> +       sp = current_stack_pointer;
>> +
>> +       stack_left = sp & (THREAD_SIZE - 1);
>> +       BUG_ON(stack_left < MIN_STACK_LEFT ||
>> +               size >= stack_left - MIN_STACK_LEFT);
>> +}
>> +EXPORT_SYMBOL(stackleak_check_alloca);
>> +#endif
>
>
> I think the conclusion was this needs to be re-written to account
> for the different stack sizes in the same way as x86.

Oh, whoops! Sorry, I missed that fork of the thread. :)

-Kees

-- 
Kees Cook
Pixel Security
