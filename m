Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 12 Jul 2018 22:50:16 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v14 0/6] Introduce the STACKLEAK feature and a test for it
Message-ID: <20180712205016.GA20649@gmail.com>
References: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
 <CA+55aFyeZGaC7DSYT6oKuC+Pdpx1Jd95wC97XFdZdNPqD325RA@mail.gmail.com>
 <20180712135944.GB6199@gmail.com>
 <CAGXu5jJQ2EWKsEWcDf3WWv94kYDcubCSVHA_YhG0HKG+XbahFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJQ2EWKsEWcDf3WWv94kYDcubCSVHA_YhG0HKG+XbahFQ@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Pax Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andrew Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V. Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nick Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>, dingtianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> > So I agree that it's pretty stupid. Since 95%+ of our users just use what the 
> > distro configured - so at minimum I'd like to see a runtime patching based way 
> > for root to disable it, so that people (who care or who are hurt by it) can 
> > turn the check off - which should be the most expensive part causing much of 
> > the 1% overhead.
> >
> > Shouldn't be too hard to implement, this is just a checking method called for 
> > every system call that does nothing substantial in 99.99999% of the cases.
> 
> I'd like to not have this be required for initial inclusion.
>
> [...] Most people interested in this feature build their own kernels.

If no distro is going to enable this then why are we even pursuing this feature?

What I'm asking for is probably just a single trivial static key in the first 
iteration, patched to NOP by default ... Am I missing something?

I'm 90% certain that much of the kernel build time overhead will go away with 
flipping that switch.

> [...] Improving on this to make it available to all distros will be excellent, 
> and I think we can do it with static keys or alternatives (?). I'd prefer this 
> feature request not block the merge for 4.19, though. Would that be reasonable?

If no distro is pursuing this then there's no rush to merge this whatsoever: 
people who build their own kernels can apply patches or pull in trees just as 
well, right?

This whole feature is a pretty horrible idea that I can see distros enabling due 
to security theatre. Let's make sure informed users have an easy runtime way out 
from the worst of the overhead that doesn't involve "recompile your distro 
kernel". Also, make it easier to measure and fingerpoint the overhead...

Thanks,

	Ingo
