References: <20180601004233.37822-13-keescook@chromium.org>
Subject: Re: [PATCH v3 12/16] treewide: Use array_size() for kmalloc()-family
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <b4c01457-7ea5-e7e3-be8b-f00fba6bac2b@users.sourceforge.net>
Date: Sun, 1 Jul 2018 10:46:56 +0200
MIME-Version: 1.0
In-Reply-To: <20180601004233.37822-13-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

> For kmalloc()-family allocations, instead of A * B, use array_size().
> Similarly, instead of A * B *C, use array3_size().

It took a while until my software development attention was caught also
by this update suggestion.


> Note that:
> 	kmalloc(array_size(a, b), ...);
> could be written as:
> 	kmalloc_array(a, b, ...)
> (and similarly, kzalloc(array_size(a, b), ...) as kcalloc(a, b, ...))

This is good to know, isn't it?


> but this made the Coccinelle script WAY larger.

Such a consequence is usual when the corresponding software development
challenges grow.
Are there further approaches to consider?


> There is no desire to replace kmalloc_array() with kmalloc(array_size(...), ...),
> but given the number of changes made treewide,

The number of changed source files can be impressive overall.


> I opted for Coccinelle simplicity.

I suggest to reconsider corresponding consequences.

I find that an important aspect can be missing in this commit description then.
How would you like to determine if the array size calculation (multiplication)
should be performed together with an overflow check (or not)?

How do you think about to express such a case distinction also in a bigger
script for the semantic patch language?


> This also tries to isolate sizeof() and constant factors, in an attempt
> to regularize the argument ordering.

This desire is reasonable.


> Automatically generated using the following Coccinelle script:

I have taken another look at implementation details.

* My view might not matter for the generated changes from this run
  of a limited SmPL script.

* My suggestions will influence the run time characteristics if such a source
  code transformation pattern will be executed again.


> // 2-factor product with sizeof(variable)
> @@
> identifier alloc =~ "kmalloc|kzalloc|kvmalloc|kvzalloc";

* This regular expression could be optimised to the specification “kv?[mz]alloc”.
  Extensions will be useful for further function names.

* The repetition of such a constraint in subsequent SmPL rules could be avoided
  if inheritance will be used for this metavariable.


> expression GFP, THING;
> identifier COUNT;
> @@
>
> - alloc(sizeof(THING) * COUNT, GFP)
> + alloc(array_size(COUNT, sizeof(THING)), GFP)

More change items are specified here than what would be essentially necessary.
* Function name
* Second parameter

This can be a design option to give the Coccinelle software the opportunity
for additional source code formatting (pretty printing).


These SmPL rules were designed in the way so far that they are independent
from previous rules. This approach contains the risk that a metavariable type
like “expression” can match more source code than it was expected.
This technical detail matters for the selection of the replacement “array3_size”.


The comments in the script indicate a desire for specific case distinctions.
I have got the impression that the use of SmPL disjunctions will be more
appropriate for the desired condition checks.
A priority could be specified then for involved pattern evaluation.

Would you like to adjust the transformation pattern any further?

Regards,
Markus
