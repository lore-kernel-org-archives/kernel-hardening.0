Date: Fri, 12 Oct 2018 01:15:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
In-Reply-To: <CAG48ez0P7dq+j7gy0dbbS8aLOPC-M3rsbNPuHwXHAMh_bfSQgw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1810120113450.1457@nanos.tec.linutronix.de>
References: <20181011185458.10186-1-kristen@linux.intel.com> <CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com> <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com>
 <CAG48ez0P7dq+j7gy0dbbS8aLOPC-M3rsbNPuHwXHAMh_bfSQgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, kristen@linux.intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 11 Oct 2018, Jann Horn wrote:
> On Thu, Oct 11, 2018 at 10:56 PM Kees Cook <keescook@chromium.org> wrote:
> > Seems like just changing this with "ax == 0" into "ax >= 0" would solve that?
> 
> As spender points out on twitter
> (https://twitter.com/grsecurity/status/1050497259937370118 - thanks,
> spender!), struct pt_regs stores register values as "unsigned long",
> and so you'll need to use something like IS_ERR_VALUE().

Ha, so it's not only me who noticed, but then I'm not reading twitter...

Thanks,

	tglx
