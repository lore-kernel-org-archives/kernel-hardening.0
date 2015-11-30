Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 30 Nov 2015 09:01:03 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151130080103.GA30586@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <565876F3.21515.18F8DF8F@pageexec.freemail.hu>
 <20151129080853.GB23721@gmail.com>
 <565ADE35.20892.225C67C2@pageexec.freemail.hu>
 <20151129153918.GA12215@gmail.com>
 <CA+rthh_vXtYqvgcLJm=Xq8BniKMbffQrJJ8Gt_BWoAKbow8_Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh_vXtYqvgcLJm=Xq8BniKMbffQrJJ8Gt_BWoAKbow8_Ow@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: Mathias Krause <minipli@googlemail.com>
Cc: PaX Team <pageexec@freemail.hu>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Mathias Krause <minipli@googlemail.com> wrote:

> On 29 November 2015 at 16:39, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * PaX Team <pageexec@freemail.hu> wrote:
> >
> >> On 29 Nov 2015 at 9:08, Ingo Molnar wrote:
> >>
> >> >
> >> > * PaX Team <pageexec@freemail.hu> wrote:
> >> >
> >> > > i don't see the compile time vs. runtime detection as 'competing' approaches,
> >> > > both have their own role. [...]
> >> >
> >> > That's true - but only as long as 'this can be solved in tooling!' is not used as
> >> > an excuse to oppose the runtime solution and we end up doing neither.
> >>
> >> actually, i already voiced my opinion elsewhere in the constify thread on the
> >> kernel hardening list that adding/using __read_only is somewhat premature
> >> without also adding the compile time verification part (as part of the constify
> >> plugin for example). right now its use on the embedded vdso image is simple and
> >> easy to verify but once people begin to add it to variables that the compiler
> >> knows and cares about (say, the ops structures) then things can become fragile
> >> without compile checking. so yes, i'd also advise to get such tooling in
> >> *before* more __read_only usage is added.
> >
> > I think you are mistaken there: if we add the page fault fixup to make sure we
> > don't crash if a read-only variable is accessed, then we'll have most of the
> > benefits of read-only mappings and no fragility - without having to wait for
> > tooling.
> 
> I guess the point PaX Team (and me earlier in this thread) wanted to
> make is that having misuse detection *only* at run-time will make
> those kind of bugs visible too late -- as late as on the wrong write
> attempt actually happening. It would be much better to have the
> compiler complain about invalid write statements already during
> compilation, much like it does when one wants to assign some value to
> a const object.

Well, the runtime warning comes "later", that does not automatically transform 
into "too late".

These things are relatively rare. Whether the warning is in tooling or runtime (or 
both) is relatively immaterial in that regard: having it in tooling would be nice, 
but it's not fool-proof either: say if tooling leaves an easy backdoor like 
allowing a type cast to supress warnings then it turns into a hard to debug 
problem again.

So I think we need both, starting with the runtime warning which is easy to 
implement and can be merged right away.

But reality is that upstream tooling changes, especially ones involving compiler 
changes move at a glacier's pace in comparison. Based on past experience I am also 
pretty pessimistic: I'm 90% certain that this 'tooling feature' won't be 
implemented in the next 10 years, so I'd like to concentrate on what we can do 
here and now: the runtime warning and recovery without crashing.

If anyone sends patches for that I'll apply them.

Thanks,

	Ingo
