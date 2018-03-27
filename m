MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180326221554.GA45166@beast>
References: <20180326221554.GA45166@beast>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 26 Mar 2018 14:52:06 -1000
Message-ID: <CA+55aFw2Jn=ispuj1Xzj_RwPPMR3-1eYTi+BFo+2-d07AJBQJw@mail.gmail.com>
Subject: Re: [PATCH v6] kernel.h: Retain constant expression output for max()/min()
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 26, 2018 at 12:15 PM, Kees Cook <keescook@chromium.org> wrote:
>
> This patch updates the min()/max() macros to evaluate to a constant
> expression when called on constant expression arguments.

Ack.

I'm of two minds whether that "__is_constant()" macro should be
explained or not.

A small voice in my head says "that wants a comment".

But a bigger voice disagrees.

It is a work of art, and maybe the best documentation is just the
name. It does what it says it does.

Art shouldn't be explained. It should be appreciated.

Nobody sane really should care about how it works, and if somebody
cares it is "left as an exercise to the reader".

      Linus
