From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <67c090b8-926a-1637-c335-863c068e62d0@gmail.com>
References: <1510050731-32446-1-git-send-email-me@tobin.cc> <87k1z12cof.fsf@concordia.ellerman.id.au> <7fa01b32-4db0-3742-067b-955969020953@gmail.com> <87o9o7wwbl.fsf@concordia.ellerman.id.au> <67c090b8-926a-1637-c335-863c068e62d0@gmail.com>
Date: Mon, 13 Nov 2017 12:06:51 +1100
Message-ID: <87tvxzvvf8.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Frank Rowand <frowand.list@gmail.com>, "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Frank Rowand <frowand.list@gmail.com> writes:
> Hi Michael,
>
> On 11/12/17 03:49, Michael Ellerman wrote:
...
>> 
>> On our bare metal machines the device tree comes from skiboot
>> (firmware), with some of the content provided by hostboot (other
>> firmware), both of which are open source, so in theory most of the
>> information is available in *some* source tree. But there's still
>> information about runtime allocations etc. that is not available in the
>> source anywhere.
>
> Thanks for the additional information. 
>
> Can you explain a little bit what "runtime allocations" are?  Are you
> referring to the memory reservation block, the memory node(s) and the
> chosen node?  Or other information?

Yeah I was thinking of memory reservations. They're under the
reserved-memory node as well as the reservation block, eg:

$ ls -1 /proc/device-tree/reserved-memory/
ibm,firmware-allocs-memory@1000000000
ibm,firmware-allocs-memory@1800000000
ibm,firmware-allocs-memory@39c00000
ibm,firmware-allocs-memory@800000000
ibm,firmware-code@30000000
ibm,firmware-data@31000000
ibm,firmware-heap@30300000
ibm,firmware-stacks@31c00000
ibm,hbrt-code-image@1ffd510000
ibm,hbrt-target-image@1ffd6a0000
ibm,hbrt-vpd-image@1ffd700000
ibm,slw-image@1ffda00000
ibm,slw-image@1ffde00000
ibm,slw-image@1ffe200000
ibm,slw-image@1ffe600000


There's also some new systems where a catalog of PMU events is stored in
flash as a DTB and then stitched into the device tree by skiboot before
booting Linux.

Anyway my point was mainly just that the device tree is not simply a
copy of something in the kernel source.

cheers
