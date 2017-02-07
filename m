Date: Tue, 7 Feb 2017 16:07:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170207150737.GM25813@worktop.programming.kicks-ass.net>
References: <1486164412-7338-1-git-send-email-keescook@chromium.org>
 <1486164412-7338-5-git-send-email-keescook@chromium.org>
 <20170205154046.GF6515@twins.programming.kicks-ass.net>
 <CAGXu5jLvpq6B80aN44JCOfHrov5LKX1_9r4aWb7LNM7pAW_SEQ@mail.gmail.com>
 <20170206085739.GH6515@twins.programming.kicks-ass.net>
 <CAGXu5j+VrKBrU7op8wD1Ry4nzR0cN7Vvke8W6_KOzp3wsoEF1g@mail.gmail.com>
 <20170207083405.GV6500@twins.programming.kicks-ass.net>
 <20170207111011.GB28790@leverpostej>
 <20170207123630.GR6515@twins.programming.kicks-ass.net>
 <20170207135020.GA26173@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207135020.GA26173@leverpostej>
Subject: Re: [kernel-hardening] Re: [PATCH 4/4] refcount: Report failures
 through CHECK_DATA_CORRUPTION
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 07, 2017 at 01:50:20PM +0000, Mark Rutland wrote:
> > Right something along those lines. (a) will need GCC help, and (b) would
> > be kernel-arch specific. So this isn't something we can quickly do.
> 
> I agree this isn't something that can be hacked together quickly, and
> certainly shouldn't block these patches.
> 
> However, I don't think we need anything new from GCC, and I think we
> already have a generic API for (b).
> 
> For (a) we don't need new GCC help if we do something like we did in
> commit 72c5839515260dce to do the mangling. Prepend a prefix to the
> register, e.g. changing 'x0' to '__pt_regs_offset_x0', which we arrange
> to hold the correct value.

I'm not sure I can decipher that commit and therefore have no idea if
something similar can be done for other architectures.
