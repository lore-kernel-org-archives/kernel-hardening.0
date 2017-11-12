From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <7fa01b32-4db0-3742-067b-955969020953@gmail.com>
References: <1510050731-32446-1-git-send-email-me@tobin.cc> <87k1z12cof.fsf@concordia.ellerman.id.au> <7fa01b32-4db0-3742-067b-955969020953@gmail.com>
Date: Sun, 12 Nov 2017 22:49:50 +1100
Message-ID: <87o9o7wwbl.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Frank Rowand <frowand.list@gmail.com>, "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Frank,

Frank Rowand <frowand.list@gmail.com> writes:
> Hi Michael, Tobin,
>
> On 11/08/17 04:10, Michael Ellerman wrote:
>> "Tobin C. Harding" <me@tobin.cc> writes:
>>> Currently we are leaking addresses from the kernel to user space. This
>>> script is an attempt to find some of those leakages. Script parses
>>> `dmesg` output and /proc and /sys files for hex strings that look like
>>> kernel addresses.
>>>
>>> Only works for 64 bit kernels, the reason being that kernel addresses
>>> on 64 bit kernels have 'ffff' as the leading bit pattern making greping
>>> possible.
>> 
>> That doesn't work super well on other architectures :D
>> 
>> I don't speak perl but presumably you can check the arch somehow and
>> customise the regex?
>> 
>> ...
>>> +# Return _all_ non false positive addresses from $line.
>>> +sub extract_addresses
>>> +{
>>> +        my ($line) = @_;
>>> +        my $address = '\b(0x)?ffff[[:xdigit:]]{12}\b';
>> 
>> On 64-bit powerpc (ppc64/ppc64le) we'd want:
>> 
>> +        my $address = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
>> 
>> 
>>> +# Do not parse these files (absolute path).
>>> +my @skip_parse_files_abs = ('/proc/kmsg',
>>> +			    '/proc/kcore',
>>> +			    '/proc/fs/ext4/sdb1/mb_groups',
>>> +			    '/proc/1/fd/3',
>>> +			    '/sys/kernel/debug/tracing/trace_pipe',
>>> +			    '/sys/kernel/security/apparmor/revision');
>> 
>> Can you add:
>> 
>>   /sys/firmware/devicetree
>> 
>> and/or /proc/device-tree (which is a symlink to the above).
>
> /proc/device-tree is a symlink to /sys/firmware/devicetree/base

Oh yep, forgot about the base part.

> /sys/firmware contains
>    fdt              -- the flattened device tree that was passed to the
>                        kernel on boot
>    devicetree/base/ -- the data that is currently in the live device tree.
>                        This live device tree is represented as directories
>                        and files beneath base/
>
> The information in fdt is directly available in the kernel source tree

On ARM that might be true, but not on powerpc.

Remember FDT comes from DT which comes from OF - in which case the
information is definitely not in the kernel source! :)

On our bare metal machines the device tree comes from skiboot
(firmware), with some of the content provided by hostboot (other
firmware), both of which are open source, so in theory most of the
information is available in *some* source tree. But there's still
information about runtime allocations etc. that is not available in the
source anywhere.

cheers
