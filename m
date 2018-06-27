MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <3e319e96-e942-7c87-7b72-a5c3f520f234@redhat.com>
References: <1529686717-16017-1-git-send-email-alex.popov@linux.com>
 <1529686717-16017-3-git-send-email-alex.popov@linux.com> <3e319e96-e942-7c87-7b72-a5c3f520f234@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 26 Jun 2018 17:13:58 -0700
Message-ID: <CAGXu5j+2d-2SpzitAaB65zT6FjhmOYiCKSRfRQHcUUvOQ1CDGg@mail.gmail.com>
Subject: Re: [PATCH v13 (resend) 2/6] x86/entry: Add STACKLEAK erasing the
 kernel stack at the end of syscalls
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 22, 2018 at 11:58 AM, Laura Abbott <labbott@redhat.com> wrote:
> On 06/22/2018 09:58 AM, Alexander Popov wrote:
>>
>> +       /*
>> +        * Now write the poison value to the kernel stack. Start from
>> +        * 'kstack_ptr' and move up till the new 'boundary'. We assume
>> that
>> +        * the stack pointer doesn't change when we write poison.
>> +        */
>> +       if (on_thread_stack())
>> +               boundary = current_stack_pointer;
>> +       else
>> +               boundary = current_top_of_stack();
>> +
>> +       BUG_ON(boundary - kstack_ptr >= THREAD_SIZE);
>> +
>> +       while (kstack_ptr < boundary) {
>> +               *(unsigned long *)kstack_ptr = STACKLEAK_POISON;
>> +               kstack_ptr += sizeof(unsigned long);
>> +       }
>> +
>> +       /* Reset the 'lowest_stack' value for the next syscall */
>> +       current->lowest_stack = current_top_of_stack() - THREAD_SIZE / 64;
>
>
> on_thread_stack() and current_top_of_stack() are x86 only
> functions currently defined in asm/processor.h. There are
> similar functions in arch/arm64/include/asm/stacktrace.h
> which I think I can use to build those functions. Should
> I just throw the arm64 versions in processor.h or do
> we want to consider abstracting these into something like
> asm/stackleak.h? I'd like to know a direction before I
> start ripping apart stacktrace.h.

static inline unsigned long current_top_of_stack(void)
{
        /*
         *  We can't read directly from tss.sp0: sp0 on x86_32 is special in
         *  and around vm86 mode and sp0 on x86_64 is special because of the
         *  entry trampoline.
         */
        return this_cpu_read_stable(cpu_current_top_of_stack);
}

static inline bool on_thread_stack(void)
{
        return (unsigned long)(current_top_of_stack() -
                               current_stack_pointer) < THREAD_SIZE;
}

The only arch-specific part is current_top_of_stack(), so it seems
like just solving current_top_of_stack() and copying on_thread_stack()
directly should work, yes? I would think sticking those directly into
asm/processor.h on arm64 would be okay?

FWIW, I don't think a separate asm/stackleak.h is needed.

-Kees

-- 
Kees Cook
Pixel Security
