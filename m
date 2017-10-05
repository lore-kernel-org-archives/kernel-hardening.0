MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1507163355.1273.63.camel@gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com> <1507163355.1273.63.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 4 Oct 2017 17:35:42 -0700
Message-ID: <CAGXu5j+R0-_k0jWHMWxxytEUgmJDxKyifjj5gC13dMebSLQ3Vw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Daniel Micay <danielmicay@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 5:29 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> On Wed, 2017-10-04 at 16:52 -0700, Linus Torvalds wrote:
>> On Wed, Oct 4, 2017 at 2:58 PM, Roberts, William C
>> <william.c.roberts@intel.com> wrote:
>> >
>> > I agree with you 100% kptr restrict is odd, and I don't think anyone
>> > should have had to opt in to be
>> > cleansed via kptr_restrict value via %pK. Opt-in never works. One
>> > nice thing now, is that checkpatch
>> > has checking of %p usages and warns.
>>
>> Yeah, the checkpatch thing may help for future patches.
>>
>> > As far as broken things, I can't comment on desktop systems where I
>> > think it's harder to make that claim.
>> > I see value in embedded systems where I am shipping the whole image,
>> > So I know when/what will
>> > break.
>> >
>> > If this was in-tree, Android would be setting this to 4 immediately
>> > FWIW.
>>
>> Does android set it to 2 right now?
>
> Yes, as the universal baseline.
>
> On Google Pixels it's set to this 4 level since August (Android 8.0)
> which indicates they plan on moving to that universally.

Yup, which is what triggered working to upstream a solution. (As
mentioned in the changelogs, this series has gone through a number of
hands including Intel and Google folks.)

> They only allow dmesg access for core system services so I think their
> concern is with formatted strings leaking it elsewhere, not to dmesg.

One of the paths is via seq_file and it's many outputs in procfs,
debugfs, etc etc. The %x issue exists there too, but it's relatively
rare compared to %p and family.

Just looking at the %p case, an alternative might be to follow
grsecurity's method here, which is to examine where v*printf is
writing. They perform the censorship in the case of seq_file buffers,
or memory destined for userspace.

-Kees

-- 
Kees Cook
Pixel Security
