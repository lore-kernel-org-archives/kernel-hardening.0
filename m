MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJVSG7ZuftTRGZjgKqetpmxNpeqwxAzhY8BJ4_H-oUw5w@mail.gmail.com>
References: <CAGXu5j+4mEyhE6shkxWqY4AVQGcq2U7nzf4j_n2+CdW2t6CzqQ@mail.gmail.com>
 <CA+55aFykZL+cSBJjBBts7ebEFfyGPdMzTmLSxKnT_29=j942dA@mail.gmail.com> <CAGXu5jJVSG7ZuftTRGZjgKqetpmxNpeqwxAzhY8BJ4_H-oUw5w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Mar 2018 10:45:30 -0700
Message-ID: <CA+55aFyfW901QRpdmgEsaY8b4+AOPf2SKKVo7mNs2iRUTHND3w@mail.gmail.com>
Subject: Re: Fully initialized stack usage (was Re: [PATCH RFC v9 4/7]
 x86/entry: Erase kernel stack in syscall_trace_enter())
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, P J P <pjp@fedoraproject.org>, Florian Weimer <fweimer@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, Daniel Micay <danielmicay@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 10:17 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Mar 12, 2018 at 10:09 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>     struct xyz var = { };
>>
>> I'm not sure what that will do with padding.
>
> AIUI, this does not guarantee padding initialization (yet another
> "undefined behavior"). This is why we've had to sprinkle memset(&var,
> 0, sizeof(var)) in places where a structure has padding and got
> leaked. :(
>
> I assume this may be orthogonal to -finit-local-vars, and maybe we'll
> need some -finit-padding or something. (Though, honestly, is there
> anyone that wants to get _padding_ correct, but not variable
> initialization?)

We would definitely have wanted it over the years, yes. And
conceptually it's a separate issue, so a separate flag makes sense.

But for the kernel, if we have -finit-local-vars, we'd just use that,
so you're right that _we_ don't care, and I don't know if anybody else
does either.

Maybe some security-conscious project would, though. I can definitely
see some project going "we always initialize our stuff ourselves, but
we still worry about padding".

So a separate flag for that would make a lot of sense.

> I'm fine with it going away, though I share Jeff Law's observation in
> Florian's gcc thread that we lose some potentially useful warnings
> ("oops, it took a while to track down this bug, since that variable
> had been zero initialized; I wish I knew that had happened", etc.) And
> when the kernel entirely depends on auto-zero-init, we could just add
> -Wno-maybe-uninitialized. *shrug*

I think it's actually _fundamentally_ hard to give the "might be used
uninitialized" warning together with "-finit-local-vars".

You have to introduce a whole new "zero but counts as uninitialized" model.

So I suspect the gcc people would be better off doing the reverse of
what you suggest: tell people to simply do test builds without
"-finit-local-vars".

For example, for the kernel, we already have that
"CONFIG_COMPILE_TEST" explicitly for the case of "build but don't use"
for build coverage. So it would make sense for us to only use
"-finit-local-vars" when COMPILE_TEST is _not_ set. That would give us
the warnings for our coverage, but all "real" builds would be built
with the initializations.

                    Linus
