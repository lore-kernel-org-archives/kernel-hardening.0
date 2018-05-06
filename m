Date: Sun, 6 May 2018 12:04:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 2/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
In-Reply-To: <CAGXu5jJ1rPmb_fs=iN5x6fTMtew8+jxrb=VxQQwiPLYzjxE07g@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1805061204060.1685@nanos.tec.linutronix.de>
References: <1523024546-6150-1-git-send-email-alex.popov@linux.com> <1523024546-6150-3-git-send-email-alex.popov@linux.com> <4e668302-8754-3f4e-3372-d0d7ba30cfa3@linux.intel.com> <CAGXu5jJ_0e63QSv0YZsQoT_=zN8U-83nwxrQ10h=QjszbHK-aQ@mail.gmail.com>
 <alpine.DEB.2.21.1805021041260.1668@nanos.tec.linutronix.de> <CAGXu5j+4Rj3oOH_iHhfD9sMMa2hRVm_dp9oA6YKhN9omhjdtEg@mail.gmail.com> <alpine.DEB.2.21.1805021438470.1560@nanos.tec.linutronix.de> <CAGXu5jJDwLfg0LPYkYKZcgqwbej-xVUB+6rSaLE+OvKQxy-Y9w@mail.gmail.com>
 <CAGXu5jJ1rPmb_fs=iN5x6fTMtew8+jxrb=VxQQwiPLYzjxE07g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2 May 2018, Kees Cook wrote:
> On Wed, May 2, 2018 at 5:51 AM, Kees Cook <keescook@chromium.org> wrote:
> I think it'd be better for this to go via my tree with your Ack (where
> I can carry the plugin, lkdtm, x86, and arm64 changes). How does that
> sound?

Works for me.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
