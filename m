Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 16 Jul 2018 00:44:46 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v14 0/6] Introduce the STACKLEAK feature and a test for it
Message-ID: <20180715224446.GA29087@gmail.com>
References: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
 <CA+55aFyeZGaC7DSYT6oKuC+Pdpx1Jd95wC97XFdZdNPqD325RA@mail.gmail.com>
 <20180712135944.GB6199@gmail.com>
 <CAGXu5jJQ2EWKsEWcDf3WWv94kYDcubCSVHA_YhG0HKG+XbahFQ@mail.gmail.com>
 <20180712205016.GA20649@gmail.com>
 <50c690fc-c967-8376-8524-ac9c1be722bc@linux.com>
 <CAGXu5j+Vc3U6C3UO1CVYN+EmguJdoPCuatOJ2vpAx=r1jbmwjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Vc3U6C3UO1CVYN+EmguJdoPCuatOJ2vpAx=r1jbmwjQ@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Pax Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andrew Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V. Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nick Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>, dingtianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> On Thu, Jul 12, 2018 at 2:22 PM, Alexander Popov <alex.popov@linux.com> wrote:
> > On 12.07.2018 23:50, Ingo Molnar wrote:
> >> Let's make sure informed users have an easy runtime way out
> >> from the worst of the overhead that doesn't involve "recompile your distro
> >> kernel". Also, make it easier to measure and fingerpoint the overhead...
> >
> > Would you like the following solution?
> >
> > I'll create the CONFIG_STACKLEAK_RUNTIME_DISABLE config option, which would be
> > similar to CONFIG_SECURITY_SELINUX_DISABLE. That option will provide a sysctl
> > switch disabling stackleak_erase(), which provides the most of performance penalty.
> 
> I don't think CONFIG/sysctl is the way to go. I'd recommend making it
> a boot arg and using a static key, similar to what's happening to
> hardened_usercopy:

Why no sysctl? It's a PITA to reboot systems just to turn a stupid knob off.

Also, it's _much_ easier to measure performance impact when there's a sysctl.

Thanks,

	Ingo
