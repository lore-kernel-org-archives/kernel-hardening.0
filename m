From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3] kernel.h: Skip single-eval logic on literals in
 min()/max()
Date: Tue, 13 Mar 2018 13:31:24 +0000
Message-ID: <569ab24c68bb46ae99600b9b309ebcbd@AcuMS.aculab.com>
References: <20180309200536.GA5670@beast>
 <CA+55aFy82Drgu2xm1GWaDz2Jyj5QBx3dW4AatXzmCx-b1YET5Q@mail.gmail.com>
In-Reply-To: <CA+55aFy82Drgu2xm1GWaDz2Jyj5QBx3dW4AatXzmCx-b1YET5Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: 'Linus Torvalds' <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus
 Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo
 Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

VGhlIGFtb3VudCBvZiByZXBsaWNhdGVkIGRlZmluZWQgY291bGQgYWxzbyBiZSByZWR1Y2VkIGJ5
IHBhc3NpbmcgPiBvciA8DQp0byBhIG1pbl9tYXgoKSBtYWNyby4NClNvIHlvdSBzdGFydCBvZmYg
d2l0aCBzb21ldGhpbmcgbGlrZToNCiNkZWZpbmUgbWluKHgsIHkpIF9fbWluX21heCh4LCA8LCB5
KQ0KI2RlZmluZSBtYXgoeCwgeSkgX19taW5fbWF4KHgsID4sIHkpDQp0aGVuIGhhdmU6DQojZGVm
aW5lIF9fbWluX21heCh4LCBjb25kLCB5KSAoKHgpIGNvbmQgKHkpID8gKHgpIDogKHkpKQ0KaW4g
YWxsIGl0cyBhc3NvY2lhdGVkIGZsYXZvdXJzLg0KDQoJRGF2aWQNCg0KDQo=
