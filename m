MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAMuHMdVuc5yUNXhShb_vaR6T=qNexXm38mqBALeWzTNyGdHe+Q@mail.gmail.com>
References: <1511921105-3647-1-git-send-email-me@tobin.cc> <1511921105-3647-4-git-send-email-me@tobin.cc>
 <CAMuHMdVZWUHNEbfO7OCPQV5Q3bA41c6VpwqfvT37ZEV9AR8chw@mail.gmail.com>
 <20171205204402.GD11064@eros> <CAMuHMdVuc5yUNXhShb_vaR6T=qNexXm38mqBALeWzTNyGdHe+Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Dec 2017 15:33:47 -0800
Message-ID: <CA+55aFw3SyO7Dq5gVVyC1AahaFzvyGoZ6X8B7z2g5_4r8+GaZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH V11 3/5] printk: hash addresses printed with %p
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 5, 2017 at 2:57 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Lowest 3 is good enough for all natural types, up to long long.
> We may still receive complaints from people who care about seeing if
> a pointer is cacheline-aligned or not. Fixing that may need up to 7 bits, I'm
> afraid, which is a bit too much to give up.

I really think even the lowest three is a bit too much.

Who really cares? If it's something that is particularly _about_
alignment (ie an alignment trap), maybe just print out those bits
separately.

And for everything else? It's purely about getting used to it.

I will just cut-and-paste what I wrote in another thread about the hashing:

  I'm going to require some actual proof of an actual case where it
  mattered that a particular value was hashed.

  Not hand-waving.

  Not "it surprised and confused me" because it looked different. You'll
  get used to it.

  So an actual "this was critical information that mattered for this
  particular bug, and it was missing due to the hashing of this
  particular value and debugging was harder in actual reality due to
  that".

  Because the actual example I have seen so far, not only didn't the
  hashing matter AT ALL, most of the _unhashed_ values shouldn't have
  been there either, and were due to arm still printing stuff that
  shouldn't have been printed at all and just made the oops more complex
  and harder to read and report.

This subject is really easy to bike-shed around. Everybody can have an
opinion. I want actual hard data and facts, not opinions.

And if the hashing _really_ is a problem, we'll just change that
particular thing to %px. But it needs actual hard data and real
reasons first, ok?

              Linus

          Linus
