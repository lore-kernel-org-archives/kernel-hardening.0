MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170206085739.GH6515@twins.programming.kicks-ass.net>
References: <1486164412-7338-1-git-send-email-keescook@chromium.org>
 <1486164412-7338-5-git-send-email-keescook@chromium.org> <20170205154046.GF6515@twins.programming.kicks-ass.net>
 <CAGXu5jLvpq6B80aN44JCOfHrov5LKX1_9r4aWb7LNM7pAW_SEQ@mail.gmail.com> <20170206085739.GH6515@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 Feb 2017 08:54:38 -0800
Message-ID: <CAGXu5j+VrKBrU7op8wD1Ry4nzR0cN7Vvke8W6_KOzp3wsoEF1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 4/4] refcount: Report failures through CHECK_DATA_CORRUPTION
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 6, 2017 at 12:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, Feb 05, 2017 at 03:33:36PM -0800, Kees Cook wrote:
>> On Sun, Feb 5, 2017 at 7:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, Feb 03, 2017 at 03:26:52PM -0800, Kees Cook wrote:
>> >> This converts from WARN_ON() to CHECK_DATA_CORRUPTION() in the
>> >> CONFIG_DEBUG_REFCOUNT case. Additionally moves refcount_t sanity check
>> >> conditionals into regular function flow. Since CHECK_DATA_CORRUPTION()
>> >> is marked __much_check, we override few cases where the failure has
>> >> already been handled but we want to explicitly report it.
>> >>
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> ---
>> >>  include/linux/refcount.h | 35 ++++++++++++++++++++++-------------
>> >>  lib/Kconfig.debug        |  2 ++
>> >>  2 files changed, 24 insertions(+), 13 deletions(-)
>> >>
>> >> diff --git a/include/linux/refcount.h b/include/linux/refcount.h
>> >> index 5b89cad62237..ef32910c7dd8 100644
>> >> --- a/include/linux/refcount.h
>> >> +++ b/include/linux/refcount.h
>> >> @@ -43,10 +43,10 @@
>> >>  #include <linux/spinlock.h>
>> >>
>> >>  #if CONFIG_DEBUG_REFCOUNT
>> >> -#define REFCOUNT_WARN(cond, str) WARN_ON(cond)
>> >> +#define REFCOUNT_CHECK(cond, str) CHECK_DATA_CORRUPTION(cond, str)
>> >
>> > OK, so that goes back to a full WARN() which will make the generated
>> > code gigantic due to the whole printk() trainwreck :/
>>
>> Hrm, perhaps we need three levels? WARN_ON, WARN, and BUG?
>
> Did consider that, didn't really know if that made sense.
>
> Like I wrote, ideally we'd end up using something like the x86 exception
> table with a custom handler. Just no idea how to pull that off without
> doing a full blown arch specific implementation, so I didn't go there
> quite yet.

I haven't spent much time looking at the extable stuff. (Though
coincidentally, I was poking at it for x86's test_nx stuff...) I
thought there was a way to build arch-agnostic extables already?
kernel/extable.c is unconditionally built-in, for example.

> That way refcount_inc() would end up being inlined to something like:
>
>         mov    0x148(%rdi),%eax
>         jmp    2f
>   1:    lock cmpxchg %edx,0x148(%rdi)
>         je     4f
>   2:    lea    -0x1(%rax),%ecx
>         lea    0x1(%rax),%edx
>         cmp    $0xfffffffd,%ecx
>         jbe    1b
>   3:    ud2
>   4:
>
>         _ASM_EXTABLE_HANDLE(3b, 4b, ex_handler_refcount_inc)
>
>
> where:
>
> bool ex_handler_refcount_inc(const struct exception_table_entry *fixup,
>                              struct pt_regs *regs, int trapnr)
> {
>         regs->ip = ex_fixup_addr(fixup);
>
>         if (!regs->ax)
>                 WARN(1, "refcount_t: increment on 0; use-after-free.\n");
>         else
>                 WARN(1, "refcount_t: saturated; leaking memory.\n");
>
>         return true;
> }
>
> and the handler is shared between all instances and can be as big and
> fancy as we'd like.

I'll dig a bit to see what I can build. Can you add the lkdtm tests to
the series, though? That should be fine as-is.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
