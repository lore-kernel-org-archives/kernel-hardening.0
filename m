Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 22 Jun 2018 03:33:40 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v13 0/6] Introduce the STACKLEAK feature and a test for it
Message-ID: <20180622013339.GA10129@gmail.com>
References: <1527365430-8303-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jJ9F-eZW5qVGebsv=wUh0kSm+edAecpztgvMC3fGeYXXA@mail.gmail.com>
 <CAGXu5jLU4En5Cf6KGf0Adpky-TF7aa=d9MTDqDKwxQuxZSLNEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLU4En5Cf6KGf0Adpky-TF7aa=d9MTDqDKwxQuxZSLNEg@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> On Sun, May 27, 2018 at 7:57 AM, Kees Cook <keescook@chromium.org> wrote:
> > On Sat, May 26, 2018 at 1:10 PM, Alexander Popov <alex.popov@linux.com> wrote:
> >> This is the 13th version of the patch series introducing STACKLEAK to the
> >> mainline kernel for x86. This version comes with style changes according to
> >> the feedback from Ingo Molnar. Previous version discussion:
> >> http://www.openwall.com/lists/kernel-hardening/2018/05/16/1
> >
> > Thanks for the update! I've pushed it to my tree for 0-day testing:
> > https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/gcc-plugin/stackleak-v13
> 
> 0-day has been happy with this tree, and with Ingo's freedback
> addressed, I'd like to push this to -next after -rc2 is released (in
> theory this coming Sunday). It needed some rebasing to -rc1, but it
> was all trivial stuff in Kconfg and Makefile from the kbuild tree's
> changes.
> 
> Ingo, how do things look to you now?

don't know:

 triton:~/tip> git fetch "https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/gcc-plugin/stackleak-v13"
 fatal: repository 'https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/gcc-plugin/stackleak-v13/' not found

How many patches are in there, and how clean is the series? I.e. it would be nice 
to have another submission (assuming it's a clean series with not too many 
patches).

Thanks,

	Ingo
