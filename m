MIME-Version: 1.0
In-Reply-To: <20171121235920.GT7472@eros>
References: <1511251094.25970.18.camel@gmail.com> <20171121235920.GT7472@eros>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Wed, 22 Nov 2017 11:41:19 +0530
Message-ID: <CAPDLWs8G=drs5r-iHZ4YWfzFcD3YcHBJqJNLhGh2Yme=PjpssA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v1] scripts: leaking_addresses.pl: add support for 32-bit
 kernel addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Thanks Tobin, for your detailed comments.

On Wed, Nov 22, 2017 at 5:29 AM, Tobin C. Harding <me@tobin.cc> wrote:
> You don't typically need [xxx v1] for version 1, the v1 is implicit.
>
> Please use the git brief description prefix that is already in use i.e
>
>         leaking_addresses: add support for 32-bit kernel addresses

Ok..

> On Tue, Nov 21, 2017 at 01:28:14PM +0530, kaiwan.billimoria@gmail.com wrote:
>> - support for ARM-32
>
> Sure, we can do this later.

Righto

>
>> - programatically query and set the PAGE_OFFSET based on arch (it's currently
>> hard-coded)
>
> Let's do this straight away, it will be much nicer.

Yes, will work on it..

>> 2. Minor edit:
>> the '--raw', '--suppress-dmesg', '--squash-by-path' and
>> '--squash-by-filename' option switches are only meaningful
>> when the '----input-raw=' option is used. So, indent the 'Help' screen lines
>> to reflect the fact.
>
> This is a different change to the architecture stuff so should be in a
> separate patch. You could do both as a series if you like. Off the top
> of my head I have never seen options output like this, but if you have,
> I'm willing to accept your view. You are correct that the options
> mentioned are only use in conjuncture with '--input-raw' so some way of
> showing this would be nice.

I realize this; so, yeah, will make the next one a series and put this
in the 2nd..

>>
>> +my $bit_size = 64;   # Check 64-bit kernel addresses by default
>
> This global is unnecessary. You already have is_ix86_32() so you can just
> use that.

>From your later comments, I think you see that using this global is necessary.

> Please use kernel coding style
>
>                 $bit_size = 32;

Ok..

> Bonus points, you uncovered a bug in the current script `if (is_x86_64)`
> was missing the parenthesis!

Yeah :-)

>
>> +             if ($match =~ '\b(0x)?(f|F){8}\b') {
>> +                     return 1;
>> +             }
>
> So, may_leak_address() and is_false_positive() are tightly coupled and
> not really that nice. Once we add 32 bit support it gets worse. Going
> forwards, we can either add your 32 bit work then refactor both
> functions or you can refactor them as you add the 32 bit stuff. I'm open
> to either.

Yes I agree. Having said that, I'll leave it on the back burner for now..

>Some things to note
>
> - The mask stuff (all 1's) should have an all 0's regex also.

Well, once we determine the address is >= PAGE_OFFSET, it's
automatically apparent that it's not 0, yes?

> - The mask stuff should probably be closer to the mask stuff for 64
>   bit. It's not immediately apparent a clean way to do this though.
> - It's not immediately apparent if an address less that PAGE_OFFSET is a
>   false positive or should be caught in leaks_address().

Hmm only thing I can think of offhand- on many ARM-32's, the kernel
module space is below
PAGE_OFFSET; we'd have to take that into consideration of course.
Anything else < PAGE_OFFSET and a kernel address? Anyone?

> - Do we need 32 bit equivalents for
>
>         if ($line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b' or
>             $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
>
Ok am unclear on what exactly the above achieves.. could you pl throw
some light on it, thanks..

>
> Your patch did not apply, the problem looks to be in the code section
> above. You can see that there is no removed line. For next spin please
> check your patch applies on top of the 'leaks' branch (which now
> includes the fix for the bug you found).

Yes, sorry about that; will do..

> I have one more comment that should have been at the top but I did not
> want to confuse things. Typically, the git brief description should be
> limited to 50 characters. If you do decide to split this patch into two
> and use the prefix suggested you may like to change the git brief
> description but don't feel you have to. If you do decide to do this, your
> next patch set will be a version 1 again. I may be wrong but I never
> increment a patch version if the subject line changes (excluding
> contents of [] ).

Right. I plan to send the next one as a 2 patch series; will keep the
git prefix you suggest
(and as Sub changes, will not label the version).
>
> thanks,
> Tobin.

Thanks,
Kaiwan.
