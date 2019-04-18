MIME-Version: 1.0
References: <1462963502-11636-1-git-send-email-hecmargi@upv.es>
 <CAGXu5jLZ-DgTfokLTqUHOUphO4C1FwHgYDLTA1oB9HBHnH-a1Q@mail.gmail.com>
 <alpine.DEB.2.21.1904181015270.3174@nanos.tec.linutronix.de> <74755222-0B16-4A81-85F6-D2803E4C0334@amacapital.net>
In-Reply-To: <74755222-0B16-4A81-85F6-D2803E4C0334@amacapital.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 18 Apr 2019 09:29:33 -0500
Message-ID: <CAGXu5jJpyhN7H2K7a+AT_zWn+G55RkeP9umsBVhDy9KO9B_5eg@mail.gmail.com>
Subject: Re: [PATCH] x86_64: Disabling read-implies-exec when the stack is executable
Content-Type: text/plain; charset="UTF-8"
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Hector Marco-Gisbert <hecmargi@upv.es>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Brian Gerst <brgerst@gmail.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Huaitong Han <huaitong.han@intel.com>, Ismael Ripoll Ripoll <iripoll@upv.es>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jason Gunthorpe <jgg@mellanox.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 18, 2019 at 9:15 AM Andy Lutomirski <luto@amacapital.net> wrote:
> I have the opposite question: who cares if we have NX?  On a CPU without NX, read implies exec, full stop. Why should nasty personality stuff matter at all?  The personality stuff is about supporting old crufty binaries.
>
> So: are there old 64-bit binaries that have their stacks marked RX that expect mmap to automatically return X memory?  If so, then the patch is a problem. If not, then maybe the patch is okay.

That's what I'm wondering too. (Though remember that ia32 PAE has NX,
so it's also 32-bit binaries.) The matrix I have in my head is:

             CPU: |  lacks NX      |  has NX            |
ELF:              |                |                    |
--------------------------------------------------------|
missing GNU_STACK | doesn't matter | needs RIE          |
GNU_STACK == RWX  | doesn't matter | needs only stack X | *
GNU_STACK == RW   | doesn't matter | needs stack NX     |

(hopefully gmail doesn't mangle this whitespace)

The "*" line here is the question. The question is "when does
GNU_STACK == RWX also mean all mmaps must be X?" If it's only on ia32,
okay, fine we can adjust it, but why is it only an issue for ia32
toolchains? If it's a non-issue, then the above logic stands.

> All that being said, the comment in the patch seems to be highly misleading.  If the patch is to be applied, the comment needs serious work.

Yes, absolutely. (I'd include the chart above, for example...)

-- 
Kees Cook
