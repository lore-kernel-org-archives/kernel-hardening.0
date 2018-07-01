Subject: Re: [PATCH v3 12/16] treewide: Use array_size() for kmalloc()-family
References: <20180601004233.37822-13-keescook@chromium.org>
 <b4c01457-7ea5-e7e3-be8b-f00fba6bac2b@users.sourceforge.net>
 <alpine.DEB.2.20.1807011100110.2748@hadrien>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <a98a68c8-8b08-b3e9-da7b-ff57a2614f96@users.sourceforge.net>
Date: Sun, 1 Jul 2018 11:22:36 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1807011100110.2748@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia.lawall@lip6.fr>, Kees Cook <keescook@chromium.org>, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

>> * The repetition of such a constraint in subsequent SmPL rules could be avoided
>>   if inheritance will be used for this metavariable.
> 
> This is quite incorrect.

I suggest to consider additional software design options.


> Inheritance is only possible when a match of the previous rule has succeeded.

I agree with this information.


> If a rule never applies in a given file, the rules that inherit from it
> won't apply either.

I would like to point the possibility out to specify a source code search
which will find interesting function calls at least by an inital SmPL rule.


> Furthermore, what is inherited is the value, not the constraint.

This technical detail can be fine.


> If the original binding of alloc only ever matches kmalloc,
> then the inherited references will only match kmalloc too.

Can the desired search pattern be extended in significant ways?

Regards,
Markus
