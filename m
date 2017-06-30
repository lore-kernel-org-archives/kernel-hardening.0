MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAKv+Gu-EWyfB3zbPwT9=bLwR0GDtg5mwKaD0p5AbssjbxU7sMA@mail.gmail.com>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-5-git-send-email-keescook@chromium.org> <CAK8P3a0beV+ZUUKxzufXtZRszbXvgC3eQO4Rc1+ZYo_nAmcaaA@mail.gmail.com>
 <CAGXu5jJHRC83YSDKVfm4_41k0wgqfG=wpqPQss-ce77SRNkwRA@mail.gmail.com>
 <CAK8P3a0HeP0ekoZCu9+d-4y0dUz2=-Nn53=fTHPKSJao2NMU5Q@mail.gmail.com> <CAKv+Gu-EWyfB3zbPwT9=bLwR0GDtg5mwKaD0p5AbssjbxU7sMA@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 30 Jun 2017 10:27:06 +0200
Message-ID: <CAK8P3a076DEDpzRgTRBNLWan-KZyD0LkauWpuO8RFCf-9i1mhA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 04/20] gcc-plugins: Add the randstruct plugin
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 30, 2017 at 9:55 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 30 June 2017 at 07:35, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Jun 30, 2017 at 12:53 AM, Kees Cook <keescook@chromium.org> wrote:
>>> The first obviously won't fly. The second just bypasses the problem
>>> forcing it to be exposed by other people later. The third is likely
>>> easiest to do now, but reduces the effectiveness of randomization for
>>> architectures that don't have sensitive immediate values. The fourth
>>> sounds not generally useful. The fifth may be unacceptable to arm
>>> maintainers due to performance impacts.
>>
>> I was thinking of the fifth solution, but don't know exactly how to
>> do it. If performance is a concern, I guess we could have separate
>> implementations for randstruct and traditional builds.
>>
>
> Does this not apply to *all* entries in asm-offsets? If so, I don't
> see how it is tractable to fix this in the code, unless we add some
> instrumentation to asm-offsets to whitelist some huge structs and
> error out on new ones. Or perhaps there's really only a handful?

I think the other structs are all small enough:

* thread_info is at most 720 bytes (including crunch+vfp3, which
  you wouldn't find in one combined kernel) and not randomized
  at the moment
* pt_regs is 72 bytes and I don't see how that would be randomized
* machine_desc would be a candidate for randomizing, but is only
  108 bytes
* proc_info_list is 52 bytes and not currently randomized
* vm_area_struct is randomized but only 96 bytes.
* task_struct is clearly large enough, but we only use TSK_ACTIVE_MM
  and TSK_STACK_CANARY, both can be fixed with your trick.

> In any case, these particular examples are fairly straightforward,
> since there is no need to preserve the register's value.
>
> ldr     r7, [r7, #TSK_STACK_CANARY]
>
> could be replaced with
>
> .if TSK_STACK_CANARAY >= PAGE_SIZE
> add r7, r7, #TSK_STACK_CANARY & PAGE_MASK
> .endif
> ldr r7, [r7, #TSK_STACK_CANARY & ~PAGE_MASK]

Nice!

      Arnd
