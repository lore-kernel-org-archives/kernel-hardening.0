Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 27 Nov 2015 08:59:59 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151127075959.GA24991@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
 <565595F5.32536.DB9FE75@pageexec.freemail.hu>
 <20151126085425.GA29848@gmail.com>
 <CALCETrXrvAY+mXx+JULw7W+xokcSPFgWm5-McJf9EKhYehPhbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXrvAY+mXx+JULw7W+xokcSPFgWm5-McJf9EKhYehPhbA@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: Andy Lutomirski <luto@amacapital.net>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@amacapital.net> wrote:

> > Can you see any fragility in such a technique?
> 
> After Linus shot down my rdmsr/rwmsr decoding patch, good luck...

I think that case was entirely different, but I've Cc:-ed Linus to shoot my idea 
down if it's crap.

> More seriously, though, I think this is mostly just like any other in-kernel 
> fault.  We failed, me might be under attack, let's oops.  In the particular case 
> of suspend/resume, we could consider a debug flag to allow writes to these 
> variables during suspend/resume.  In fact, that might even be a reasonable 
> default.  We might want to allow writes during module unload as well.

We are getting the _same_ information: we generate a reliable stack trace right 
there. We don't ignore anything.

What my suggestion would do is to turn a 'sure system crasher' into a 
'informational debug message'.

On today's typical desktop systems I can tell you with 110% confidence that the 
vast majority of 'system crasher' oopses never reaches a kernel developer's 
attention, because the oops message is not propagated to the user, while the 'dump 
stack trace and try to continue' approach will result in proper bugzillas.

And that's really an important distinction IMHO. Getting debug info out of the 
system is very important - and those who are paranoid can set a Kconfig value to 
crash their systems on any hint of a problem.

> For everything else, we should probably focus more on getting OOPSes to display 
> reliably, which is supposed to work but, on my shiny new i915-based laptop, is 
> clearly not ready yet (I oopsed it yesterday due to my own bug and all I had to 
> show for it was a blinking capslock key, and yes, modesetting works).

That's absolutely true as well but an independent issue: it does not invalidate my 
argument that is based on the status quo, which is that the vast majority 
panics/oopses, _especially_ during suspend/resume that was mentioned in this case, 
does not reach any kernel developer.

Thanks,

	Ingo
