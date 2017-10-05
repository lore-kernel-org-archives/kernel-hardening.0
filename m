Message-ID: <1507163355.1273.63.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 04 Oct 2017 20:29:15 -0400
In-Reply-To: <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
	 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
	 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
	 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
	 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
	 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter
 options
To: Linus Torvalds <torvalds@linux-foundation.org>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>, "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-10-04 at 16:52 -0700, Linus Torvalds wrote:
> On Wed, Oct 4, 2017 at 2:58 PM, Roberts, William C
> <william.c.roberts@intel.com> wrote:
> > 
> > I agree with you 100% kptr restrict is odd, and I don't think anyone
> > should have had to opt in to be
> > cleansed via kptr_restrict value via %pK. Opt-in never works. One
> > nice thing now, is that checkpatch
> > has checking of %p usages and warns.
> 
> Yeah, the checkpatch thing may help for future patches.
> 
> > As far as broken things, I can't comment on desktop systems where I
> > think it's harder to make that claim.
> > I see value in embedded systems where I am shipping the whole image,
> > So I know when/what will
> > break.
> > 
> > If this was in-tree, Android would be setting this to 4 immediately
> > FWIW.
> 
> Does android set it to 2 right now?

Yes, as the universal baseline.

On Google Pixels it's set to this 4 level since August (Android 8.0)
which indicates they plan on moving to that universally.

They only allow dmesg access for core system services so I think their
concern is with formatted strings leaking it elsewhere, not to dmesg.

These are the only services they allow to read dmesg:

private/system_server.te:  allow system_server kernel:system syslog_read;
public/dumpstate.te:allow dumpstate kernel:system syslog_read;
public/init.te:allow init kernel:system syslog_read;
public/logd.te:allow logd kernel:system syslog_read;
public/recovery.te:  allow recovery kernel:system syslog_read;

logd doesn't read it in production builds, but even when it does in
engineering builds it only gives out access to privileged apps with
READ_LOGS which isn't something a third party app can obtain.
