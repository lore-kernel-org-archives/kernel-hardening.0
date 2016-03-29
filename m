Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrWeLp1FX3Fz2z-kJezhPXKjvZHEhBH3guijeCgXdUunng@mail.gmail.com>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
	<CALCETrUxfPBawXNvKZgOnxhkaesw-b4PqCFUZbkRdaaqpjqnPQ@mail.gmail.com>
	<56FAF571.3040802@eng.utah.edu>
	<CALCETrWeLp1FX3Fz2z-kJezhPXKjvZHEhBH3guijeCgXdUunng@mail.gmail.com>
Date: Tue, 29 Mar 2016 17:34:35 -0500
Message-ID: <CA+55aFzY0p5OyTfnajTz2SL9qni=0FyUT7SeqS0CuXnwRPHS5w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Andy Lutomirski <luto@amacapital.net>
Cc: Scotty Bauer <sbauer@eng.utah.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 29, 2016 at 4:38 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Then there's an unanswered question: is this patch acceptable given
> that it's an ABI break?  Security fixes are sometimes an exception to
> the "no ABI breaks" rule, but it's by no means an automatic exception.

So there isn't any "no ABI break" rule - there is only a "does it
break real applications" rule.

(This can also be re-stated as: "Talk is cheap", aka "reality trumps
documentation".

Documentation is meaningless if it doesn't match reality, and what we
actually *do* is what matters.

So the ABI isn't about some theoretical interface documentation, the
ABI is about what people use and have tested.

On the one hand, that means that that our ABI is _stricter_ than any
documentatiuon, and that "but we can make this change that breaks app
XYZ, because XYZ is depending on undocumented behavior" is not an
acceptable excuse.

But on the other hand it *also* means that since the ABI is about real
programs, not theoretical issues, we can also change things as long as
we don't actually break anything that people can notice and depend
on).

And while *acute* security holes will be fixed regardless of ABI
issues, something like this that is only hardening rather than fixing
a particular security hole, really needs to not break any
applications.

Because if it does break anything, it needs to be turned off by
default. That's a hard rule. And since that would be largely defeating
the whole point o fthe series, I think we really need to have made
sure nothing breaks before a patch series like this can be accepted.

That said, if this is done right, I don't think it will break
anything. CRIU may indeed be a special case, but CRIU isn't really a
normal application, and the CRIU people may need to turn this off
explicitly, if it does break.

But yes, dosemu needs to be tested, and needs to just continue
working. But does dosemu actually create a signal stack, as opposed to
just playing with one that has been created for it? I thought it was
just the latter case, which should be ok even with a magic cookie in
there.

                   Linus
