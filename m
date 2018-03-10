Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in
 min()/max()
References: <20180309200536.GA5670@beast>
 <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e8874944-f0b7-7a1f-26f3-446d7d7fcc38@infradead.org>
Date: Fri, 9 Mar 2018 19:11:54 -0800
MIME-Version: 1.0
In-Reply-To: <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/09/2018 04:07 PM, Andrew Morton wrote:
> On Fri, 9 Mar 2018 12:05:36 -0800 Kees Cook <keescook@chromium.org> wrote:
> 
>> When max() is used in stack array size calculations from literal values
>> (e.g. "char foo[max(sizeof(struct1), sizeof(struct2))]", the compiler
>> thinks this is a dynamic calculation due to the single-eval logic, which
>> is not needed in the literal case. This change removes several accidental
>> stack VLAs from an x86 allmodconfig build:
>>
>> $ diff -u before.txt after.txt | grep ^-
>> -drivers/input/touchscreen/cyttsp4_core.c:871:2: warning: ISO C90 forbids variable length array ‘ids’ [-Wvla]
>> -fs/btrfs/tree-checker.c:344:4: warning: ISO C90 forbids variable length array ‘namebuf’ [-Wvla]
>> -lib/vsprintf.c:747:2: warning: ISO C90 forbids variable length array ‘sym’ [-Wvla]
>> -net/ipv4/proc.c:403:2: warning: ISO C90 forbids variable length array ‘buff’ [-Wvla]
>> -net/ipv6/proc.c:198:2: warning: ISO C90 forbids variable length array ‘buff’ [-Wvla]
>> -net/ipv6/proc.c:218:2: warning: ISO C90 forbids variable length array ‘buff64’ [-Wvla]
>>
>> Based on an earlier patch from Josh Poimboeuf.
> 
> v1, v2 and v3 of this patch all fail with gcc-4.4.4:
> 
> ./include/linux/jiffies.h: In function 'jiffies_delta_to_clock_t':
> ./include/linux/jiffies.h:444: error: first argument to '__builtin_choose_expr' not a constant


I'm seeing that problem with
> gcc --version
gcc (SUSE Linux) 4.8.5

in mmotm.

> That's with
> 
> #define __max(t1, t2, x, y)						\
> 	__builtin_choose_expr(__builtin_constant_p(x) &&		\
> 			      __builtin_constant_p(y) &&		\
> 			      __builtin_types_compatible_p(t1, t2),	\
> 			      (t1)(x) > (t2)(y) ? (t1)(x) : (t2)(y),	\
> 			      __single_eval_max(t1, t2,			\
> 						__UNIQUE_ID(max1_),	\
> 						__UNIQUE_ID(max2_),	\
> 						x, y))
> /**
>  * max - return maximum of two values of the same or compatible types
>  * @x: first value
>  * @y: second value
>  */
> #define max(x, y)	__max(typeof(x), typeof(y), x, y)
> 
> 
> A brief poke failed to reveal a workaround - gcc-4.4.4 doesn't appear
> to know that __builtin_constant_p(x) is a constant.  Or something.
> 
> Sigh.  Wasn't there some talk about modernizing our toolchain
> requirements?


-- 
~Randy
