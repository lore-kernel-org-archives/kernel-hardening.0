MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAJcbSZEd10fMp6OSgSYv_Wmt=wX5fw_Gu-_N=fM_QmP==wUMew@mail.gmail.com>
References: <20170814213732.104301-1-thgarnie@google.com> <20170814213732.104301-3-thgarnie@google.com>
 <CAJcbSZG1b7ObJAv6Kmp-fR3vZRg7AdbcgqDceGB95r-72Yv0yg@mail.gmail.com> <CAJcbSZEd10fMp6OSgSYv_Wmt=wX5fw_Gu-_N=fM_QmP==wUMew@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 29 Aug 2017 12:54:43 -0700
Message-ID: <CAGXu5jKuk9589qap=74kPtefm=xKY0ORDH37W_3iZPd_7yc8VQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 3/4] arm/syscalls: Optimize address limit check
To: Thomas Gleixner <tglx@linutronix.de>, Thomas Garnier <thgarnie@google.com>, Russell King <linux@armlinux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Yonghong Song <yhs@fb.com>, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 29, 2017 at 7:32 AM, Thomas Garnier <thgarnie@google.com> wrote:
> On Tue, Aug 22, 2017 at 9:42 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> On Mon, Aug 14, 2017 at 2:37 PM, Thomas Garnier <thgarnie@google.com> wrote:
>>> Disable the generic address limit check in favor of an architecture
>>> specific optimized implementation. The generic implementation using
>>> pending work flags did not work well with ARM and alignment faults.
>>>
>>> The address limit is checked on each syscall return path to user-mode
>>> path as well as the irq user-mode return function. If the address limit
>>> was changed, a function is called to report data corruption (stopping
>>> the kernel or process based on configuration).
>>>
>>> The address limit check has to be done before any pending work because
>>> they can reset the address limit and the process is killed using a
>>> SIGKILL signal. For example the lkdtm address limit check does not work
>>> because the signal to kill the process will reset the user-mode address
>>> limit.
>>>
>>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>>
>> Any feedback?
>
> CCing LW@karo-electronics.de who experienced the same issue this patch
> proposal fix.
>
> Russell: Any feedback?

These implement Russell's suggestion. An Ack here would be nice. :) I
can't throw these into the ARM patch tracker because they depend on
stuff in -next (and the commit that needs to be reverted is in tglx's
tree).

Regardless, these all test out correctly for me, so:

Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>

In a perfect world, these 4 patches should go together with the other
address limit check patches in tglx's tree. Thomas (Gleixner), can you
update your tree for the merge window? At the very least, we need to
revert 73ac5d6a2b6ac ("arm/syscalls: Check address limit on user-mode
return"), which has caused infinite loops in some cases. Better to
take all 4 patches in this series, though.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
