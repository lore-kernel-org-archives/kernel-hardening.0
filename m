Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 10 Nov 2015 02:24:54 +0100
MIME-Version: 1.0
Message-ID: <56414766.18876.2B8A87D7@pageexec.freemail.hu>
In-reply-to: <CAGXu5jKzKAje_gtOQY7ukh67LLqmcWzVQ502V6akAB6ShH3h3w@mail.gmail.com>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr>, <alpine.DEB.2.10.1511092154160.3844@hadrien>, <CAGXu5jKzKAje_gtOQY7ukh67LLqmcWzVQ502V6akAB6ShH3h3w@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops structures
To: Julia Lawall <julia.lawall@lip6.fr>, Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dan Carpenter <dan.carpenter@oracle.com>, Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> On Mon, Nov 9, 2015 at 1:55 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> >> > What happens if some structures cannot be made const because there is a
> >> > reassignment somewhere?  Is there any feedback about the problem?

the constify plugin basically simulates what a source level 'const' would
do (sets a specific flag on the 'tree' structure representing the so-called
main variant of the ops type, see my h2hc13 presentation for details) and
since this happens early in the frontend, the const violations will be
reported by the compiler just like as it would otherwise report such source
level problems.

this way one can simply put a do_const attribute on a type, recompile the
tree and see if the compiler ever reports an error to know if the given
constification attempt is viable for the given type or not (and by finding
the 'bad' assignments one can see where to consider rewriting the code
perhaps, we did this a lot in PaX for example to achieve the current level
of attack surface reduction).

cheers,
 PaX Team
