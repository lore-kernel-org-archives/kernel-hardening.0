MIME-Version: 1.0
References: <cover.1560198181.git.luto@kernel.org> <131caabf9d127db1a077525f978e1f1f74f9088f.1560198181.git.luto@kernel.org>
 <201906101342.B8A938BB@keescook>
In-Reply-To: <201906101342.B8A938BB@keescook>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 13 Jun 2019 12:08:38 -0700
Message-ID: <CALCETrXJA2ws=M_RBge1+nVGkDR0qX-jdFypYxuE3yDiikt46w@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86/vsyscall: Add a new vsyscall=xonly mode
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 10, 2019 at 1:43 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jun 10, 2019 at 01:25:28PM -0700, Andy Lutomirski wrote:
> > With vsyscall emulation on, we still expose a readable vsyscall page
> > that contains syscall instructions that validly implement the
> > vsyscalls.  We need this because certain dynamic binary
> > instrumentation tools attempt to read the call targets of call
> > instructions in the instrumented code.  If the instrumented code
> > uses vsyscalls, then the vsyscal page needs to contain readable
> > code.
> >
> > Unfortunately, leaving readable memory at a deterministic address
> > can be used to help various ASLR bypasses, so we gain some hardening
> > value if we disallow vsyscall reads.
> >
> > Given how rarely the vsyscall page needs to be readable, add a
> > mechanism to make the vsyscall page be execute only.
>
> Should the commit log mention that the VVAR portion goes away under
> xonly? (Since it's not executable.)

No, because vsyscall VVAR is long gone no matter what.  Even the old
vsyscall=native didn't have it.
