Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <564EF64F.1060903@redhat.com>
References: <564EF64F.1060903@redhat.com>
Date: Tue, 24 Nov 2015 12:10:40 -0800
Message-ID: <CAGXu5jLK61OFfSXtEzisMkdt9CnVaa5Eiw6sUB0=w2DjzPjJ5A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] System call interface changes
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 20, 2015 at 2:30 AM, Florian Weimer <fweimer@redhat.com> wrote:
> Not sure if this in scope for this list.  If not, please say so.

Sure! I think it's certainly in scope for the list. I'm glad to see new ideas.

> Currently, the system call interface to user space expects the system
> call number in a register (on i386 and x86_64, and probably most other
> architectures).  This means that once you have a system call instruction
> in the process image, it can be theoretically used to run *any* system
> call, including ones that are not actually referenced in the binary.  As
> a result, you need seccomp or a Linux security module to interdict
> certain system calls.

Ah, are you looking at this as an anti-ROP idea? What's the bug class
or exploitation method you're looking at addressing?

> This would have to be an opt-in feature, obviously, and applications
> would have to opt in explicitly via some ELF flag (similar to what we
> did for non-executable stacks).

There have been a growing number of things that seem like they'd be
nice to control with ELF flags. Andy Lutomirski recently wanted to
make the x86-64 vsyscall presence be selectable on a per-process
basis. (I think it's easier to just turn it off entirely.)

> Do you think it would be feasible to encode the system call number in
> the instruction stream instead, next to the instruction?  I think this
> would have to set the system call MSR (LSTAR) on some context switches
> at least (to avoid a conditional branch in the system call handler,
> depending on whether the process has opted in to the new interface), and
> add a few instructions (two loads and an add, so that the system call
> number can be encoded in multiple ways, to avoid creating otherwise
> useful bit patterns).  On the other hand, it would avoid the need to
> load the sixth argument from the stack on i386.

I always come back to "how can we measure this?" If you've got an
exploit method you're trying to kill, etc, then it should be easy to
evaluate its utility.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
