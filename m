Subject: Re: Fully initialized stack usage (was Re: [PATCH RFC v9 4/7]
 x86/entry: Erase kernel stack in syscall_trace_enter())
References: <CAGXu5j+4mEyhE6shkxWqY4AVQGcq2U7nzf4j_n2+CdW2t6CzqQ@mail.gmail.com>
 <CA+55aFykZL+cSBJjBBts7ebEFfyGPdMzTmLSxKnT_29=j942dA@mail.gmail.com>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <95d330b0-33fc-1937-c031-e8ecd6fbbc8b@redhat.com>
Date: Wed, 14 Mar 2018 15:16:33 +0100
MIME-Version: 1.0
In-Reply-To: <CA+55aFykZL+cSBJjBBts7ebEFfyGPdMzTmLSxKnT_29=j942dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, P J P <pjp@fedoraproject.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, Daniel Micay <danielmicay@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/12/2018 06:09 PM, Linus Torvalds wrote:
> The only complaint I have is that the Fortran front-end already has
> (some of) that functionality, and calls it something else, and allows
> you to specify more exactly what you want to clear.
> 
> Florian, are you aware of the Fortran flags?
> 
>    -finit-local-zero
>    -finit-derived
>    -finit-integer=n
>    -finit-real=<zero|inf|-inf|nan|snan>
>    -finit-logical=<true|false>
>    -finit-character=n
> 
> they aren't perfect for C, but some of them do make sense at least
> conceptually: things like being able to specify whether arrays and
> structures should be initialized (-finit-derived is kind of relevant)
> might make sense.

I think I was aware of those when I put together the GCC patch, but it's 
been a while, so I don't know for sure.

>> - the kernel needs a way to "opt out" of this for places where later
>> functions will do the initialization. Something like
>> __attribute__((no_automatic_variable_init)) ?
> 
> Yes, that's going to make it more palatable to some uses.
> 
> However, somebody who knows gcc needs to verify that it does the right
> things when inlining happens.

Given that the initializer is added in the parser, we should be able to 
look at the current function definition and get the attribute from 
there.  Only if you want to do some special for nested functions, it's 
going to be tricky.  Once the initializer is there, it will survive 
inlining, of course.

> Good point. It uses build_constructor() with an empty constructor, so
> it *should* be 100% equivalent to
> 
>     struct xyz var = { };
> 
> if I understand correctly, but I'm not sure what that will do with padding.

There is no guarantee WRT padding if I understand this correctly.  But 
not initializing padding would be less efficient, so GCC should do the 
right thing here.  But this really needs to be careful checking by 
someone familiar with the middle-end and the relevant backends.

Note that this patch was only for measuring the performance impact, so I 
didn't polish these finer points.

>> - Can we retain the uninitialized variable usage warning? (with an
>> updated text; maybe "variable used without explicit initialization,
>> using zero-initialization"?)
> 
> I think that fundamentally goes away, because all later phases see
> fully initialized state.

Yes, retaining the warning will need a completely different approach.

Thanks,
Florian
