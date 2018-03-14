From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3] kernel.h: Skip single-eval logic on literals in
 min()/max()
Date: Wed, 14 Mar 2018 11:35:26 +0000
Message-ID: <4922d8fb3c334e76a622258bb3c610e6@AcuMS.aculab.com>
References: <20180309200536.GA5670@beast>
 <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
 <CA+55aFw9hWz1-YFVoHEiXDjqb9q7dz=rQVXr7YLkMuVLvbwaOg@mail.gmail.com>
 <20180309163241.a421e216999bd0b1f43a64c2@linux-foundation.org>
 <CA+55aFwbO2vUsjWzAwB6SZ65RM4r3P0+2JvyMHn=ry0CgWCBgA@mail.gmail.com>
 <CAGXu5j+D=zs8AMb969dhH05GmKPuBxKPcAs89KfKzVf47faL1g@mail.gmail.com>
 <20180312155524.b421f07d7f08f24c57bd1887@linux-foundation.org>
 <CA+55aFwK7W0SsaP5eR+2TxOj-j_Mu_E11fRw2Gk8ptV71ebvww@mail.gmail.com>
 <CAGXu5j+M0qbBS0og8buXHdubA=oi=jMcK=ehLGDeevFd2H7JmA@mail.gmail.com>
 <20180313140248.7fdb0d0cee044cd7c7fc7b93@linux-foundation.org>
 <CAGXu5j+JUfvYCej17Gx__3Vhu4JmimddrSgV89c2tkfwshH_Mw@mail.gmail.com>
In-Reply-To: <CAGXu5j+JUfvYCej17Gx__3Vhu4JmimddrSgV89c2tkfwshH_Mw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: 'Kees Cook' <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus
 Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo
 Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogS2VlcyBDb29rDQo+IFNlbnQ6IDEzIE1hcmNoIDIwMTggMjI6MTUNCi4uLg0KPiBJJ2xs
IHNlbmQgYSAiY29uc3RfbWF4KCkiIHdoaWNoIHdpbGwgcmVmdXNlIHRvIHdvcmsgb24NCj4gbm9u
LWNvbnN0YW50LXZhbHVlcyAoc28gaXQgZG9lc24ndCBnZXQgYWNjaWRlbnRhbGx5IHVzZWQgb24g
dmFyaWFibGVzDQo+IHRoYXQgY291bGQgYmUgZXhwb3NlZCB0byBkb3VibGUtZXZhbHVhdGlvbiks
IGFuZCB3aWxsIHdvcmsgZm9yIHN0YWNrDQo+IGFycmF5IGRlY2xhcmF0aW9ucyAodG8gYXZvaWQg
dGhlIG92ZXJseS1zZW5zaXRpdmUgLVd2bGEgY2hlY2tzKS4NCg0KSVNUUiB0aGUgZGVmaW5pdGlv
bnMgd2VyZSBvZiB0aGUgZm9ybToNCgljaGFyIGZvb1ttYXgoc2l6ZW9mIChzdHJ1Y3QgYmFoKSwg
c2l6ZW9mIChzdHJ1Y3QgYmF6KSldOw0KVGhpcyBkb2Vzbid0IGdlbmVyYXRlIGEgJ2Zvbycgd2l0
aCB0aGUgcmVxdWlyZWQgYWxpZ25tZW50Lg0KSXQgd291bGQgYmUgbXVjaCBiZXR0ZXIgdG8gdXNl
IGEgdW5pb24uDQoNCglEYXZpZA0KDQo=
