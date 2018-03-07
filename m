Date: Wed, 7 Mar 2018 20:31:10 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] x86/vsyscall/64: Drop "native" vsyscalls
Message-ID: <20180307193110.GA3307@isilmar-4.linta.de>
References: <519fee5268faea09ae550776ce969fa6e88668b0.1520449896.git.luto@kernel.org>
 <CAGXu5jKOQPNuXR5At7984FSMHHrT7G6z7Tx5SdfP+62WON7JNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKOQPNuXR5At7984FSMHHrT7G6z7Tx5SdfP+62WON7JNA@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 07, 2018 at 11:21:46AM -0800, Kees Cook wrote:
> On Wed, Mar 7, 2018 at 11:12 AM, Andy Lutomirski <luto@kernel.org> wrote:
> > Since Linux 3.2, vsyscalls have been deprecated and slow.  From 3.2
> > on, Linux had three vsyscall modes: "native", "emulate", and "none".
> >
> > "emulate" is the default.  All known user programs work correctly in
> > emulate mode, but vsyscalls turn into page faults and are emulated.
> > This is very slow.  In "native" mode, the vsyscall page is easily
> > usable as an exploit gadget, but vsyscalls are a bit faster -- they
> > turn into normal syscalls.  (This is in contrast to vDSO functions,
> > which can be much faster than syscalls.)  In "none" mode, there are
> > no vsyscalls.
> >
> > For all practical purposes, "native" was really just a chicken bit
> > in case something went wrong with the emulation.  It's been over six
> > years, and nothing has gone wrong.  Delete it.
> >
> > Signed-off-by: Andy Lutomirski <luto@kernel.org>
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> I related news, I wonder how long before we can switch from EMULATE to
> NONE as the default? glibc 2.15 (which stopped using vsyscall) is (not
> coincidentally) 6 years old too...

Or, in the meantime, add a warning

        if (vsyscall_mode == EMULATE) {
                warn_bad_vsyscall(KERN_INFO, regs,
                                  "vsyscalls are deprecated -- use vDSO instead");
        }

Otherwise, the patch looks good.

Thanks,
	Dominik
