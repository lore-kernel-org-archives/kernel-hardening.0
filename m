MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <b7afe9c1-1112-1605-e0a1-2cfd5c6d88ca@linux.com>
References: <1526488097-20611-1-git-send-email-alex.popov@linux.com>
 <1526488097-20611-3-git-send-email-alex.popov@linux.com> <20180518065349.GA10080@gmail.com>
 <23369d86-ad31-e7c5-e42f-28e0e51ec128@linux.com> <CAGXu5jKcZope_h1Hr2iAwzOe16A=sT-UXJF2ugg2w8rV0_i7jA@mail.gmail.com>
 <b7afe9c1-1112-1605-e0a1-2cfd5c6d88ca@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 22 May 2018 14:19:14 -0700
Message-ID: <CAGXu5jJExz263gs6MpU4-NKR0qLvj=POAahrtbnYGiRbPQNtuQ@mail.gmail.com>
Subject: Re: [PATCH v12 2/6] x86/entry: Add STACKLEAK erasing the kernel stack
 at the end of syscalls
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 22, 2018 at 2:00 PM, Alexander Popov <alex.popov@linux.com> wrote:
> Currently 'lowest_stack' is a part of 'thread_struct', which is a "CPU-specific
> state of this task". But in fact 'lowest_stack' is not CPU-specific. If I move
> it to 'task_struct', Laura will avoid redefining it in 'thread_struct' in
> arch/arm64/include/asm/processor.h. And that will also allow me to create a
> stackleak_task_init() inline helper in stackleak.h.

Okay, give it a go! :)

-Kees

-- 
Kees Cook
Pixel Security
