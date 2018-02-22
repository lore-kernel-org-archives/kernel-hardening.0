Date: Thu, 22 Feb 2018 20:14:23 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH RFC v8 1/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
Message-ID: <20180222191423.GA27395@pd.tnic>
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
 <1518804657-24905-2-git-send-email-alex.popov@linux.com>
 <20180221132443.GA9989@pd.tnic>
 <1e30ffd0-b35c-fcc2-ec8f-4495aefa7f6f@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1e30ffd0-b35c-fcc2-ec8f-4495aefa7f6f@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 22, 2018 at 12:49:44AM +0300, Alexander Popov wrote:
> Actually gcc creates a strange erase_kstack():
> 
> ffffffff81a00010 <erase_kstack>:
> ffffffff81a00010:	5f                   	pop    %rdi
> ffffffff81a00011:	eb 31                	jmp    ffffffff81a00044 <entry_SYSCALL_64_after_hwframe>
> ffffffff81a00013:	0f 1f 00             	nopl   (%rax)
> ffffffff81a00016:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
> ffffffff81a0001d:	00 00 00

Something's very strange here. That code looks like:

ENTRY(entry_SYSCALL_64_stage2)
        UNWIND_HINT_EMPTY
        popq    %rdi
        jmp     entry_SYSCALL_64_after_hwframe
END(entry_SYSCALL_64_stage2)

ENTRY(entry_SYSCALL_64)
...

so frankly I wonder what gcc is even doing here?!? And why isn't
that erase_kstack symbol completely empty. It gives it that address
ffffffff81a00010 and size and this looks really wrong.

/me experiments a bit more, notices the ENDPROC()...

Ok, I think I know what it is:

END(erase_kstack) gives

.globl erase_kstack ; .p2align 4, 0x90 ; erase_kstack:
# 167 "arch/x86/entry/entry_64.S"
.size erase_kstack, .-erase_kstack
# 182 "arch/x86/entry/entry_64.S"

and that generates a STT_NOTYPE symbol:

 67318: ffffffff81a00000     0 NOTYPE  GLOBAL DEFAULT    1 erase_kstack

In that case, the symbol gets ignored by objdump as it dumps this at
that address:

ffffffff81a00000 <entry_SYSCALL_64_stage2>:
ffffffff81a00000:       5f                      pop    %rdi
ffffffff81a00001:       eb 31                   jmp    ffffffff81a00034 <entry_SYSCALL_64_after_hwframe>
ffffffff81a00003:       0f 1f 00                nopl   (%rax)
ffffffff81a00006:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
ffffffff81a0000d:       00 00 00

which is basically the strange erase_kstack() variant you pasted above.

while ENDPROC(erase_kstack) gives

.globl erase_kstack ; .p2align 4, 0x90 ; erase_kstack:
# 167 "arch/x86/entry/entry_64.S"
.type erase_kstack, @function ; .size erase_kstack, .-erase_kstack
# 182 "arch/x86/entry/entry_64.S"

and that generates a STT_FUNC:

 67318: ffffffff81a00000     0 FUNC    GLOBAL DEFAULT    1 erase_kstack

Now, there's this comment over ENDPROC:

/* If symbol 'name' is treated as a subroutine (gets called, and returns)
 * then please use ENDPROC to mark 'name' as STT_FUNC for the benefit of
 * static analysis tools such as stack depth analyzer.
 */
#ifndef ENDPROC

and I don't think we want to analyze the stack depth of erase_kstack
itself.

However, even if we did END(erase_kstack), the calls are still in the
code:

ffffffff81a00111:       e8 ea fe ff ff          callq  ffffffff81a00000 <entry_SYSCALL_64_stage2>

so macro it is. But please call the macro something else, not the same
name as the function.

> The commit message says: "Full STACKLEAK feature also contains the gcc plugin
> which comes in a separate commit".
> 
> And the next commit in this series introduces that plugin. Let me quote its
> commit message as well:

...

> Tracking the lowest border of the kernel stack with the lowest_stack
> variable makes STACKLEAK so efficient (please see the performance
> statistics in the cover letter).

Aha, there it is. I guess I better continue looking through the
patchset. :)

> The mm.txt already has this line:
>  ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
> 
> Excuse me, I didn't get what to document.

You say

/* Poison value points to the unused hole in the virtual memory map */

but we do change that memory map from time to time and there are
multiple unused holes.

So do something like this so that there are no clashes when someone
decides to use that unused hole:

---
diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index ea91cb61a602..5d8f4168247d 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -24,6 +24,7 @@ ffffffffa0000000 - [fixmap start]   (~1526 MB) module mapping space (variable)
 [fixmap start]   - ffffffffff5fffff kernel-internal fixmap range
 ffffffffff600000 - ffffffffff600fff (=4 kB) legacy vsyscall ABI
 ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
+Stackleak poison value in this last hole: 0xffffffffffff4111
 
 Virtual memory map with 5 level page tables:
 
@@ -50,6 +51,7 @@ ffffffffa0000000 - fffffffffeffffff (1520 MB) module mapping space
 [fixmap start]   - ffffffffff5fffff kernel-internal fixmap range
 ffffffffff600000 - ffffffffff600fff (=4 kB) legacy vsyscall ABI
 ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
+Stackleak poison value in this last hole: 0xffffffffffff4111
 
 Architecture defines a 64-bit virtual address. Implementations can support
 less. Currently supported are 48- and 57-bit virtual addresses. Bits 63
---

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
