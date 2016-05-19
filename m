Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1463638931.10451.10.camel@ellerman.id.au>
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Thu, 19 May 2016 16:22:11 +1000
In-Reply-To: <20160518123327.9018f73af78a47b4456b2027@gmail.com>
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
	 <20160513015725.30223ee16a2a3860b4392b90@gmail.com>
	 <573C2CFE.8060305@au1.ibm.com>
	 <20160518123327.9018f73af78a47b4456b2027@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v8 2/4] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2016-05-18 at 12:33 +0200, Emese Revfy wrote:

> > I've done some basic sanity testing on powerpc with the cyclomatic 
> > complexity plugin (with LE native + cross-compilers) and it seems to 
> > work with the patch below.
> > 
> > Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
> > 
> > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> > index a18a0dc..0cfed5b 100644
> > --- a/arch/powerpc/Kconfig
> > +++ b/arch/powerpc/Kconfig
> > @@ -97,6 +97,7 @@ config PPC
> >          select HAVE_DYNAMIC_FTRACE_WITH_REGS if MPROFILE_KERNEL
> >          select HAVE_FUNCTION_TRACER
> >          select HAVE_FUNCTION_GRAPH_TRACER
> > +       select HAVE_GCC_PLUGINS
> >          select SYSCTL_EXCEPTION_TRACE
> >          select ARCH_WANT_OPTIONAL_GPIOLIB
> >          select VIRT_TO_BUS if !PPC64
> 
> Hi,
> 
> Did you test the plugins with all gcc versions (4.5-6)?

What's the concern about gcc versions? Just not breaking the build on old
compilers?

I'm pretty sure powerpc big endian still builds with gcc 4.4.

However if Andrew's only tested on little endian, then that select should be
guarded with an "if CPU_LITTLE_ENDIAN". And to build LE you need gcc >= 4.9.

cheers
