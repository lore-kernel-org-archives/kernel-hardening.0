Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<20160628133645.8f3cac0df4fc363e308426ac@gmail.com>
	<874m8dhwb4.fsf@rasmusvillemoes.dk>
	<5772EE62.11219.7B892887@pageexec.freemail.hu>
Date: Wed, 29 Jun 2016 00:41:57 +0200
In-Reply-To: <5772EE62.11219.7B892887@pageexec.freemail.hu> (PaX Team's
	message of "Tue, 28 Jun 2016 23:38:42 +0200")
Message-ID: <87furxgclm.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v1 2/2] Mark functions with the __nocapture attribute
To: pageexec@freemail.hu
Cc: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28 2016, "PaX Team" <pageexec@freemail.hu> wrote:

> On 28 Jun 2016 at 22:50, Rasmus Villemoes wrote:
>
>> > +extern const char *kstrdup_const(const char *s, gfp_t gfp) __nocapture(1);
>> 
>> OK, so this one is pretty dangerous, and probably wrong. If one does
>> 
>>   foo->bar = kstrdup_const(a-macro-that-might-be-a-string-literal)
>> 
>> in an .init function, foo->bar will very likely become dangling.
>
> doesn't kstrdup_const omit the copy only for arguments that are stored in
> .rodata (which doesn't include .init.rodata* and other init sections)?
>

Ah, right. But that's a little subtle. Also, it kind of defeats the
purpose of kstrdup_const - but it's probably not actually called with a
string literal all that often.

In any case, I think there's still a problem with strchr() and friends.

Rasmus
