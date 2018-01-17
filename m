References: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jKmOn7E04Y8pR9Tgn7usJYMhqWe9x929ZwEnu21MG=mZw@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <0c1950e9-626d-c7b8-5551-fcc233501025@linux.com>
Date: Wed, 17 Jan 2018 14:37:17 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKmOn7E04Y8pR9Tgn7usJYMhqWe9x929ZwEnu21MG=mZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v7 0/6] Introduce the STACKLEAK feature and a test for
 it
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Kees,

Thanks for the review.

On 15.01.2018 22:59, Kees Cook wrote:
> On Fri, Jan 12, 2018 at 6:19 AM, Alexander Popov <alex.popov@linux.com> wrote:
>> This is the 7th version of the patch series introducing STACKLEAK to the
>> mainline kernel. STACKLEAK is a security feature developed by Grsecurity/PaX
>> (kudos to them), which:
>>  - reduces the information that can be revealed through kernel stack leak bugs;
>>  - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>>  - introduces some runtime checks for kernel stack overflow detection.
> 
> I think this is really looking good. I had some thoughts while reading
> through the patches:
> 
> There are really three features in this series, and it might make
> sense to separate them a bit more clearly (at least with CONFIG
> choices):
> 
> 1) stack clearing (with depth searching)
> 
> 2) runtime stack depth tracking (making 1 much more efficient)
> 
> 3) alloca checking (an additional feature, not strictly part of
> clearing, but needs the same plugin infrastructure)
> 
> It seems like it should be possible to get 1 without 2 and 3 (both of
> which happen in the gcc plugin), and might be good to separate for
> builds that don't have gcc plugins.
> 
> Once compilers are doing alloca checking (or all VLAs are removed from
> the kernel), it'd be nice to be able to avoid the redundancy of 3.

Agree with your point. I'll make this separation in the next version.

Moreover, I'll create separate tests for these 3 features. Currently
lkdtm_stackleak combines the stack clearing check with the alloca test and the
deep recursion test.

> Thanks for continuing to work on this!

Doing my best!

Hope that x86 maintainers will have a look at this patch series too (when they
are less busy).

Best regards,
Alexander
