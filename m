References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <20170504154717.GA24353@infradead.org>
 <f9a4e8ed-1b22-0d73-924c-f5bb1e18ba93@iaik.tugraz.at>
 <CAFLxGvwuMN52-Xf46j7XuG+cnJ9xnZjXWhihpgxr9_EUX0Z+Bg@mail.gmail.com>
From: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Message-ID: <cc75a38a-4ea6-e300-0370-882dfbfd7a23@iaik.tugraz.at>
Date: Sun, 7 May 2017 23:45:48 +0200
MIME-Version: 1.0
In-Reply-To: <CAFLxGvwuMN52-Xf46j7XuG+cnJ9xnZjXWhihpgxr9_EUX0Z+Bg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

> Just did a quick test on my main KVM host, a 8 core Intel(R) Xeon(R)
> CPU E3-1240 V2.
> KVM guests are 4.10 w/o CONFIG_KAISER and kvmconfig without CONFIG_PARAVIRT.
> Building a defconfig kernel within that guests is about 10% slower
> when CONFIG_KAISER
> is enabled.

Thank you for testing it! :)

> Is this expected?

It sounds plausible. First, I would expect any form of virtualization to 
increase the overhead. Second, for the processor (Ivy Bridge), I would 
have expected even higher performance overheads. KAISER utilizes very 
recent performance improvements in Intel processors...

> If it helps I can redo the same test also on bare metal.

I'm not sure how we proceed here and if this would help, because I don't 
know what everyone expects.
KAISER definitely introduces an overhead, no doubt about that. How much 
overhead it is depends on the specific hardware and may be very little 
on recent architectures and more on older machines.
We are not proposing to enable KAISER by default, but to provide the 
config option to allow easy integration into hardened kernels where 
performance overheads may be acceptable (which depends on the specific 
use case and the specific hardware).
