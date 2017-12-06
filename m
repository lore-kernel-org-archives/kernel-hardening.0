MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <CA+55aFw3SyO7Dq5gVVyC1AahaFzvyGoZ6X8B7z2g5_4r8+GaZA@mail.gmail.com>
References: <1511921105-3647-1-git-send-email-me@tobin.cc> <1511921105-3647-4-git-send-email-me@tobin.cc>
 <CAMuHMdVZWUHNEbfO7OCPQV5Q3bA41c6VpwqfvT37ZEV9AR8chw@mail.gmail.com>
 <20171205204402.GD11064@eros> <CAMuHMdVuc5yUNXhShb_vaR6T=qNexXm38mqBALeWzTNyGdHe+Q@mail.gmail.com>
 <CA+55aFw3SyO7Dq5gVVyC1AahaFzvyGoZ6X8B7z2g5_4r8+GaZA@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 6 Dec 2017 09:48:12 +0100
Message-ID: <CAMuHMdV4R9ngCiho0BuDkQ2K4ivVaDHs6pxkEdj2q=J=H0RXOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH V11 3/5] printk: hash addresses printed with %p
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

On Wed, Dec 6, 2017 at 12:33 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Dec 5, 2017 at 2:57 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> Lowest 3 is good enough for all natural types, up to long long.
>> We may still receive complaints from people who care about seeing if
>> a pointer is cacheline-aligned or not. Fixing that may need up to 7 bits, I'm
>> afraid, which is a bit too much to give up.
>
> I really think even the lowest three is a bit too much.
>
> Who really cares? If it's something that is particularly _about_
> alignment (ie an alignment trap), maybe just print out those bits
> separately.

If I'm not mistaken, some architectures don't generate alignment traps, but
just zero the LSBs.

> And for everything else? It's purely about getting used to it.

Yes, we will get used to it.

I agree that for debugging during development, we will just use %px and be
fine.

Storm in a glass of water, everybody will have forgotten by the time v4.16 is
released.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
