MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180308141833.3fb57913bceae38f18db2bf1@linux-foundation.org>
References: <20180308214045.GA6787@beast> <20180308141833.3fb57913bceae38f18db2bf1@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 8 Mar 2018 14:49:59 -0800
Message-ID: <CAGXu5j+6rPgn1biniy6Xju5w7=n9ogiOZvHs_kvT55LT9u9y2Q@mail.gmail.com>
Subject: Re: [PATCH] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 2:18 PM, Andrew Morton <akpm@linux-foundation.org> w=
rote:
> On Thu, 8 Mar 2018 13:40:45 -0800 Kees Cook <keescook@chromium.org> wrote=
:
>
>> When max() is used in stack array size calculations from literal values
>> (e.g. "char foo[max(sizeof(struct1), sizeof(struct2))]", the compiler
>> thinks this is a dynamic calculation due to the single-eval logic, which
>> is not needed in the literal case. This change removes several accidenta=
l
>> stack VLAs from an x86 allmodconfig build:
>>
>> $ diff -u before.txt after.txt | grep ^-
>> -drivers/input/touchscreen/cyttsp4_core.c:871:2: warning: ISO C90 forbid=
s variable length array =E2=80=98ids=E2=80=99 [-Wvla]
>> -fs/btrfs/tree-checker.c:344:4: warning: ISO C90 forbids variable length=
 array =E2=80=98namebuf=E2=80=99 [-Wvla]
>> -lib/vsprintf.c:747:2: warning: ISO C90 forbids variable length array =
=E2=80=98sym=E2=80=99 [-Wvla]
>> -net/ipv4/proc.c:403:2: warning: ISO C90 forbids variable length array =
=E2=80=98buff=E2=80=99 [-Wvla]
>> -net/ipv6/proc.c:198:2: warning: ISO C90 forbids variable length array =
=E2=80=98buff=E2=80=99 [-Wvla]
>> -net/ipv6/proc.c:218:2: warning: ISO C90 forbids variable length array =
=E2=80=98buff64=E2=80=99 [-Wvla]
>>
>> Based on an earlier patch from Josh Poimboeuf.
>>
>> ...
>>
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -787,37 +787,57 @@ static inline void ftrace_dump(enum ftrace_dump_mo=
de oops_dump_mode) { }
>>   * strict type-checking.. See the
>>   * "unnecessary" pointer comparison.
>>   */
>> -#define __min(t1, t2, min1, min2, x, y) ({           \
>> +#define __single_eval_min(t1, t2, min1, min2, x, y) ({       \
>>       t1 min1 =3D (x);                                  \
>>       t2 min2 =3D (y);                                  \
>>       (void) (&min1 =3D=3D &min2);                        \
>>       min1 < min2 ? min1 : min2; })
>>
>> +/*
>> + * In the case of builtin constant values, there is no need to do the
>> + * double-evaluation protection, so the raw comparison can be made.
>> + * This allows min()/max() to be used in stack array allocations and
>> + * avoid the compiler thinking it is a dynamic value leading to an
>> + * accidental VLA.
>> + */
>> +#define __min(t1, t2, x, y)                                          \
>> +     __builtin_choose_expr(__builtin_constant_p(x) &&                \
>> +                           __builtin_constant_p(y) &&                \
>> +                           __builtin_types_compatible_p(t1, t2),     \
>> +                           (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),    \
>> +                           __single_eval_min(t1, t2,                 \
>> +                                             __UNIQUE_ID(max1_),     \
>> +                                             __UNIQUE_ID(max2_),     \
>> +                                             x, y))
>> +
>
> Holy crap.
>
> I suppose gcc will one day be fixed and we won't need this.
>
> Is there a good reason to convert min()?  Surely nobody will be using
> min to dimension an array - always max?  Just for symmetry, I guess.

I just went with symmetry. It seems like an ugly risk to implement min
and mix differently. :) In theory it may produce smaller code for rare
min() uses, but I haven't actually verified that.

I will send a v2 with the two nits mentioned...

-Kees

--=20
Kees Cook
Pixel Security
