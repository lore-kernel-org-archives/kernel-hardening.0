Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 6 Sep 2011 09:05:54 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110906050554.GA3889@openwall.com>
References: <20110812102954.GA3496@albatros> <20110812105824.GA7141@openwall.com> <20110825171934.GA3044@albatros> <20110902182929.GA23848@openwall.com> <20110903111849.GA2743@albatros> <20110903235728.GD29169@openwall.com> <20110905124647.GA10247@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110905124647.GA10247@albatros>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 05, 2011 at 04:46:47PM +0400, Vasiliy Kulikov wrote:
> Hmm, yes, looks like I've lost the thread some time ago :(  A good
> description definitely needs much longer and scrupulous analysis.

Or alternatively it may choose not to go into detail at all, which is a
safer bet. ;-)

> Probably there is a public paper with a review/analysis/benefits of
> ASCII-armor that we're able to refer in the patch description?  I cannot
> find any rigorous paper, unfortunately.

I'm not aware of such paper.

> On Sun, Sep 04, 2011 at 03:57 +0400, Solar Designer wrote:
> > solar@host:~/kernel/mainline/linux-3.0.4 $ fgrep -rl CONFIG_VM86 .
> > ./arch/x86/kernel/Makefile
> > ./arch/x86/kernel/entry_32.S
> > ./arch/x86/include/asm/vm86.h
> > ./arch/x86/include/asm/processor-flags.h
> > 
> > Looks like there's no Kconfig option for this - perhaps add it with a
> > separate patch?
> 
> Since 2.6.x CONFIG_ prefix is not used in Kconfig files:
> 
> $ grep -w VM86 arch/x86/Kconfig
> config VM86
>     bool "Enable VM86 support" if EXPERT

Oh, of course.  Sometimes I say/do dumb things.

Turns out this stuff is also present in RHEL5/OpenVZ kernels, so we
might want to turn on CONFIG_EMBEDDED and disable CONFIG_VM86 in Owl
kernel builds, even before we move to newer kernels.

Alexander
