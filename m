Subject: Re: [PATCH v13 (resend) 2/6] x86/entry: Add STACKLEAK erasing the
 kernel stack at the end of syscalls
References: <1529686717-16017-1-git-send-email-alex.popov@linux.com>
 <1529686717-16017-3-git-send-email-alex.popov@linux.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <3e319e96-e942-7c87-7b72-a5c3f520f234@redhat.com>
Date: Fri, 22 Jun 2018 11:58:00 -0700
MIME-Version: 1.0
In-Reply-To: <1529686717-16017-3-git-send-email-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 06/22/2018 09:58 AM, Alexander Popov wrote:
> +	/*
> +	 * Now write the poison value to the kernel stack. Start from
> +	 * 'kstack_ptr' and move up till the new 'boundary'. We assume that
> +	 * the stack pointer doesn't change when we write poison.
> +	 */
> +	if (on_thread_stack())
> +		boundary = current_stack_pointer;
> +	else
> +		boundary = current_top_of_stack();
> +
> +	BUG_ON(boundary - kstack_ptr >= THREAD_SIZE);
> +
> +	while (kstack_ptr < boundary) {
> +		*(unsigned long *)kstack_ptr = STACKLEAK_POISON;
> +		kstack_ptr += sizeof(unsigned long);
> +	}
> +
> +	/* Reset the 'lowest_stack' value for the next syscall */
> +	current->lowest_stack = current_top_of_stack() - THREAD_SIZE / 64;

on_thread_stack() and current_top_of_stack() are x86 only
functions currently defined in asm/processor.h. There are
similar functions in arch/arm64/include/asm/stacktrace.h
which I think I can use to build those functions. Should
I just throw the arm64 versions in processor.h or do
we want to consider abstracting these into something like
asm/stackleak.h? I'd like to know a direction before I
start ripping apart stacktrace.h.

Thanks,
Laura
