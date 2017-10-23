MIME-Version: 1.0
In-Reply-To: <1508798008-1692-1-git-send-email-me@tobin.cc>
References: <1508798008-1692-1-git-send-email-me@tobin.cc>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 24 Oct 2017 01:00:03 +0200
Message-ID: <CAHmME9qRroNJ1i9URtmhFmx_BDJRVdXvyRKdSZ=fAmDpOYnv8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Provided you've tested this and the static_key guard stuff actually
works as intended, for the crypto/rng/siphash aspects:

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
