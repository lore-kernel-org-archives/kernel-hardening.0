MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAHmME9qV-f1pvW0iC2cYU71PA+YUf0YpR=06T+FCFxywRhvjEw@mail.gmail.com>
References: <1508362242-12857-1-git-send-email-me@tobin.cc>
 <CAHmME9oawjpRQEqo_rHgqjC6S8pSrEr2sbr06Gkhm93DXq9kqA@mail.gmail.com>
 <20171019013106.GE604@jagdpanzerIV> <CAHmME9oDWRo2CYMoF+frqypje4DEBFchEoX-j19jkHNybkGUrQ@mail.gmail.com>
 <20171019014429.GG31318@eros> <CAHmME9qV-f1pvW0iC2cYU71PA+YUf0YpR=06T+FCFxywRhvjEw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 19 Oct 2017 10:18:01 -0700
Message-ID: <CAGXu5jKfeQm6ygxN7yvXs3nhLbi0EK+LbQhuEc0mKgSN-BZHZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5] printk: hash addresses printed with %p
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 18, 2017 at 10:49 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> static void fill_random_ptr_key(struct random_ready_callback *rdy)
> {
>     get_random_bytes(&ptr_secret, sizeof(ptr_secret));
>     static_branch_disable(&no_ptr_secret);
> }
>
> static struct random_ready_callback random_ready = {
>     .func = fill_random_ptr_key
> };
>
> static int __init initialize_ptr_random(void)
> {
>     int ret = add_random_ready_callback(&random_ready);
>
>     if (!ret)
>         return 0;
>     else if (ret == -EALREADY) {
>         fill_random_ptr_key(&random_ready);
>         return 0;
>     }
>
>     return ret;
> }
> early_initcall(initialize_ptr_random);

Tangent: why is the random_ready API designed with -EALREADY? Couldn't
add_random_ready_callback() just perform the call itself and avoid
needing all the callers to check for -EALREADY?

-Kees

-- 
Kees Cook
Pixel Security
