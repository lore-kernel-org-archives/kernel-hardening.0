Subject: Re: [PATCH v13 (resend) 2/6] x86/entry: Add STACKLEAK erasing the
 kernel stack at the end of syscalls
References: <1529686717-16017-1-git-send-email-alex.popov@linux.com>
 <1529686717-16017-3-git-send-email-alex.popov@linux.com>
 <3e319e96-e942-7c87-7b72-a5c3f520f234@redhat.com>
 <CAGXu5j+2d-2SpzitAaB65zT6FjhmOYiCKSRfRQHcUUvOQ1CDGg@mail.gmail.com>
 <CAGXu5jKCRC0qfPt5L1cqaGpWTLG0fKCe+jAFvtCehHzTFXvf+A@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <172bdd35-e9b3-95ca-c1bc-58bd7894483b@redhat.com>
Date: Tue, 26 Jun 2018 17:55:40 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKCRC0qfPt5L1cqaGpWTLG0fKCe+jAFvtCehHzTFXvf+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 06/26/2018 05:21 PM, Kees Cook wrote:
> On Tue, Jun 26, 2018 at 5:13 PM, Kees Cook <keescook@chromium.org> wrote:
>> The only arch-specific part is current_top_of_stack(), so it seems
>> like just solving current_top_of_stack() and copying on_thread_stack()
>> directly should work, yes? I would think sticking those directly into
>> asm/processor.h on arm64 would be okay?
> 
> The difference in the earlier x86 and arm64 erase_kstack was:
> 
> x86:
>          if (on_thread_stack())
>                  boundary = current_stack_pointer;
>          else
>                  boundary = current_top_of_stack();
> 
> arm64:
>          boundary = current_stack_pointer;
> 
> If a sane current_top_of_stack() isn't possible on arm64, I'm not
> opposed to a small bit of arch-specific ifdef in there:
> 
>          boundary = get_stack_boundary();
> 
> static inline unsigned long get_stack_boundary(void)
> {
> #ifdef CONFIG_X86
>          if (!on_thread_stack())
>                  return current_top_of_stack();
> #else
>           return current_stack_pointer;
> }
> 
> -Kees
> 

I _think_ I have reasonable implementations for both functions,
I was asking about pulling stuff out into a new header because
I wanted to see about reusing on_task_stack which was defined
in asm/stacktrace.h and I was concerned about include nightmares
with asm/processor.h . I'll see what I come up with.

Thanks,
Laura
