Subject: Re: [PATCH RFC v10 2/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
References: <1522267032-6603-1-git-send-email-alex.popov@linux.com>
 <1522267032-6603-3-git-send-email-alex.popov@linux.com>
 <77fab6ea-0bbf-d68b-a38e-3e22d1ae6093@linux.intel.com>
 <16a56461-6501-7eb9-e1a4-761c9eff9386@linux.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <ad614e86-7e39-e9b7-4a8f-3ea1f5a7b61d@linux.intel.com>
Date: Thu, 29 Mar 2018 06:51:23 -0700
MIME-Version: 1.0
In-Reply-To: <16a56461-6501-7eb9-e1a4-761c9eff9386@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: alex.popov@linux.com, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 03/28/2018 11:58 PM, Alexander Popov wrote:
>> I noticed the 64-bit version saves/restores registers while
>> the 32-bit version doesn't.  What's the reasoning there?
> When erase_kstack() is called from the trampoline stack, it must save and
> restore any modified registers, since all registers except RDI are live
> (prepared for the userspace).
> 
> When erase_kstack() is called from the thread stack, it can clobber registers
> according the function call convention without any harm.

Oh, and since there's no 32-bit trampoline stack, we don't need it on
32-bit?

If end up reposting this set again, could you add a few comments about
this around the ERASE_KSTACK macro definitions, or perhaps the call
sites?  You might even want to call them ERASE_KSTACK_CLOBBER (for
32-bit) and ERASE_KSTACK_NOCLOBBER (for 64-bit) to make this more clear.
