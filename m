Subject: Re: [PATCH RFC v8 0/6] Introduce the STACKLEAK feature and a test for
 it
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
 <791341f5-4347-ba38-0710-93551a45ec38@linux.com>
 <CAGXu5jJ+dWjtjJ88ziOoyTJnSxbjdvEJd5LGY9nxWxHpVR6pug@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <dc76a745-3fa7-4023-dcc1-3df18c9461a6@redhat.com>
Date: Tue, 20 Feb 2018 15:33:49 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJ+dWjtjJ88ziOoyTJnSxbjdvEJd5LGY9nxWxHpVR6pug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>, Mohamed Ghannam <simo.ghannam@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/20/2018 03:17 PM, Kees Cook wrote:
> On Tue, Feb 20, 2018 at 2:29 AM, Alexander Popov <alex.popov@linux.com> wrote:
>> On 16.02.2018 21:10, Alexander Popov wrote:
>>> This is the 8th version of the patch series introducing STACKLEAK to the
>>> mainline kernel. I've made some minor improvements while waiting for the
>>> next review by x86 maintainers.
> 
> If we can borrow some of luto or tglx's time, I think that'd be best:
> they've been looking at the entry code a lot lately. :) Regardless, I
> think the addition to the entry code is clean (especially now that the
> fast path is gone *sob*). :P
> 
>>> STACKLEAK is a security feature developed by Grsecurity/PaX (kudos to them),
>>> which:
>>>   - reduces the information that can be revealed through kernel stack leak bugs;
>>>   - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>>>   - introduces some runtime checks for kernel stack overflow detection.
> 
> I've added this series to my kernel.org trees, which means 0-day will
> start grinding on it too now:
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git
> kspp/gcc-plugin/stackleak
> 
> The LKDTM tests look great and check out for me. I think the code is
> clear, so I'd like to get it into -next, but I want to be sure I'm not
> stepping on x86 toes first.
> 
> Laura, how does arm64 look for this? Would it be possible to add it to
> this series (at least on kernel.org for build/run testing)?
> 

I fell behind on rebasing/testing so I need to bring it up to date.
Assuming the arm folks are okay with the approach, we can bring it
in for kernel.org testing once I'm finished.

Thanks,
Laura
