Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 5 Jul 2018 12:35:33 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v13 (resend) 2/6] x86/entry: Add STACKLEAK erasing the
 kernel stack at the end of syscalls
Message-ID: <20180705103533.GA16913@gmail.com>
References: <1529686717-16017-1-git-send-email-alex.popov@linux.com>
 <1529686717-16017-3-git-send-email-alex.popov@linux.com>
 <20180705081236.GB20903@gmail.com>
 <20180705100003.GL2458@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180705100003.GL2458@hirez.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jul 05, 2018 at 10:12:37AM +0200, Ingo Molnar wrote:
> > * Alexander Popov <alex.popov@linux.com> wrote:
> > > +static inline void stackleak_task_init(struct task_struct *task)
> > > +{
> > > +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> > > +	task->lowest_stack = (unsigned long)end_of_stack(task) +
> > > +						sizeof(unsigned long);
> > > +#endif
> > 
> > Please don't break the line in such an ugly fashion - just keep the line long and 
> > ignore checkpatch, because the cure is worse than the disease.
> 
> FWIW I don't totally hate on:
> 
> 	task->lowest_stack =
> 		(unsigned long)end_of_stack(task) + sizeof(unsigned long);
> 
> which is a much more readable split.

Yeah, or rename 'task' to the regular 't' or 'p' and do:

	t->lowest_stack = (long)end_of_stack(t) + sizeof(long);

;-)

	Ingo
