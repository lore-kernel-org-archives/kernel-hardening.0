Date: Tue, 05 Dec 2017 15:31:20 -0500 (EST)
Message-Id: <20171205.153120.151025775956658954.davem@davemloft.net>
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdVZWUHNEbfO7OCPQV5Q3bA41c6VpwqfvT37ZEV9AR8chw@mail.gmail.com>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
	<1511921105-3647-4-git-send-email-me@tobin.cc>
	<CAMuHMdVZWUHNEbfO7OCPQV5Q3bA41c6VpwqfvT37ZEV9AR8chw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V11 3/5] printk: hash addresses printed with %p
To: geert@linux-m68k.org
Cc: me@tobin.cc, kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org, Jason@zx2c4.com, tytso@mit.edu, keescook@chromium.org, pbonzini@redhat.com, tycho@tycho.ws, william.c.roberts@intel.com, tj@kernel.org, Golden_Miller83@protonmail.ch, gregkh@linuxfoundation.org, pmladek@suse.com, joe@perches.com, ijc@hellion.org.uk, sergey.senozhatsky@gmail.com, catalin.marinas@arm.com, wilal.deacon@arm.com, rostedt@goodmis.org, cfries@google.com, olorin@google.com, danielmicay@gmail.com, tixxdz@gmail.com, rkrcmar@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, sfr@canb.auug.org.au, aryabinin@virtuozzo.com, glider@google.com, dvyukov@google.com, akpm@linux-foundation.org, sergei.shtylyov@cogentembedded.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 5 Dec 2017 21:20:57 +0100

> Hi Tobin,
> 
> On Wed, Nov 29, 2017 at 3:05 AM, Tobin C. Harding <me@tobin.cc> wrote:
>> Currently there exist approximately 14 000 places in the kernel where
>> addresses are being printed using an unadorned %p. This potentially
>> leaks sensitive information regarding the Kernel layout in memory. Many
>> of these calls are stale, instead of fixing every call lets hash the
>> address by default before printing. This will of course break some
>> users, forcing code printing needed addresses to be updated.
>>
>> Code that _really_ needs the address will soon be able to use the new
>> printk specifier %px to print the address.
> 
>> --- a/lib/vsprintf.c
>> +++ b/lib/vsprintf.c
> 
>> +/* Maps a pointer to a 32 bit unique identifier. */
>> +static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
>> +{
>> +       unsigned long hashval;
>> +       const int default_width = 2 * sizeof(ptr);
>> +
>> +       if (unlikely(!have_filled_random_ptr_key)) {
>> +               spec.field_width = default_width;
>> +               /* string length must be less than default_width */
>> +               return string(buf, end, "(ptrval)", spec);
>> +       }
>> +
>> +#ifdef CONFIG_64BIT
>> +       hashval = (unsigned long)siphash_1u64((u64)ptr, &ptr_key);
>> +       /*
>> +        * Mask off the first 32 bits, this makes explicit that we have
>> +        * modified the address (and 32 bits is plenty for a unique ID).
>> +        */
>> +       hashval = hashval & 0xffffffff;
>> +#else
>> +       hashval = (unsigned long)siphash_1u32((u32)ptr, &ptr_key);
>> +#endif
> 
> Would it make sense to keep the 3 lowest bits of the address?
> 
> Currently printed pointers no longer have any correlation with the actual
> alignment in memory of the object, which is a typical cause of a class of bugs.

Yeah, this is driving people nuts who wonder why pointers are aligned
all weird now.
