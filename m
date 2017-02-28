MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1488270174.1747.11.camel@gmail.com>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-2-git-send-email-keescook@chromium.org> <1488270174.1747.11.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Feb 2017 07:05:32 -0800
Message-ID: <CAGXu5jKvY1VRxBk_F9omixEBhaSTE18tfRWNcPUKhFk303v6iw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 1/8] Introduce rare_write() infrastructure
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 28, 2017 at 12:22 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> On Mon, 2017-02-27 at 12:42 -0800, Kees Cook wrote:
>> Several types of data storage exist in the kernel: read-write data
>> (.data,
>> .bss), read-only data (.rodata), and RO-after-init. This introduces
>> the
>> infrastructure for another type: write-rarely, which intended for
>> data
>> that is either only rarely modified or especially security-sensitive.
>> The
>> intent is to further reduce the internal attack surface of the kernel
>> by
>> making this storage read-only when "at rest". This makes it much
>> harder
>> to be subverted by attackers who have a kernel-write flaw, since they
>> cannot directly change the memory contents.
>>
>> Variables declared __wr_rare will be made const when an architecture
>> supports HAVE_ARCH_WRITE_RARE. To change these variables, either the
>> rare_write() macro can be used, or multiple uses of __rare_write(),
>> wrapped in rare_write_enable()/rare_write_disable() macros. These
>> macros
>> are handled by the arch-specific functions that perform the actions
>> needed
>> to write to otherwise read-only memory.
>>
>> The arch-specific helpers must be not allow non-current CPUs to write
>> the memory area, run non-preemptible to avoid accidentally leaving
>> memory writable, and defined as inline to avoid making them desirable
>> ROP targets for attackers.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/Kconfig             | 15 +++++++++++++++
>>  include/linux/compiler.h | 38 ++++++++++++++++++++++++++++++++++++++
>>  include/linux/preempt.h  |  6 ++++--
>>  3 files changed, 57 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 99839c23d453..2446de19f66d 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -781,4 +781,19 @@ config VMAP_STACK
>>         the stack to map directly to the KASAN shadow map using a
>> formula
>>         that is incorrect if the stack is in vmalloc space.
>>
>> +config HAVE_ARCH_RARE_WRITE
>> +     def_bool n
>> +     help
>> +       An arch should select this option if it has defined the
>> functions
>> +       __arch_rare_write_map() and __arch_rare_write_unmap() to
>> +       respectively enable and disable writing to read-only
>> memory.The
>> +       routines must meet the following requirements:
>> +       - read-only memory writing must only be available on the
>> current
>> +         CPU (to make sure other CPUs can't race to make changes
>> too).
>> +       - the routines must be declared inline (to discourage ROP
>> use).
>> +       - the routines must not be preemptible (likely they will
>> call
>> +         preempt_disable() and preempt_enable_no_resched()
>> respectively).
>> +       - the routines must validate expected state (e.g. when
>> enabling
>> +         writes, BUG() if writes are already be enabled).
>> +
>>  source "kernel/gcov/Kconfig"
>> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
>> index cf0fa5d86059..f95603a8ee72 100644
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -325,6 +325,44 @@ static __always_inline void
>> __write_once_size(volatile void *p, void *res, int s
>>       __u.__val;                                      \
>>  })
>>
>> +/*
>> + * Build "write rarely" infrastructure for flipping memory r/w
>> + * on a per-CPU basis.
>> + */
>> +#ifndef CONFIG_HAVE_ARCH_RARE_WRITE
>> +# define __wr_rare
>> +# define __wr_rare_type
>> +# define __rare_write_type(v)        typeof(v)
>> +# define __rare_write_ptr(v) (&(v))
>> +# define __rare_write(__var, __val)  ({              \
>> +     __var = __val;                                  \
>> +     __var;                                          \
>> +})
>> +# define rare_write_enable() do { } while (0)
>> +# define rare_write_disable()        do { } while (0)
>> +#else
>> +# define __wr_rare           __ro_after_init
>> +# define __wr_rare_type              const
>> +# define __rare_write_type(v)        typeof((typeof(v))0)
>> +# define __rare_write_ptr(v) ((__rare_write_type(v) *)&(v))
>
> Should we make __rare_write_ptr arch-specific so architectures can
> convert the pointer to rw alias from ro address like this ? [1]
>
> #ifndef __arch_rare_write_ptr
> # define __rare_write_ptr(v)    ((__rare_write_type(v) *)&(v))
> #else
> # define __rate_write_ptr(v)    __arch_rare_write_ptr
> #endif

I think that was Mark's idea too, but I'm not sure to handle the
complex cases of doing multiple updates at once (e.g. linked list
updates, etc). I think we're better doing a full disabling of RO
protection, but there had been objections to this idea in the past,
which is why I included the "complex" example, so I don't see a way
around it.

-Kees

-- 
Kees Cook
Pixel Security
