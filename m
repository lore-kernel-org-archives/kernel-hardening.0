MIME-Version: 1.0
In-Reply-To: <1508362242-12857-1-git-send-email-me@tobin.cc>
References: <1508362242-12857-1-git-send-email-me@tobin.cc>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 19 Oct 2017 03:03:48 +0200
Message-ID: <CAHmME9oawjpRQEqo_rHgqjC6S8pSrEr2sbr06Gkhm93DXq9kqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 18, 2017 at 11:30 PM, Tobin C. Harding <me@tobin.cc> wrote:
> +static siphash_key_t ptr_secret __read_mostly;
> +static atomic_t have_key = ATOMIC_INIT(0);
> +
> +static void initialize_ptr_secret(void)
> +{
> +       if (atomic_read(&have_key) == 1)
> +               return;
> +
> +       get_random_bytes(&ptr_secret, sizeof(ptr_secret));
> +       atomic_set(&have_key, 1);
> +}

> +               case -EALREADY:
> +                       initialize_ptr_secret();
> +                       break;

Unfortunately the above is racy, and the spinlock you had before was
actually correct (though using an atomic inside a spinlock wasn't
strictly necessary). The race is that two callers might hit
initialize_ptr_secret at the same time, and have_key will be zero at
the beginning for both. Then they'll both scribble over ptr_secret,
and might wind up using a different value after if one finishes before
the other. I see two ways of correcting this:

1) Go back to the spinlock yourself.
2) Use get_random_bytes_once(&ptr_secret, sizeof(ptr_secret)). I don't
know lib/once.c especially well, but from cursory look, it appears to
be taking a spinlock too, which means you're probably good.


+       if (atomic_read(&have_key) == 0) {
+               random_ready.owner = NULL;
+               random_ready.func = schedule_async_key_init;

You can probably take care of this part in the initialization:

static struct random_ready_callback random_ready = {
        .func = schedule_async_key_init
};

Alternatively, you could put the actual call to
add_random_ready_callback in an init function, but maybe how you have
it is easier.


Jason
