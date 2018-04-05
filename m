MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180331015236.GA3852@beast>
References: <20180331015236.GA3852@beast>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 5 Apr 2018 12:52:23 -0700
Message-ID: <CAGXu5jJsaB+FJJszkOwvW2VYbSHGVyTD+EE=n+k1p1Mg_wtkMw@mail.gmail.com>
Subject: Re: [PATCH v7] kernel.h: Retain constant expression output for max()/min()
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 30, 2018 at 6:52 PM, Kees Cook <keescook@chromium.org> wrote:
> This patch updates the min()/max() macros to evaluate to a constant
> expression when called on constant expression arguments. This removes

Hi Linus,

This patch seems finished (*knock on wood*). Do you want to take this
directly for v4.17, should I send a single-patch pull-request, or
should this go through -mm (for either 4.17 or 4.18)?

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
