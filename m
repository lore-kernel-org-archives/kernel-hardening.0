MIME-Version: 1.0
In-Reply-To: <20171019014429.GG31318@eros>
References: <1508362242-12857-1-git-send-email-me@tobin.cc>
 <CAHmME9oawjpRQEqo_rHgqjC6S8pSrEr2sbr06Gkhm93DXq9kqA@mail.gmail.com>
 <20171019013106.GE604@jagdpanzerIV> <CAHmME9oDWRo2CYMoF+frqypje4DEBFchEoX-j19jkHNybkGUrQ@mail.gmail.com>
 <20171019014429.GG31318@eros>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 19 Oct 2017 07:49:06 +0200
Message-ID: <CAHmME9qV-f1pvW0iC2cYU71PA+YUf0YpR=06T+FCFxywRhvjEw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

A small detail carried over from the other thread:

>
> but a bigger problem might the following thing:
>
> vscnprintf()
>  pointer()
>   ptr_to_id()
>    initialize_ptr_secret()
>     get_random_bytes()
>      _get_random_bytes()
>       extract_crng()
>        _extract_crng()
>         spin_lock_irqsave(&crng->lock, flags);   <<<<<
>
>
> this, once again, can deadlock. can it? just like before:

So, actually, then, we need to do this as an initcall. Fortunately,
that simplifies things greatly. Here's a rough sketch of what that
looks like, which you'll probably need to debug and refine:



static siphash_key_t ptr_secret __ro_after_init;
static DEFINE_STATIC_KEY_TRUE(no_ptr_secret);

static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
{
    if (static_branch_unlikely(&no_ptr_secret))
        return "(pointer value)";

    hashval = ....

}

static void fill_random_ptr_key(struct random_ready_callback *rdy)
{
    get_random_bytes(&ptr_secret, sizeof(ptr_secret));
    static_branch_disable(&no_ptr_secret);
}

static struct random_ready_callback random_ready = {
    .func = fill_random_ptr_key
};

static int __init initialize_ptr_random(void)
{
    int ret = add_random_ready_callback(&random_ready);

    if (!ret)
        return 0;
    else if (ret == -EALREADY) {
        fill_random_ptr_key(&random_ready);
        return 0;
    }

    return ret;
}
early_initcall(initialize_ptr_random);
