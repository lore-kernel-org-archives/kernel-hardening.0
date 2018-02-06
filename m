MIME-Version: 1.0
In-Reply-To: <CA+55aFxYHX3=HN4P5M0ziSJ08WfjccyhE2T7epS-EC6ZJ6LyjQ@mail.gmail.com>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632014097.21271.16980532033566583357.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180206192925.qkmghwsbaysr4iv2@hermes.olymp> <CAPcyv4ihN6fy5-vBtfA0PuwXvCAj8-rMhtQmevh5sdYxbH3Yfw@mail.gmail.com>
 <CA+55aFxYHX3=HN4P5M0ziSJ08WfjccyhE2T7epS-EC6ZJ6LyjQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Feb 2018 12:37:54 -0800
Message-ID: <CAPcyv4i5oORdk-Fzypxw_+gCLUa8f=w1e_n0=47P7uHR-jT6GQ@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] x86: narrow out of bounds syscalls to sys_read
 under speculation
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis Henriques <lhenriques@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 6, 2018 at 12:26 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Feb 6, 2018 at 11:48 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> Just to clarify, when you say "this patch" you mean:
>>
>>      2fbd7af5af86 x86/syscall: Sanitize syscall table de-references
>> under speculation
>>
>> ...not this early MASK_NOSPEC version of the patch, right?
>
> I suspect not. If that patch is broken, the system wouldn't even boot.
>
> That said, looking at 2fbd7af5af86, I do note that the code generation
> is horribly stupid.
>
> It's due to two different issues:
>
>  (a) the x86 asm constraints for that inline asm is nasty, and
> requires a register for 'size', even though an immediate works just
> fine.
>
>  (b) the "cmp" is inside the asm, so gcc can't combine it with the
> *other* cmp in the C code.
>
> Fixing (a) is easy:
>
>   +++ b/arch/x86/include/asm/barrier.h
>   @@ -43 +43 @@ static inline unsigned long
> array_index_mask_nospec(unsigned long index,
>   -                       :"r"(size),"r" (index)
>   +                       :"ir"(size),"r" (index)
>
> but fixing (b) looks fundamentally hard. Gcc generates (for do_syscall()):
>
>         cmpq    $332, %rbp      #, nr
>         ja      .L295   #,
>         cmp $333,%rbp
>         sbb %rax,%rax;   #, nr, mask
>
> note how it completely pointlessly does the comparison twice, even
> though it could have just done
>
>         cmp $333,%rbp
>         jae      .L295   #,
>         sbb %rax,%rax;   #, nr, mask
>
> Ho humm. Sad.

Are there any compilers that would miscompile:

    mask = 0 - (index < size);

That might be a way to improve the assembly.
