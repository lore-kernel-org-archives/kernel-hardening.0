MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrXaARjGa+fCmxDDYNQCgv0ZSm+DaUFoXFmRxU9J245HxQ@mail.gmail.com>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
 <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
 <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
 <CA+55aFwUn7+WiHxL7PBWxNrGB0--HETqUjdRwxi+DkMvCP_CaA@mail.gmail.com>
 <CALCETrV1JHK1ovjjD1vbs08K1an6tq6nbRoAj9uyrY2GUYJJBA@mail.gmail.com>
 <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
 <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com>
 <b8ea504729db4073abf82ebd5d8a53c6@AcuMS.aculab.com> <1516976647.5438.6.camel@linux.intel.com>
 <CALCETrXaARjGa+fCmxDDYNQCgv0ZSm+DaUFoXFmRxU9J245HxQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2018 09:40:23 -0800
Message-ID: <CA+55aFzr_tvdjsq1B+N1zrprNe-qfwo0At+r8uKiS=BGN_92vQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Andy Lutomirski <luto@kernel.org>
Cc: Alan Cox <alan@linux.intel.com>, David Laight <David.Laight@aculab.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 26, 2018 at 7:57 AM, Andy Lutomirski <luto@kernel.org> wrote:
>
> I gave the rearrangement like this a try yesterday and it's a bit of a
> mess.  Part of the problem is that there are a bunch of pieces of code
> that expect sys_xyz() to be actual callable functions.

That's not supposed to be a mess.

That's part of why we do that whole indirection through SYSC##xyz to
sys##_xyz: the asm-callable ones will do the full casting of
troublesome arguments (some architectures have C calling sequence
rules that have security issues, so we need to make sure that the
arguments actually follow the right rules and 'int' arguments are
properly sign-extended etc).

So that whole indirection could be made to *also* create another
version of the syscall that instead took the arguments from ptregs.

We already do exactly that for the tracing events: look how
FTRACE_SYSCALLS ends up creating that extra metadata.

The ptreg version should be done the same way: don't make 'sys_xyz()'
take a struct ptregs, instead make those SYSCALL_DEFINE*() macros
create a _new_ function called 'ptregs_xyz()' and then that function
does the argument unpacking.

Then the x86 system call table can just be switched over to call those
ptreg versions instead.

                    Linus
