Subject: Re: [PATCH RFC v8 1/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
 <1518804657-24905-2-git-send-email-alex.popov@linux.com>
 <20180221132443.GA9989@pd.tnic>
 <1e30ffd0-b35c-fcc2-ec8f-4495aefa7f6f@linux.com>
 <20180222191423.GA27395@pd.tnic>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <3581c5d9-1f25-a0c9-4f6f-814e25ab170e@linux.com>
Date: Thu, 22 Feb 2018 23:24:12 +0300
MIME-Version: 1.0
In-Reply-To: <20180222191423.GA27395@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Borislav Petkov <bp@alien8.de>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello Borislav,

On 22.02.2018 22:14, Borislav Petkov wrote:
> On Thu, Feb 22, 2018 at 12:49:44AM +0300, Alexander Popov wrote:
> However, even if we did END(erase_kstack), the calls are still in the
> code:
> 
> ffffffff81a00111:       e8 ea fe ff ff          callq  ffffffff81a00000 <entry_SYSCALL_64_stage2>
> 
> so macro it is. But please call the macro something else, not the same
> name as the function.

Thanks for your time spent on this! I'll call it ERASE_KSTACK and it will look
like other macros.

>> The mm.txt already has this line:
>>  ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
>>
>> Excuse me, I didn't get what to document.
> 
> You say
> 
> /* Poison value points to the unused hole in the virtual memory map */
> 
> but we do change that memory map from time to time and there are
> multiple unused holes.
> 
> So do something like this so that there are no clashes when someone
> decides to use that unused hole:
> 
> ---
> diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
> index ea91cb61a602..5d8f4168247d 100644
> --- a/Documentation/x86/x86_64/mm.txt
> +++ b/Documentation/x86/x86_64/mm.txt
> @@ -24,6 +24,7 @@ ffffffffa0000000 - [fixmap start]   (~1526 MB) module mapping space (variable)
>  [fixmap start]   - ffffffffff5fffff kernel-internal fixmap range
>  ffffffffff600000 - ffffffffff600fff (=4 kB) legacy vsyscall ABI
>  ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
> +Stackleak poison value in this last hole: 0xffffffffffff4111
>  
>  Virtual memory map with 5 level page tables:
>  
> @@ -50,6 +51,7 @@ ffffffffa0000000 - fffffffffeffffff (1520 MB) module mapping space
>  [fixmap start]   - ffffffffff5fffff kernel-internal fixmap range
>  ffffffffff600000 - ffffffffff600fff (=4 kB) legacy vsyscall ABI
>  ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
> +Stackleak poison value in this last hole: 0xffffffffffff4111

Ok, I see. Thank you very much.

Best regards,
Alexander
