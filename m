Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 28 Jun 2016 23:38:42 +0200
MIME-Version: 1.0
Message-ID: <5772EE62.11219.7B892887@pageexec.freemail.hu>
In-reply-to: <874m8dhwb4.fsf@rasmusvillemoes.dk>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>, <20160628133645.8f3cac0df4fc363e308426ac@gmail.com> (Emese Revfy's message of "Tue, 28 Jun 2016 13:36:45 +0200"), <874m8dhwb4.fsf@rasmusvillemoes.dk>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH v1 2/2] Mark functions with the __nocapture attribute
To: Emese Revfy <re.emese@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: kernel-hardening@lists.openwall.com, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On 28 Jun 2016 at 22:50, Rasmus Villemoes wrote:

> > +extern const char *kstrdup_const(const char *s, gfp_t gfp) __nocapture(1);
> 
> OK, so this one is pretty dangerous, and probably wrong. If one does
> 
>   foo->bar = kstrdup_const(a-macro-that-might-be-a-string-literal)
> 
> in an .init function, foo->bar will very likely become dangling.

doesn't kstrdup_const omit the copy only for arguments that are stored in
.rodata (which doesn't include .init.rodata* and other init sections)?

cheers,
 PaX Team
