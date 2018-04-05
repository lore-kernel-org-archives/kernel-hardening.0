MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJsaB+FJJszkOwvW2VYbSHGVyTD+EE=n+k1p1Mg_wtkMw@mail.gmail.com>
References: <20180331015236.GA3852@beast> <CAGXu5jJsaB+FJJszkOwvW2VYbSHGVyTD+EE=n+k1p1Mg_wtkMw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Apr 2018 13:20:01 -0700
Message-ID: <CA+55aFxVvg=4cX6wTTVNCJMj-VzJp0KhLBY3yLP5Nd3eMXGt=w@mail.gmail.com>
Subject: Re: [PATCH v7] kernel.h: Retain constant expression output for max()/min()
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 5, 2018 at 12:52 PM, Kees Cook <keescook@chromium.org> wrote:
>
> This patch seems finished (*knock on wood*). Do you want to take this
> directly for v4.17, should I send a single-patch pull-request, or
> should this go through -mm (for either 4.17 or 4.18)?

I was actually expecting it to go with the other VLA removal patches,
but if the plan is to try to just get them in individual maintainer
trees, I guess I can just take this directly.

So if it would be a single-commit pull request, I'll just take it as a
patch. I guess it could go through -mm, but since I was involved in
the discussion anyway, I also don't mind just taking it directly. If
it causes problems, I can curse at myself.

               Linus
