MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <791341f5-4347-ba38-0710-93551a45ec38@linux.com>
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com> <791341f5-4347-ba38-0710-93551a45ec38@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Feb 2018 15:17:21 -0800
Message-ID: <CAGXu5jJ+dWjtjJ88ziOoyTJnSxbjdvEJd5LGY9nxWxHpVR6pug@mail.gmail.com>
Subject: Re: [PATCH RFC v8 0/6] Introduce the STACKLEAK feature and a test for it
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>, Mohamed Ghannam <simo.ghannam@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 20, 2018 at 2:29 AM, Alexander Popov <alex.popov@linux.com> wrote:
> On 16.02.2018 21:10, Alexander Popov wrote:
>> This is the 8th version of the patch series introducing STACKLEAK to the
>> mainline kernel. I've made some minor improvements while waiting for the
>> next review by x86 maintainers.

If we can borrow some of luto or tglx's time, I think that'd be best:
they've been looking at the entry code a lot lately. :) Regardless, I
think the addition to the entry code is clean (especially now that the
fast path is gone *sob*). :P

>> STACKLEAK is a security feature developed by Grsecurity/PaX (kudos to them),
>> which:
>>  - reduces the information that can be revealed through kernel stack leak bugs;
>>  - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>>  - introduces some runtime checks for kernel stack overflow detection.

I've added this series to my kernel.org trees, which means 0-day will
start grinding on it too now:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git
kspp/gcc-plugin/stackleak

The LKDTM tests look great and check out for me. I think the code is
clear, so I'd like to get it into -next, but I want to be sure I'm not
stepping on x86 toes first.

Laura, how does arm64 look for this? Would it be possible to add it to
this series (at least on kernel.org for build/run testing)?

> Hello! I've just tested STACKLEAK against the recent CVE-2017-17712 exploit:
> http://openwall.com/lists/oss-security/2018/02/20/1
>
> This vulnerability is a race condition in raw_sendmsg() in net/ipv4/raw.c. It
> leads to uninitialized stack pointer usage which can be used for a local
> privilege escalation.
>
> CVE-2017-17712 was discovered and fixed by Mohamed Ghannam (kudos to him!). He
> also provided a stable PoC exploit for it.
>
> With STACKLEAK, the uninitialized stack pointer is set to STACKLEAK_POISON
> (-0xBEEF) and points to the unused hole in the virtual memory map. That blocks
> the stack spraying needed for CVE-2017-17712 exploit (similar to CVE-2010-2963).

Nice check! I wonder if the the byref structleak also solves it?
Regardless, I think stackleak has better performance and greater
coverage.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
