Date: Mon, 30 Oct 2017 18:32:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20171030173216.72y673m32gra4b55@hirez.programming.kicks-ass.net>
References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <1508631773-2502-3-git-send-email-alex.popov@linux.com>
 <d74e0d32-d794-62d1-27fa-d96f4cf37522@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d74e0d32-d794-62d1-27fa-d96f4cf37522@linux.com>
Subject: [kernel-hardening] Re: [PATCH RFC v5 2/5] gcc-plugins: Add STACKLEAK plugin for
 tracking the kernel stack
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 30, 2017 at 07:51:33PM +0300, Alexander Popov wrote:
> When the thread stack is exhausted, this BUG() is hit. But do_error_trap(),
> which handles the exception, calls track_stack() itself again (since it is
> instrumented by the gcc plugin). So this recursion proceeds with exhausting the
> thread stack.

Add a __attribute__((nostacktrack)) on it?
