Date: Mon, 5 Mar 2018 21:25:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC v9 2/7] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
Message-ID: <20180305202535.GX25201@hirez.programming.kicks-ass.net>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-3-git-send-email-alex.popov@linux.com>
 <d968e58a-3abd-8e3c-cee3-00c19c1b6430@linux.intel.com>
 <94f268b2-31a4-620a-86ed-325d5bb33c57@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94f268b2-31a4-620a-86ed-325d5bb33c57@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 05, 2018 at 11:43:19AM -0800, Laura Abbott wrote:
> On 03/05/2018 08:41 AM, Dave Hansen wrote:
> > On 03/03/2018 12:00 PM, Alexander Popov wrote:
> > >   Documentation/x86/x86_64/mm.txt  |   2 +
> > >   arch/Kconfig                     |  27 ++++++++++
> > >   arch/x86/Kconfig                 |   1 +
> > >   arch/x86/entry/entry_32.S        |  88 +++++++++++++++++++++++++++++++
> > >   arch/x86/entry/entry_64.S        | 108 +++++++++++++++++++++++++++++++++++++++
> > >   arch/x86/entry/entry_64_compat.S |  11 ++++
> > 
> > This is a *lot* of assembly.  I wonder if you tried at all to get more
> > of this into C or whether you just inherited the assembly from the
> > original code?
> > 
> 
> This came up previously http://www.openwall.com/lists/kernel-hardening/2017/10/23/5
> there were concerns about trusting C to do the right thing as well as
> speed.

And therefore the answer to this obvious question should've been part of
the Changelog :-)

Dave is last in a long line of people asking this same question.
