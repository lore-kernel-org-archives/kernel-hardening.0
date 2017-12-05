References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com>
 <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
 <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <596c917e-3183-d80a-89d4-97e0eb5dc077@infradead.org>
Date: Tue, 5 Dec 2017 13:08:41 -0800
MIME-Version: 1.0
In-Reply-To: <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: David Laight <David.Laight@ACULAB.COM>, 'Kees Cook' <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?Q?Radim_Krcm=c3=a1r?= <rkrcmar@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/30/2017 02:38 AM, David Laight wrote:
> From: Kees Cook
>> Sent: 29 November 2017 22:28
>> On Wed, Nov 29, 2017 at 2:07 AM, David Laight <David.Laight@aculab.com> wrote:
>>> From: Linus Torvalds
>>>> Sent: 29 November 2017 02:29
>>>>
>>>> On Tue, Nov 28, 2017 at 6:05 PM, Tobin C. Harding <me@tobin.cc> wrote:
>>>>>
>>>>>    Let's add specifier %px as a
>>>>> clear, opt-in, way to print a pointer and maintain some level of
>>>>> isolation from all the other hex integer output within the Kernel.
>>>>
>>>> Yes, I like this model. It's easy and it's obvious ("'x' for hex"),
>>>> and it gives people a good way to say "yes, I really want the actual
>>>> address as hex" for if/when the hashed pointer doesn't work for some
>>>> reason.
>>>
>>> Remind me to change every %p to %px on kernels that support it.
>>>
>>> Although the absolute values of pointers may not be useful, knowing
>>> that two pointer differ by a small amount is useful.
>>> It is also useful to know whether pointers are to stack, code, static
>>> data or heap.
>>>
>>> This change to %p is going to make debugging a nightmare.
>>
>> In the future, maybe we could have a knob: unhashed, hashed (default),
>> or zeroed.
> 
> Add a 4th, hashed_page+offset.
> 
> Isn't there already a knob for %pK, bits in the same value could be used.
> That would make it easy to ensure that %pK is more restructive than %p.

(yeah, I'm kind of behind on this thread.)

This kind of option (with default hashed) is what I was just thinking of
after having seen a few unhelpful traces.  But then the knob might not be
changed in time for the traces either. :(


-- 
~Randy
