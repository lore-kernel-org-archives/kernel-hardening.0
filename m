MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKwiHFhmc7FybX4pUg+Ozd6TC_W5BWtf-ztGUObZKW=BWgfi2A@mail.gmail.com>
References: <1520479847-39174-1-git-send-email-keescook@chromium.org>
 <20180308150236.5tysfbm3xdouii5n@treble> <78428dec-270e-5d74-0160-83feb5c0ff02@rasmusvillemoes.dk>
 <CAGXu5jKgDOezBGrYXCcy_UwM88rnT6pEpt9F062Q2qjf63KXBA@mail.gmail.com> <CAKwiHFhmc7FybX4pUg+Ozd6TC_W5BWtf-ztGUObZKW=BWgfi2A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 8 Mar 2018 15:33:21 -0800
Message-ID: <CAGXu5jLqwTpO+QECYvr33G5sp-j_m_MgTN0k+3Z9M2B14zUe-g@mail.gmail.com>
Subject: Re: [PATCH 0/3] Remove accidental VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 2:12 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> On 8 March 2018 at 21:39, Kees Cook <keescook@chromium.org> wrote:
>> However, this works for me:
>>
>> #define __new_max(t1, t2, max1, max2, x, y)                    \
>>        __builtin_choose_expr(__builtin_constant_p(x) && \
>>                              __builtin_constant_p(y) && \
>>                              __builtin_types_compatible_p(t1, t2),     \
>>                              (t1)(x) > (t2)(y) ? (t1)(x) : (t2)(y),    \
>>                              __max(t1, t2, max1, max2, x, y))
>>
>> #define new_max(x, y) \
>>         __new_max(typeof(x), typeof(y),                 \
>>               __UNIQUE_ID(max1_), __UNIQUE_ID(max2_),   \
>>               x, y)
>
> Yes, that would seem to do the trick.
>
> Thinking out loud: do we really want or need the
> __builtin_types_compatible condition when x and y are compile-time
> constants? I think it would be nice to be able to use max(16,
> sizeof(bla)) without having to cast either the literal or the sizeof.
> Just omitting the type compatibility check might be dangerous, but
> perhaps it could be relaxed to a check that both values are
> representable in their common promoted type. Something like
>
> (type_signed(t1) == type_signed(t2)) || ((t1)x >= 0 && (t2)y >= 0)
>
> should be safe (if the types have same signedness, or the value of
> signed type is positive), though it doesn't allow a few corner cases
> (e.g. short vs. unsigned char is always ok due to promotion to int,
> and also if the signed type is strictly wider than the unsigned type).

I agree, it would be nice. However, I think it'd be better to continue
to depend on max_t() for these kinds of cases though. For example:

char foo[max_t(size_t, 6, sizeof(something))];

Works with the proposed patch.

Also, I think this mismatch would already be triggering warnings, so
we shouldn't have any currently.

-Kees

-- 
Kees Cook
Pixel Security
