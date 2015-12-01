Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 1 Dec 2015 08:24:03 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151201072403.GA28270@gmail.com>
References: <1448494286-16029-1-git-send-email-keescook@chromium.org>
 <1448494286-16029-2-git-send-email-keescook@chromium.org>
 <20151126075130.GB18742@gmail.com>
 <CAGXu5j+Mom2oYbsSE65BMCAgio68J6ST4wODUf8-qHdxOe0jOQ@mail.gmail.com>
 <20151130222437.GT8644@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151130222437.GT8644@n2100.arm.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2 1/4] init: create cmdline param to disable readonly
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Catalin Marinas <catalin.marinas@arm.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Nov 30, 2015 at 01:52:10PM -0800, Kees Cook wrote:
> > On Wed, Nov 25, 2015 at 11:51 PM, Ingo Molnar <mingo@kernel.org> wrote:
> > > * Kees Cook <keescook@chromium.org> wrote:
> > >> +#ifdef CONFIG_DEBUG_RODATA
> > >
> > > Btw., could you please remove the Kconfig option altogether in an additional patch
> > > and make read-only sections an always-on feature? It has been default-y for years
> > > and all distros have it enabled.
> > 
> > Yeah, this is something I've wanted to do for a while, but I would
> > point out that only a few architectures have actually implemented it,
> > and for arm and arm64 it was very recent:
> 
> I don't think it can entirely be a kernel command line option.  On ARM,
> enabling DEBUG_RODATA has a substantial effect on the size of the kernel
> image - we have to pad various sections to 1MB boundaries so we can
> set the appropriate permissions.
> 
> Forcing this layout on everyone won't work.

Yeah, so I'd suggest to have it always-on on x86 (after adding the boot option), 
to simplify the x86 code and to make it more obvious that we rely on this.

There's a moderate amount of #ifdeffery around this:

  triton:~/tip> git grep -w CONFIG_DEBUG_RODATA arch/x86/  | grep \# | wc -l
  15

Thanks,

	Ingo
