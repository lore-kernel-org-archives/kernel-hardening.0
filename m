MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CANiq72nmCCDa9vV-49cNaJoQQO25r2YsYDaspoKn0xMeDOH10w@mail.gmail.com>
References: <20180309200536.GA5670@beast> <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
 <e8874944-f0b7-7a1f-26f3-446d7d7fcc38@infradead.org> <CANiq72k_vsTPMXvcfTNo+sjRoVMkihvRz-fzeXdcXvNEEeY-Pw@mail.gmail.com>
 <CANiq72nmCCDa9vV-49cNaJoQQO25r2YsYDaspoKn0xMeDOH10w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Mar 2018 08:04:40 -0800
Message-ID: <CA+55aFxtM4zq7vGsUz0DBpJ7jECrHoXwiYdAX+Z2wSNyfPKDsw@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
Content-Type: text/plain; charset="UTF-8"
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, linux-kernel <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 11:03 PM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> Just compiled 4.9.0 and it seems to work -- so that would be the
> minimum required.
>
> Sigh...
>
> Some enterprise distros are either already shipping gcc >= 5 or will
> probably be shipping it soon (e.g. RHEL 8), so how much does it hurt
> to ask for a newer gcc? Are there many users/companies out there using
> enterprise distributions' gcc to compile and run the very latest
> kernels?

I wouldn't mind upping the compiler requirements, and we have other
reasons to go to 4.6.

But _this_ particular issue doesn't seem worth it to then go even
further. Annoying.

                   Linus
