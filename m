Message-ID: <1499576440.1220.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sun, 09 Jul 2017 01:00:40 -0400
In-Reply-To: <CAK8P3a1ppGV9MuvkMxZkXmmmt_QrD3TA8CX8KTNHnNMgKrmKzw@mail.gmail.com>
References: <20170706101317.10382-1-ard.biesheuvel@linaro.org>
	 <CAK8P3a3-yd3c_Psi5zo1yug5eJvADYxHkfWTa4++_5WFuENo7g@mail.gmail.com>
	 <CAK8P3a3Xra=9aTRAWJ8DbRRYL4J2ieMDveeV9Ahp6dE9xXqsrg@mail.gmail.com>
	 <CAK8P3a1ppGV9MuvkMxZkXmmmt_QrD3TA8CX8KTNHnNMgKrmKzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC/RFT PATCH] gcc-plugins: force
 initialize auto variables whose addresses are taken
To: Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-07-07 at 00:08 +0200, Arnd Bergmann wrote:
> On Thu, Jul 6, 2017 at 1:25 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thu, Jul 6, 2017 at 1:09 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Thu, Jul 6, 2017 at 12:13 PM, Ard Biesheuvel
> > 
> > Sorry, bad example, that one is a bit less undefined than
> > I thought, as it will produce the same result every time,
> > regardless of the stack contents. I'll try to come up
> > with another test program instead.
> 
> I've tried a few more things, but couldn't actually come up with an
> example
> that ends up using uninitialized stack values without also warning
> about it,
> so your plugin may actually cover the most important cases.
> 
> The remaining cases I found are either uninitialized uses that we get
> a compile-time warning for, or other kinds of undefined behavior
> (as in my earlier example).
> 
>          Arnd

The compiler will optimize out zeroing that's clearly redundant, so zero
initialization of all uninitialized variables is not really all of them
but rather the set that the compiler thinks could be used before they
get initialized. It makes sense to have that as an option. It's an
aggressive non-heuristic-based approach and yet it isn't as heavy as it
seems due to optimization.

It also provides another baseline to compare a heuristic against. No
automatic zeroing vs. all uninitialized variables zeroed vs. proposed
heuristic. Definitely worth including even if the main purpose is to
figure what's *not* being covered by chosen heuristics, especially after
optimization where they'll be more similar. You could find the cases
you're talking about by comparing the generated code with the zeroing
guided by the reference taken heuristic.
