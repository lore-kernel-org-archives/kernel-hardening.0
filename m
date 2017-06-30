MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5j+TbpcmNFUxdYFKB=JZKDgkkEVZxyqUSOfQpwfMt9a+hg@mail.gmail.com>
References: <20170630160450.4093529-1-arnd@arndb.de> <CAGXu5j+TbpcmNFUxdYFKB=JZKDgkkEVZxyqUSOfQpwfMt9a+hg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 30 Jun 2017 14:54:18 -0700
Message-ID: <CAGXu5jJwruzcWt0bvO=fm+9XX3OuZBp1W_O+V314R6xrwLAFLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2] ARM: fix randomized task_struct
To: Arnd Bergmann <arnd@arndb.de>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 30, 2017 at 11:27 AM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jun 30, 2017 at 9:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> With the new task struct randomization, we can run into a build
>> failure for certain random seeds:
>>
>> arch/arm/kernel/entry-armv.S: Assembler messages:
>> arch/arm/kernel/entry-armv.S:803: Error: bad immediate value for offset (4096)
>>
>> Only two constants in asm-offset.h are affected, and I'm changing
>> both of them here to work correctly in all configurations.
>>
>> One more macro has the problem, but is currently unused, so this
>> removes it instead of adding complexity.
>>
>> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Fixes: c33d8b12fbbd ("task_struct: Allow randomized layout")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Looks great, thanks!
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> Russell, if you're happy with it can you Ack this? I'd like to carry
> the change in the randstruct tree (so all the dependencies are in the
> same tree).

I've also forced stack_canary into the end of task_struct and inflated
the size of the struct (to match randomization inflation due to
intentionally poor bitfield packing), verified the resulting .o files
have the adjustment and boot tested both cases.

Tested-by: Kees Cook <keescook@chromium.org>

-Kees


-- 
Kees Cook
Pixel Security
