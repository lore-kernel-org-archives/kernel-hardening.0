Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20140430161927.GW4963@mwanda>
References: <20140430150844.GA10621@mwanda>
	<CAGXu5jL+VLb_+ZJd6-L5P+Bdxmw+i7j2cLyPOT4rwfE6iqHuRA@mail.gmail.com>
	<20140430161927.GW4963@mwanda>
Date: Wed, 30 Apr 2014 09:44:26 -0700
Message-ID: <CAGXu5j+G778YMcbiW2cdeZ++0MDcTiNVOnm5E5W86vfKKDvUjg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [patch] lib: check for strcpy() overflows to fixed length buffers
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, devel@acpica.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 30, 2014 at 9:19 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Apr 30, 2014 at 08:33:21AM -0700, Kees Cook wrote:
>> On Wed, Apr 30, 2014 at 8:08 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > +#if CONFIG_DEBUG_STRICT_SLOW_STRCPY_CHECKS
>> > +#define strcpy(dest, src) do {                                         \
>> > +       int len = __compiletime_size(dest);                             \
>> > +       if (len > 1 && strlen(src) >= len)                              \
>> > +               WARN_ONCE(1, "strcpy() overflow copying \"%s\"\n", src);        \
>>
>> This should probably BUG. An overflowing strcpy shouldn't be allowed
>> to continue.
>
> I was worried about false positives.

Sure, good to be initially cautious but I think if this goes in, it should BUG.

> Speaking of false positives the STRICT checks on copy_from_user() have
> been disabled for a year now because of a three year old GCC bug.  I
> wonder if the GCC people realize the security impact it has.  See
> commit 2fb0815c9ee6 ('gcc4: disable __compiletime_object_size for GCC
> 4.6+') and http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48880

Yeah, lots of badness here. I'll see if I can find someone to look at
solutions for this.

>
>> > +config DEBUG_STRICT_SLOW_STRCPY_CHECKS
>> > +       bool "Strict checks for strcpy() overflows"
>> > +       depends on DEBUG_KERNEL
>> > +       help
>> > +         Enabling this option adds some extra sanity checks when strcpy() is
>> > +         called().  This will slow down the kernel a bit.
>>
>> Isn't this an entirely compile-time check? I would expect it to be
>> entirely optimized by the compiler. In fact, could this be turned into
>> a build failure instead?
>
> No.  The problem is when we don't know the size of the src string.  Also
> if GCC is able to find the compile time size of both the src and
> dest string then Smatch and other static checkers are able to as well so
> I'm not very concerned about that case because we already catch them.

Ah, right, the source. But that shouldn't make it "slow". How about
naming this DEBUG_STRICT_STRCPY_SIZE_CHECKS or something? I can't
imagine the performance from adding a single compare to be bad. You
can even branch-hint it with "if (unlikely(...."

-Kees

-- 
Kees Cook
Chrome OS Security
