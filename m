MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
References: <1509945567-11801-1-git-send-email-me@tobin.cc> <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Nov 2017 09:41:09 -0800
Message-ID: <CA+55aFw6A8Ta=yMGKiOdcMMV16-PuP9GZmia4yA_5zLdoJnFUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 6, 2017 at 9:27 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Lovely. This is great. It shows just how much totally pointless stuff
> we leak, and to normal users that really shouldn't need it.

Side note: it would be good to have some summary view, and perhaps
some way to limit duplicates.

I ended up running this command line from hell to summarize the
different sources:

    perl leaking_addresses.pl |
            cut -d: -f1 |
            sed 's:/[0-9]*/:/X/:g' |
            sed 's:/module/[^/]*/:/module/X/:g' |
            sort | uniq | less -S

and maybe that kind of duplicate culling could be part of the script
itself if you pass it some summary line.

In particular, if would be nice to have a summary report that

 - only shows the first address for a particular source

 - have some logic to collapse repeated entries of "same file, just
different instance"

my sed-invocations there are obviously very ad-hoc, I'm  not actually
advocating that crap, it's only meant as hacky example of what I'm
talking about. Something smarter would be much better.

Because right now if some developer runs it, they might miss some case
that they should care about, simply because it's hidden among all the
thousands of essentially duplicate cases.

                 Linus
