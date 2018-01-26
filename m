Date: Fri, 26 Jan 2018 19:07:21 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20180126190721.36b0f589@alans-desktop>
In-Reply-To: <CAHmME9poivOgtCkOs5cjQXT0qxayk7MV2QLUBYhoUrKu=VUhuA@mail.gmail.com>
References: <CAHmME9p7QdAZf2NR4fkheRFVUoH1a27rmRcOnzkSS+nE5gJ63Q@mail.gmail.com>
	<20180126123158.9575-1-Jason@zx2c4.com>
	<20180126164310.13a29ad2@alans-desktop>
	<CAHmME9poivOgtCkOs5cjQXT0qxayk7MV2QLUBYhoUrKu=VUhuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v2] cpu: do not leak
 vulnerabilities to unprivileged users
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 26 Jan 2018 18:47:28 +0100
"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> On Fri, Jan 26, 2018 at 5:43 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> > a) The info is already trivially accessible via /proc/cpuinfo  
> 
> No, /proc/cpuinfo shows if the CPU itself has these bugs, but doesn't
> show whether or not the kernel has gone to lengths to mitigate these
> bugs.

It tells you immediately what microcode, what hardware properties. A few
user space instructions later and you know the rest.

> Right, so without this, an attacker has to measure. The purpose of
> this patchset is to require the attacker to perform an additional
> measurement. That seems worthwhile, especially if measurements are or
> would ever become non-trivial to make.

You mean 'I'm magically going to make it secure because the attacker
won't be smart enough to paste in a function from gitub' ?

I don't buy it. Most attack tools are automated, they will contain the
needed code.

> > b) Some JIT and other environments need to know  
> 
> Shouldn't JITs do the best they can with the environment they're in?
> And for that, isn't /proc/cpuinfo enough?

No

The JIT needs to know whether the mitigations are present because it
needs to JIT very different code if it is responsible for generating
things like lfence and and/mask references or can assume the CPU is
covering some or part of it.

Likewise you can imagine other code using those files in order to figure
out how to self patch / which library to load for performance critical
stuff.

Alan
