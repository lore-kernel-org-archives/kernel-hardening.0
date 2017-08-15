Message-ID: <1502804557.6577.61.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Tue, 15 Aug 2017 09:42:37 -0400
In-Reply-To: <ivFwkYub2xhfl1WsxFJ7rARXO9-8ijXuThISjaPUTE7KlKY-FxIcEGkpLtPn9YPtrVqY2FtYVYlZbngdOaHkDytuDvbzTA1KUkLnqnrOOGc=@protonmail.ch>
References: <20170810172615.51965-1-thgarnie@google.com>
	 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
	 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
	 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
	 <ivFwkYub2xhfl1WsxFJ7rARXO9-8ijXuThISjaPUTE7KlKY-FxIcEGkpLtPn9YPtrVqY2FtYVYlZbngdOaHkDytuDvbzTA1KUkLnqnrOOGc=@protonmail.ch>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: x86: PIE support and option to extend
 KASLR randomization
To: Jordan Glover <Golden_Miller83@protonmail.ch>, Ingo Molnar <mingo@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@mellanox.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, "H
 . J . Lu" <hjl.tools@gmail.com>, Daniel Micay <danielmicay@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-08-15 at 08:15 -0400, Jordan Glover wrote:
> Hello,
> I write to put different perspective into the topic. I'm glad that
> kernel developers care about performance optimizations and I see how
> 10% overhead can be a problem for some. On the other hand last ten
> years gave us 1000% faster hardware which trumps anything software
> can do. For many users like us performance isn't a problem, we have
> plenty of it and if we haven't we can buy it. It can be money
> problem, not software engineering problem.

CPUs stopped getting faster at a dramatic rate, though,
while network cards continue to get faster.

In some areas, the kernel is more squeezed for CPU cycles
today than it has ever been before.

Ingo is suggesting that the security enhancement be
implemented in a way that doesn't come with a 10% performance
gain. There are other ways to relocate a kernel than with PIE.
