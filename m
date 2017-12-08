References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
 <1512516827-29797-2-git-send-email-alex.popov@linux.com>
 <20171208114431.tzteuiovgnn53t5r@hirez.programming.kicks-ass.net>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <221a291b-677a-1cc6-6270-bfc0a85ac225@linux.com>
Date: Sat, 9 Dec 2017 00:54:21 +0300
MIME-Version: 1.0
In-Reply-To: <20171208114431.tzteuiovgnn53t5r@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v6 1/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello Peter,

On 08.12.2017 14:44, Peter Zijlstra wrote:
> On Wed, Dec 06, 2017 at 02:33:42AM +0300, Alexander Popov wrote:
>> The STACKLEAK feature erases the kernel stack before returning from
>> syscalls. That reduces the information which kernel stack leak bugs can
>> reveal and blocks some uninitialized stack variable attacks. Moreover,
>> STACKLEAK provides runtime checks for kernel stack overflow detection.
>>
>> This commit introduces the architecture-specific code filling the used
>> part of the kernel stack with a poison value before returning to the
>> userspace. Full STACKLEAK feature also contains the gcc plugin which
>> comes in a separate commit.
> 
> Have you looked at the entry rework in this series:
> 
>   https://lkml.kernel.org/r/20171204140706.296109558@linutronix.de

Thanks for the link. I briefly looked through WIP.x86/pti branch. Should I
rebase STACKLEAK patch series onto it?

Although I don't fully understand some of the commits, I can suppose that
STACKLEAK stack erasing must be modified because of this trampoline stack
introduction:
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=WIP.x86/pti&id=813b4125a835f2eb9aa6fb08dac0bc8eeadd69a1

Am I right? Are there other changes which I should consider?

May I also ask for your feedback on this version of the STACKLEAK patch series?
Thanks!

Best regards,
Alexander
