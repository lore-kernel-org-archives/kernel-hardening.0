MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jLYQypb=-kf9swRy8F4tSFx_R-urE2tREavOMF-OaXD8g@mail.gmail.com>
References: <1511921105-3647-1-git-send-email-me@tobin.cc> <1511921105-3647-4-git-send-email-me@tobin.cc>
 <CAMuHMdVZWUHNEbfO7OCPQV5Q3bA41c6VpwqfvT37ZEV9AR8chw@mail.gmail.com>
 <20171205.153120.151025775956658954.davem@davemloft.net> <e8dd4332196348df8938a1ad8991dc84@AcuMS.aculab.com>
 <CAGXu5jLYQypb=-kf9swRy8F4tSFx_R-urE2tREavOMF-OaXD8g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Dec 2017 15:28:22 -0800
Message-ID: <CA+55aFy4qnm3m5QupLMcp-8k0yz6E_-ug6rE-1aerpEQObYcLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH V11 3/5] printk: hash addresses printed with %p
To: Kees Cook <keescook@chromium.org>
Cc: David Laight <David.Laight@aculab.com>, David Miller <davem@davemloft.net>, "geert@linux-m68k.org" <geert@linux-m68k.org>, "me@tobin.cc" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason@zx2c4.com" <Jason@zx2c4.com>, "tytso@mit.edu" <tytso@mit.edu>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "tycho@tycho.ws" <tycho@tycho.ws>, "william.c.roberts@intel.com" <william.c.roberts@intel.com>, "tj@kernel.org" <tj@kernel.org>, "Golden_Miller83@protonmail.ch" <Golden_Miller83@protonmail.ch>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "pmladek@suse.com" <pmladek@suse.com>, "joe@perches.com" <joe@perches.com>, "ijc@hellion.org.uk" <ijc@hellion.org.uk>, "sergey.senozhatsky@gmail.com" <sergey.senozhatsky@gmail.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "wilal.deacon@arm.com" <wilal.deacon@arm.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "cfries@google.com" <cfries@google.com>, "olorin@google.com" <olorin@google.com>, "danielmicay@gmail.com" <danielmicay@gmail.com>, "tixxdz@gmail.com" <tixxdz@gmail.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "aryabinin@virtuozzo.com" <aryabinin@virtuozzo.com>, "glider@google.com" <glider@google.com>, "dvyukov@google.com" <dvyukov@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "sergei.shtylyov@cogentembedded.com" <sergei.shtylyov@cogentembedded.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 6, 2017 at 3:21 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Dec 6, 2017 at 2:31 AM, David Laight <David.Laight@aculab.com> wrote:
>>
>> I can also image issues where you want to know whether 2 pointers point
>> into the same structure (like an skb).
>
> This is already retained due to the hashing. i.e. the same pointer
> value will produce the same hash value, so that kind of direct
> comparison still works.

DavidL isn't talking about the _same_ pointer, he's talking about it
being offset from the same base.

But realistically, I don't think we ever hash things like that anyway.

Things like that do show up in register dumps etc during oopses, but
those aren't hashed.

            Linus
