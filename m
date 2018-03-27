Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 27 Mar 2018 07:47:48 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v6] kernel.h: Retain constant expression output for
 max()/min()
Message-ID: <20180327054748.jx6mzywguuqfkqpv@gmail.com>
References: <20180326221554.GA45166@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326221554.GA45166@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> In the effort to remove all VLAs from the kernel[1], it is desirable to
> build with -Wvla. However, this warning is overly pessimistic, in that
> it is only happy with stack array sizes that are declared as constant
> expressions, and not constant values. One case of this is the evaluation
> of the max() macro which, due to its construction, ends up converting
> constant expression arguments into a constant value result.
> 
> All attempts to rewrite this macro with __builtin_constant_p() failed with
> older compilers (e.g. gcc 4.4)[2]. However, Martin Uecker constructed[3] a
> mind-shattering solution that works everywhere. Cthulhu fhtagn!
> 
> This patch updates the min()/max() macros to evaluate to a constant
> expression when called on constant expression arguments. This removes
> several false-positive stack VLA warnings from an x86 allmodconfig
> build when -Wvla is added:

Cool!

Acked-by: Ingo Molnar <mingo@kernel.org>

How many warnings are left in an allmodconfig build?

Thanks,

	Ingo
