Date: Fri, 8 Dec 2017 12:44:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20171208114431.tzteuiovgnn53t5r@hirez.programming.kicks-ass.net>
References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
 <1512516827-29797-2-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512516827-29797-2-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] Re: [PATCH RFC v6 1/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 06, 2017 at 02:33:42AM +0300, Alexander Popov wrote:
> The STACKLEAK feature erases the kernel stack before returning from
> syscalls. That reduces the information which kernel stack leak bugs can
> reveal and blocks some uninitialized stack variable attacks. Moreover,
> STACKLEAK provides runtime checks for kernel stack overflow detection.
> 
> This commit introduces the architecture-specific code filling the used
> part of the kernel stack with a poison value before returning to the
> userspace. Full STACKLEAK feature also contains the gcc plugin which
> comes in a separate commit.

Have you looked at the entry rework in this series:

  https://lkml.kernel.org/r/20171204140706.296109558@linutronix.de
