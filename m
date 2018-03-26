MIME-Version: 1.0
In-Reply-To: <CAGXu5jKLErrvewvSiusr7qPup-08YgvLKC1ZT7FKTR_RyDSTuQ@mail.gmail.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-3-git-send-email-alex.popov@linux.com> <d968e58a-3abd-8e3c-cee3-00c19c1b6430@linux.intel.com>
 <94f268b2-31a4-620a-86ed-325d5bb33c57@redhat.com> <20180305202535.GX25201@hirez.programming.kicks-ass.net>
 <e043e0d6-3265-4bc2-ae11-ab430832a8e2@linux.com> <295a6830-fce9-ee00-f45d-7dafd74d11a1@linux.intel.com>
 <ac1a2090-e120-d202-35b4-b158d4787ab5@linux.com> <CAGXu5jKLErrvewvSiusr7qPup-08YgvLKC1ZT7FKTR_RyDSTuQ@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 26 Mar 2018 17:43:42 +0000
Message-ID: <CALCETrXWzMQHBKzkm3oLt7SfQQcYp0hz=ckQfay0t4mAV5NxyA@mail.gmail.com>
Subject: Re: [PATCH RFC v9 2/7] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Laura Abbott <labbott@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 26, 2018 at 5:32 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Mar 22, 2018 at 1:56 PM, Alexander Popov <alex.popov@linux.com> wrote:
>> By the way, during my work on STACKLEAK, I've found one case when we get to the
>> userspace directly from the thread stack. Please see sysret32_from_system_call
>> in entry_64_compat.S. I checked that.
>>
>> IMO it seems odd, can the adversary use that to bypass PTI?
>
> If it was missing the page table swap, shouldn't this mean that the
> missing NX bit would immediately crash userspace?

sysret32_from_system_call does;

    SWITCH_TO_USER_CR3_NOSTACK scratch_reg=%r8 scratch_reg2=%r9
