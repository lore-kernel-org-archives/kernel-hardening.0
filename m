Subject: Re: [PATCH RFC v10 2/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
References: <1522267032-6603-1-git-send-email-alex.popov@linux.com>
 <1522267032-6603-3-git-send-email-alex.popov@linux.com>
 <77fab6ea-0bbf-d68b-a38e-3e22d1ae6093@linux.intel.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <16a56461-6501-7eb9-e1a4-761c9eff9386@linux.com>
Date: Thu, 29 Mar 2018 09:58:32 +0300
MIME-Version: 1.0
In-Reply-To: <77fab6ea-0bbf-d68b-a38e-3e22d1ae6093@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen@linux.intel.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 29.03.2018 01:55, Dave Hansen wrote:
> On 03/28/2018 12:57 PM, Alexander Popov wrote:
>> +.macro ERASE_KSTACK
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +	PUSH_AND_CLEAR_REGS
>> +	call erase_kstack
>> +	POP_REGS
>> +#endif
>> +.endm
> 
> Thanks again for the hard work to trim down the complexity of the
> assembly. 

Hello Dave, thanks!

> I noticed the 64-bit version saves/restores registers while
> the 32-bit version doesn't.  What's the reasoning there?

When erase_kstack() is called from the trampoline stack, it must save and
restore any modified registers, since all registers except RDI are live
(prepared for the userspace).

When erase_kstack() is called from the thread stack, it can clobber registers
according the function call convention without any harm.

Best regards,
Alexander
