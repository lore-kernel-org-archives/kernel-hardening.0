MIME-Version: 1.0
In-Reply-To: <20171019013106.GE604@jagdpanzerIV>
References: <1508362242-12857-1-git-send-email-me@tobin.cc>
 <CAHmME9oawjpRQEqo_rHgqjC6S8pSrEr2sbr06Gkhm93DXq9kqA@mail.gmail.com> <20171019013106.GE604@jagdpanzerIV>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 19 Oct 2017 03:36:20 +0200
Message-ID: <CAHmME9oDWRo2CYMoF+frqypje4DEBFchEoX-j19jkHNybkGUrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5] printk: hash addresses printed with %p
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 19, 2017 at 3:31 AM, Sergey Senozhatsky
<sergey.senozhatsky.work@gmail.com> wrote:
> On (10/19/17 03:03), Jason A. Donenfeld wrote:
> [..]
>> 1) Go back to the spinlock yourself.
>
> so we ruled out NMI deadlocks?

Oh, right. No, I haven't thought through this enough to rule it out.
Indeed if that's an issue, the locks in the _once code will also be an
issue.

So if locking is totally impossible, then a race-free way of doing
this is with a tri-state compare and exchange. Things are either: in
state 1: no key, state 2: getting key, state 3: have key. If state 1
or 2, print the placeholder token. If state 3, do the hashing.
