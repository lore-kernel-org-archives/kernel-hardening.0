Date: Mon, 30 Oct 2017 17:57:48 +0800
From: Ye Xiaolong <xiaolong.ye@intel.com>
Message-ID: <20171030095748.GL3294@yexl-desktop>
References: <1508798008-1692-1-git-send-email-me@tobin.cc>
 <20171025162213.GH3294@yexl-desktop>
 <CAGXu5jJ+oVhroQHcbbiKERqYQXmoMtsmP_QuQwJX9TdAOdtYvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ+oVhroQHcbbiKERqYQXmoMtsmP_QuQwJX9TdAOdtYvQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [lkp-robot] [printk] 7f7c60e066: BUG:KASAN:slab-out-of-bounds
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/30, Kees Cook wrote:
>On Wed, Oct 25, 2017 at 9:22 AM, kernel test robot
><xiaolong.ye@intel.com> wrote:
>>
>> FYI, we noticed the following commit (built with gcc-4.9):
>>
>> commit: 7f7c60e0663645e757e520245606fde9c6e326bb ("printk: hash addresses printed with %p")
>> url: https://github.com/0day-ci/linux/commits/Tobin-C-Harding/printk-hash-addresses-printed-with-p/20171024-231922
>
>It's not clear to me which of the various versions this test ran

We'll improve it by showing the version info for LKML patchset.

Thanks,
Xiaolong

>against, but it seems like the printf self-tests got very confused by
>the results:
>
>> [   40.275423] test_printf: kvasprintf(..., "%p %p", ...) returned '3cf9adbe eff717bf', expected '0000000001234567 fffffffffedcba98'
>> [   40.296739] test_printf: vsnprintf(buf, 256, "|%-*p|%*p|", ...) returned 19, expected 39
>> [   40.322776] test_printf: vsnprintf(buf, 16, "|%-*p|%*p|", ...) returned 19, expected 39
>> [   40.334834] test_printf: vsnprintf(buf, 0, "|%-*p|%*p|", ...) returned 19, expected 39
>
>I assume v10 will fix the width issues, but probably not the value tests...
>
>And it claims a use-after-free, too:
>
>> [   39.757461] The buggy address belongs to the object at 22cb34bb
>> [   39.757461]  which belongs to the cache kmalloc-32 of size 32
>> [   39.757461] The buggy address is located 0 bytes inside of
>> [   39.757461]  32-byte region [22cb34bb, 24ac3a60)
>
>Which becomes rather unreadable, since the address got hashed. :P
>
>-Kees
>
>-- 
>Kees Cook
>Pixel Security
