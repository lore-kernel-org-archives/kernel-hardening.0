Subject: Re: [PATCH RFC v9 2/7] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-3-git-send-email-alex.popov@linux.com>
 <d968e58a-3abd-8e3c-cee3-00c19c1b6430@linux.intel.com>
 <94f268b2-31a4-620a-86ed-325d5bb33c57@redhat.com>
 <20180305202535.GX25201@hirez.programming.kicks-ass.net>
 <e043e0d6-3265-4bc2-ae11-ab430832a8e2@linux.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <295a6830-fce9-ee00-f45d-7dafd74d11a1@linux.intel.com>
Date: Wed, 21 Mar 2018 08:33:29 -0700
MIME-Version: 1.0
In-Reply-To: <e043e0d6-3265-4bc2-ae11-ab430832a8e2@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: alex.popov@linux.com, Peter Zijlstra <peterz@infradead.org>, Laura Abbott <labbott@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>
Cc: PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, linux-kernel@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/21/2018 04:04 AM, Alexander Popov wrote:
> The main obstacle:
> erase_kstack() must save and restore any modified registers, because it is
> called from the trampoline stack (introduced by Andy Lutomirski), when all
> registers except RDI are live.

Wow, cool, thanks for doing this!

PTI might also cause you some problems here because it probably won't
map your function.  Did you have to put it in one of the sections that
gets mapped by the user page tables?
