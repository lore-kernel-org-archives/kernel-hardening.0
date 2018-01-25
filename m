MIME-Version: 1.0
In-Reply-To: <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
 <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
 <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
 <CA+55aFwUn7+WiHxL7PBWxNrGB0--HETqUjdRwxi+DkMvCP_CaA@mail.gmail.com>
 <CALCETrV1JHK1ovjjD1vbs08K1an6tq6nbRoAj9uyrY2GUYJJBA@mail.gmail.com> <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 25 Jan 2018 13:31:11 -0800
Message-ID: <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 25, 2018 at 1:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 25, 2018 at 1:08 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>
>> With retpoline, the retpoline in the trampoline sucks.  I don't need
>> perf for that -- I've benchmarked it both ways.  It sucks.  I'll fix
>> it, but it'll be kind of complicated.
>
> Ahh, I'd forgotten about that (and obviously didn't see it in the profiles).
>
> But yeah, that is fixable even if it does require a page per CPU. Or
> did you have some clever scheme in mind?

Nothing clever.  I was going to see if I could get actual
binutils-generated relocations to work in the trampoline.  We already
have code to parse ELF relocations and turn them into a simple table,
and it shouldn't be *that* hard to run a separate pass on the entry
trampoline.

Another potentially useful if rather minor optimization would be to
rejigger the SYSCALL_DEFINE macros a bit.  Currently we treat all
syscalls like this:

long func(long arg0, long arg1, long arg2, long arg3, long arg4, long arg5);

I wonder if we'd be better off doing:

long func(const struct pt_regs *regs);

and autogenerating:

static long SyS_read(const struct pt_regs *regs)
{
   return sys_reg(regs->di, ...);
}
