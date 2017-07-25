MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170725075217.bfwp7slacegqcv7g@ishxps>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
 <20170724133824.27223-4-LiljestrandH@gmail.com> <CAGXu5jKLFoF584WMYG2CEaON-RSV6TjEzVJtvbuT1ahs0ER6cw@mail.gmail.com>
 <20170725075217.bfwp7slacegqcv7g@ishxps>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Jul 2017 11:22:02 -0700
Message-ID: <CAGXu5jKNnGvgWQKTDj7bjYN3vkppweTe8mZhY9PgDtakUTn5Xw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH 3/5] x86: add mpxk-wrappers
To: Hans Liljestrand <liljestrandh@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 25, 2017 at 12:52 AM, Hans Liljestrand
<liljestrandh@gmail.com> wrote:
> Do you mean the FORTIFY_SOURCE thing (could not find anything directly on
> CONFIG_FORTIFY). Based on a quick look FORTIFY_SOURCE is localized, and
> essentially just provides the equivalent os our "wrappers", but I could be
> wildly off?

Yup, I mean this:

https://git.kernel.org/linus/6974f0c4555e285ab217cee58b6e874f776ff409

> MPXK on the other hand also checks other pointer dereferences and propagates
> pointer bounds into non-wrapper functions. The wrappers themselves also do
> not load any bounds, instead the calling function passes in the pointer
> bounds via the bound registers (although the caller might, depending on the
> situation have loaded the bounds based on the kmalloc allocation).

What are the code patterns that MPXK protects? It sounds like I'm not
quite seeing what MPXK provides beyond the CONFIG_FORTIFY_SOURCE
checks (both need to know the bounds already...)

> Can you recommend any "standard" way of doing measurements, either coverage
> or performance, for this kind of protections?

I say, for build coverage (possibly via some compile-time warning),
how many, e.g., memcpy()s are protected (i.e. bounds are known). And
then similarly, during runtime (possibly via kprobe) how many
memcpy()s are protected?

For performance, it's trickier, and needs a meaningful workload. I've
used hackbench and kernel build times...

-Kees

-- 
Kees Cook
Pixel Security
