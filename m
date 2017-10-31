MIME-Version: 1.0
In-Reply-To: <20171030162244.4f55e623@gandalf.local.home>
References: <1508798008-1692-1-git-send-email-me@tobin.cc> <CAHmME9qRroNJ1i9URtmhFmx_BDJRVdXvyRKdSZ=fAmDpOYnv8A@mail.gmail.com>
 <20171024003158.GB1429@eros> <CAHmME9ry-=Ve29eRfdMHLa0PgPqGtB=P2YuctgnVSoQN+DvN8w@mail.gmail.com>
 <20171025034934.GD15832@eros> <20171030162244.4f55e623@gandalf.local.home>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 31 Oct 2017 15:22:27 +0100
Message-ID: <CAHmME9r6JfP0u2htKAebsfWxPGOc2nthqe56r2LN4VWJQD=z0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 30, 2017 at 9:22 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> How quickly do you need static_branch_disable() executed? You could
> always pass the work off to a worker thread (that can schedule).
>
> random_ready_callback -> initiates worker thread -> enables the static branch

I had already suggested that much earlier in the thread, but
discounted it in the very same suggestion, because that branch turns
out to be not that expensive anyway, and I think it's more important
that we're able to print meaningful values as soon as we can, rather
than waiting for the scheduler.
