MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <c5a605b8-423f-5e92-5fbe-12cb44a70bd6@linux.intel.com>
References: <1523024546-6150-1-git-send-email-alex.popov@linux.com>
 <1523024546-6150-3-git-send-email-alex.popov@linux.com> <CAGXu5jKm218fpxyV3vOM+2SO-ERG3tWPUV0x8+-S0MJAReFz+A@mail.gmail.com>
 <c5a605b8-423f-5e92-5fbe-12cb44a70bd6@linux.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 23 Apr 2018 18:03:51 -0700
Message-ID: <CAGXu5jJT=SAe5NNKWXu6CXLhX7_C7i4qJ4Znd92jnGxb71UJdA@mail.gmail.com>
Subject: Re: [PATCH v11 2/6] x86/entry: Add STACKLEAK erasing the kernel stack
 at the end of syscalls
Content-Type: text/plain; charset="UTF-8"
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Popov <alex.popov@linux.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 18, 2018 at 11:50 AM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
> On 04/16/2018 11:29 AM, Kees Cook wrote:
>> Dave, Ingo, Linus: how does this look? With the assembly rewritten
>> into C, the entry changes are very small:
>
> The assembly looks very nice to me now.  It is as minimally invasive as
> it can get.  Definitely no objections from me on that part.

Can you give an Acked-by for the x86 parts? Or Ingo?

If this is workable, I'd like to carry it in -next to see if anything
else shakes out...

-Kees

-- 
Kees Cook
Pixel Security
