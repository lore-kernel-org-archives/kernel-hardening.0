MIME-Version: 1.0
In-Reply-To: <CA+55aFxhnwjyLsVc54UVKCSm+-DSkOar5XV919J-Cg6i3NXC5Q@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com> <CA+55aFxhnwjyLsVc54UVKCSm+-DSkOar5XV919J-Cg6i3NXC5Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Oct 2017 08:55:26 -0500
Message-ID: <CAErSpo4JfDPUnK4LhU=5GN7KVhWRatcEnu5VCsMwrEh6f9St5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 7:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Oct 4, 2017 at 4:52 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> It also shows
>>
>>     software IO TLB [mem PA-PB] (64MB) mapped at [VA-VB]
>>
>> for example.  And THIS IS IMPORTANT! The physical address is shown
>> with "%#010llx".
>
> Oh, and I added Tejun for the percpu printout, but didn't add Bjorn
> for this one.
>
> Like the percpu one, I suspect that this pr_info() isn't really
> important enough to stay, and while it doesn't sound nearly as
> interesting as the percpu virtual address to an attacker, it probably
> isn't important enough to leak kernel (and hardware) data for.
>
> Bjorn?

My only interest in the "software IO TLB" message was to make the
style match other similar things; I personally don't care whether this
message exists at all.

I haven't seen the whole series, but I do hope %pR remains useful.  We
use it often to analyze PCI BAR assignment issues.

Bjorn
