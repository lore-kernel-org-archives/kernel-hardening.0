MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20171207051711.GB2191@eros>
References: <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com> <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
 <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com> <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
 <CA+55aFw3AZtzf6KHS4desHJ3CajKs46VQxOi6-+0U8A4y0v6ug@mail.gmail.com>
 <20171206013657.GA479@jagdpanzerIV> <CA+55aFzMydq1TizkPOjZmRb_eKtHCk3w-xdO-Ce2jw9tu3bsGg@mail.gmail.com>
 <CAMuHMdUebiN16BA6qLO+Wv2LetdYgbmd8E_e74hQj52yEUwPOQ@mail.gmail.com>
 <20171206084537.GA462@jagdpanzerIV> <20171207051711.GB2191@eros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Dec 2017 21:29:24 -0800
Message-ID: <CA+55aFwN=xL=cxgY8pW54b6Zw41ExjxUpvZkAjpZGdh87tsEhw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="001a11401ae80d7838055fb95ab5"
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: tcharding <me@tobin.cc>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Randy Dunlap <rdunlap@infradead.org>, David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?Q?Radim_Krcm=C3=A1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11401ae80d7838055fb95ab5
Content-Type: text/plain; charset="UTF-8"

On Dec 6, 2017 21:17, "Tobin C. Harding" <me@tobin.cc> wrote:


> hm, indeed. and !CONFIG_KALLSYMS config turns %pS/%ps
> into special_hex_number().

But totally misses this :(

"<no-sym>" would be better returned when !CONFIG_KALLSYMS, right?


No, we still want those configurations to be debuggable.

If !CONFIG_KALLSYMS, we'll just continue print the hex number. It's not a
normal configuration, leaking an address there is fine, and preferable to
"cannot debug"

   Linus

--001a11401ae80d7838055fb95ab5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><br><div class=3D"gmail_extra" dir=3D"auto"><br><div clas=
s=3D"gmail_quote">On Dec 6, 2017 21:17, &quot;Tobin C. Harding&quot; &lt;me=
@tobin.cc&gt; wrote:<blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"quoted-text"><br>
&gt; hm, indeed. and !CONFIG_KALLSYMS config turns %pS/%ps<br>
&gt; into special_hex_number().<br>
<br>
</div>But totally misses this :(<br>
<br>
&quot;&lt;no-sym&gt;&quot; would be better returned when !CONFIG_KALLSYMS, =
right?<br></blockquote></div></div><div dir=3D"auto"><br></div><div dir=3D"=
auto">No, we still want those configurations to be debuggable.=C2=A0</div><=
div dir=3D"auto"><br></div><div dir=3D"auto">If !<span style=3D"font-family=
:sans-serif">CONFIG_KALLSYMS, we&#39;ll just continue print the hex number.=
 It&#39;s not a normal configuration, leaking an address there is fine, and=
 preferable to &quot;cannot debug&quot;</span></div><div dir=3D"auto"><span=
 style=3D"font-family:sans-serif"><br></span></div><div dir=3D"auto"><span =
style=3D"font-family:sans-serif">=C2=A0 =C2=A0Linus</span></div></div>

--001a11401ae80d7838055fb95ab5--
