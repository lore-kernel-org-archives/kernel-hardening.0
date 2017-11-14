From: Alexander Popov <alex.popov@linux.com>
References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <1508631773-2502-3-git-send-email-alex.popov@linux.com>
 <d74e0d32-d794-62d1-27fa-d96f4cf37522@linux.com>
 <20171030173216.72y673m32gra4b55@hirez.programming.kicks-ass.net>
 <586ee584-df0d-3c82-a254-16ac1573255a@linux.com>
Message-ID: <69522d43-f1b9-48ac-6235-a237c0298a04@linux.com>
Date: Tue, 14 Nov 2017 18:36:31 +0300
MIME-Version: 1.0
In-Reply-To: <586ee584-df0d-3c82-a254-16ac1573255a@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v5 2/5] gcc-plugins: Add STACKLEAK plugin for tracking
 the kernel stack
To: Andy Lutomirski <luto@kernel.org>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 30.10.2017 21:06, Alexander Popov wrote:
> On 30.10.2017 20:32, Peter Zijlstra wrote:
>> On Mon, Oct 30, 2017 at 07:51:33PM +0300, Alexander Popov wrote:
>>> When the thread stack is exhausted, this BUG() is hit. But do_error_trap(),
>>> which handles the exception, calls track_stack() itself again (since it is
>>> instrumented by the gcc plugin). So this recursion proceeds with exhausting the
>>> thread stack.
>>
>> Add a __attribute__((nostacktrack)) on it?
> 
> Yes, I already tried some blacklisting in the plugin, but it didn't really help,
> because:
> 
> 1. there are other (more than 5) instrumented functions, that are called during
> BUG() handling too;
> 
> 2. decreasing CONFIG_STACKLEAK_TRACK_MIN_SIZE would add more instrumented
> functions, which should be manually blacklisted (not good).
> 
> I guess handling BUG() in another stack would be a solution. For example, Andy
> Lutomirski calls handle_stack_overflow in the DOUBLEFAULT_STACK
> (arch/x86/mm/fault.c). Should I do something similar?

Hello Andy! May I ask your advice?

When CONFIG_VMAP_STACK is disabled and STACKLEAK is enabled (for example, on
x86_32), we need another way to detect stack depth overflow. That is the reason
of having this BUG() in track_stack(). But it turns out to be recursive since
track_stack() will be called again during BUG() handling.

We can avoid that recursion by handling oops in another stack. It looks similar
to the way you call handle_stack_overflow() in arch/x86/mm/fault.c. But it seems
that I can't reuse that code, am I right?

How should I do it properly?

By the way, you wrote that you have some entry code changes which conflict with
STACKLEAK. May I ask for more details?

Best regards,
Alexander
