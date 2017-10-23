References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <20171022131157.GB3165@worktop.lehotels.local>
 <20171023090829.bmddmm7463yhnqaf@salmiak>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <9193330a-0272-6a52-a3fb-cb8518f8da06@linux.com>
Date: Mon, 23 Oct 2017 15:11:44 +0300
MIME-Version: 1.0
In-Reply-To: <20171023090829.bmddmm7463yhnqaf@salmiak>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v5 0/5] Introduce the STACKLEAK feature and a test for
 it
To: Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello Peter and Mark,

On 23.10.2017 12:08, Mark Rutland wrote:
> On Sun, Oct 22, 2017 at 03:11:57PM +0200, Peter Zijlstra wrote:
>> On Sun, Oct 22, 2017 at 03:22:48AM +0300, Alexander Popov wrote:
>>> Further work
>>> =============
>>>
>>>  - Rewrite erase_kstack() in C (if Ingo Molnar insists).
>>
>> Aside from legacy, is there any sane reason that stuff is in ASM? That
>> is, I too will insist it being in C unless you can provide good
>> arguments on why it needs be asm. All it does is memzero() right? And I
>> would think architectures already have fairly optimized implementations
>> of that around.

I added very detailed comments describing erase_kstack() on x86_64. It is quite
tricky for being fast.

It starts from the lowest_stack address and goes down to the bottom of the stack
searching for the poison value (-0xBEEF). If it reaches the stack bottom or
finds 17 poison values in a row, it starts to fill the memory between the
current position and the stack pointer with a poison value. Finally it resets
the lowest_stack value. So only used part of the kernel stack is actually erased.

I really like the PaX Team's code in erase_kstack().

> One argument for this being in asm is that you can't control the stack
> usage of a C implementation of erase_kstack(), which leaves a (small)
> portion of the stack potentially not cleared depending on what exactly
> the compiler does with the stack.
> 
> If it's just a call to memzero(), the asm should be very simple, and I'd
> think it's better to err on the side of clearing as much of the stack as
> possible.

Laura Abbott wrote about her issues with erase_kstack() and gcc in the previous
thread: http://www.openwall.com/lists/kernel-hardening/2017/10/10/3

Anyway, I'll obey the final decision.

Best regards,
Alexander
