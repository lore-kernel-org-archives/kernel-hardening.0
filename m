MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1508986436-31966-1-git-send-email-me@tobin.cc>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Oct 2017 15:03:21 -0700
Message-ID: <CAGXu5jJvBKd2i-P4LVW_mHY9e3j4JEpaR4=a7dt3CcOvimcuTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH V8 0/2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 25, 2017 at 7:53 PM, Tobin C. Harding <me@tobin.cc> wrote:
> Here is the behaviour that this set implements.
>
> For kpt_restrict==0
>
> Randomness not ready:
>   printed with %p:              (pointer)          # NOTE: with padding
> Valid pointer:
>   printed with %pK:             deadbeefdeadbeef
>   printed with %p:              0xdeadbeef
>   malformed specifier (eg %i):  0xdeadbeef

I really think we can't include SPECIAL unless _every_ callsite of %p
is actually doing "0x%p", and then we're replacing all of those. We're
not doing that, though...

$ git grep '%p\b' | wc -l
12766
$ git grep '0x%p\b' | wc -l
1837

If we need some kind of special marking that this is a hashed
variable, that should be something other than "0x". If we're using the
existing "(null)" and new "(pointer)" text, maybe "(hash:xxxxxx)"
should be used instead? Then the (rare) callers with 0x become
"0x(hash:xxxx)" and naked callers produce "(hash:xxxx)".

I think the first step for this is to just leave SPECIAL out.

-Kees

-- 
Kees Cook
Pixel Security
