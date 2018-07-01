Date: Sun, 1 Jul 2018 11:03:29 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3 12/16] treewide: Use array_size() for
 kmalloc()-family
In-Reply-To: <b4c01457-7ea5-e7e3-be8b-f00fba6bac2b@users.sourceforge.net>
Message-ID: <alpine.DEB.2.20.1807011100110.2748@hadrien>
References: <20180601004233.37822-13-keescook@chromium.org> <b4c01457-7ea5-e7e3-be8b-f00fba6bac2b@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1156912627-1530435810=:2748"
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Kees Cook <keescook@chromium.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

--8323329-1156912627-1530435810=:2748
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

> > // 2-factor product with sizeof(variable)
> > @@
> > identifier alloc =~ "kmalloc|kzalloc|kvmalloc|kvzalloc";
>
> * This regular expression could be optimised to the specification “kv?[mz]alloc”.
>   Extensions will be useful for further function names.
>
> * The repetition of such a constraint in subsequent SmPL rules could be avoided
>   if inheritance will be used for this metavariable.

This is quite incorrect.  Inheritance is only possible when a match of the
previous rule has succeeded.  If a rule never applies in a given file, the
rules that inherit from it won't apply either.  Furthermore, what is
inherited is the value, not the constraint.  If the original binding of
alloc only ever matches kmalloc, then the inherited references will only
match kmalloc too.

julia
--8323329-1156912627-1530435810=:2748--
