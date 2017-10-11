MIME-Version: 1.0
In-Reply-To: <1507676974-1298-1-git-send-email-me@tobin.cc>
References: <1507676974-1298-1-git-send-email-me@tobin.cc>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 11 Oct 2017 22:09:20 +0200
Message-ID: <CAHmME9qPguYLUk-CsKB7LEsTiP6spha-Rt7r41KG=TMdj3FnHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/3] add %pX specifier
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Tobin,

On Wed, Oct 11, 2017 at 1:09 AM, Tobin C. Harding <me@tobin.cc> wrote:
>
>   +        hashval = hash_three_words(
>   +                (unsigned long)ptr,
>   +                (unsigned long)ptr >> 16 >> 16,
>   +                boot_time_random_int);

This is most likely not what you want to be using. Take a look at the
siphash_* set of functions. If you're just hashing 1 64-bit pointer
with some secret, use siphash_1u64, for example. That's the right
interface for this purpose.

Regards,
Jason
