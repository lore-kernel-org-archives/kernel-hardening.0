MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180313140248.7fdb0d0cee044cd7c7fc7b93@linux-foundation.org>
References: <20180309200536.GA5670@beast> <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
 <CA+55aFw9hWz1-YFVoHEiXDjqb9q7dz=rQVXr7YLkMuVLvbwaOg@mail.gmail.com>
 <20180309163241.a421e216999bd0b1f43a64c2@linux-foundation.org>
 <CA+55aFwbO2vUsjWzAwB6SZ65RM4r3P0+2JvyMHn=ry0CgWCBgA@mail.gmail.com>
 <CAGXu5j+D=zs8AMb969dhH05GmKPuBxKPcAs89KfKzVf47faL1g@mail.gmail.com>
 <20180312155524.b421f07d7f08f24c57bd1887@linux-foundation.org>
 <CA+55aFwK7W0SsaP5eR+2TxOj-j_Mu_E11fRw2Gk8ptV71ebvww@mail.gmail.com>
 <CAGXu5j+M0qbBS0og8buXHdubA=oi=jMcK=ehLGDeevFd2H7JmA@mail.gmail.com> <20180313140248.7fdb0d0cee044cd7c7fc7b93@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 13 Mar 2018 15:14:34 -0700
Message-ID: <CAGXu5j+JUfvYCej17Gx__3Vhu4JmimddrSgV89c2tkfwshH_Mw@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 13, 2018 at 2:02 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 12 Mar 2018 21:28:57 -0700 Kees Cook <keescook@chromium.org> wrot=
e:
>
>> On Mon, Mar 12, 2018 at 4:57 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> > On Mon, Mar 12, 2018 at 3:55 PM, Andrew Morton
>> > <akpm@linux-foundation.org> wrote:
>> >>
>> >> Replacing the __builtin_choose_expr() with ?: works of course.
>> >
>> > Hmm. That sounds like the right thing to do. We were so myopically
>> > staring at the __builtin_choose_expr() problem that we overlooked the
>> > obvious solution.
>> >
>> > Using __builtin_constant_p() together with a ?: is in fact our common
>> > pattern, so that should be fine. The only real reason to use
>> > __builtin_choose_expr() is if you want to get the *type* to vary
>> > depending on which side you choose, but that's not an issue for
>> > min/max.
>>
>> This doesn't solve it for -Wvla, unfortunately. That was the point of
>> Josh's original suggestion of __builtin_choose_expr().
>>
>> Try building with KCFLAGS=3D-Wval and checking net/ipv6/proc.c:
>>
>> net/ipv6/proc.c: In function =E2=80=98snmp6_seq_show_item=E2=80=99:
>> net/ipv6/proc.c:198:2: warning: ISO C90 forbids array =E2=80=98buff=E2=
=80=99 whose
>> size can=E2=80=99t be evaluated [-Wvla]
>>   unsigned long buff[SNMP_MIB_MAX];
>>   ^~~~~~~~
>
> PITA.  Didn't we once have a different way of detecting VLAs?  Some
> post-compilation asm parser, iirc.
>
> I suppose the world wouldn't end if we had a gcc version ifdef in
> kernel.h.  We'll get to remove it in, oh, ten years.

For fixing only 6 VLAs, we don't need all this effort. When it looked
like we could get away with just a "better" max(), sure. ;)

I'll send a "const_max()" which will refuse to work on
non-constant-values (so it doesn't get accidentally used on variables
that could be exposed to double-evaluation), and will work for stack
array declarations (to avoid the overly-sensitive -Wvla checks).

-Kees

--=20
Kees Cook
Pixel Security
