MIME-Version: 1.0
In-Reply-To: <20171113060807.GK11398@eros>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <1510322194.19812.3.camel@gmail.com> <20171112222119.GL19752@eros>
 <1510551988.30178.10.camel@gmail.com> <20171113060807.GK11398@eros>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Mon, 13 Nov 2017 12:22:23 +0530
Message-ID: <CAPDLWs_=jpHB46KxJ+r+RdDwRF8TWLknqy6jfzxkArt0yLx9HQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 13, 2017 at 11:38 AM, Tobin C. Harding <me@tobin.cc> wrote:
> On Mon, Nov 13, 2017 at 11:16:28AM +0530, kaiwan.billimoria@gmail.com wrote:
>> On Mon, 2017-11-13 at 09:21 +1100, Tobin C. Harding wrote:
>> > On Fri, Nov 10, 2017 at 07:26:34PM +0530, kaiwan.billimoria@gmail.com
>> >  wrote:
>> > > On Tue, 2017-11-07 at 21:32 +1100, Tobin C. Harding wrote:
>> > > > Currently we are leaking addresses from the kernel to user space.
>> > > > This
...
>
> So, Linus has requested that I set up a tree for the development of
> this. I have to work out the details of how to do that and then I'll
> email you so you can get the pull the current version. I can then take
> your patch via LKML as per usual.
>
Super. Thanks.
