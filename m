References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <20170504154717.GA24353@infradead.org>
From: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Message-ID: <f9a4e8ed-1b22-0d73-924c-f5bb1e18ba93@iaik.tugraz.at>
Date: Fri, 5 May 2017 09:40:05 +0200
MIME-Version: 1.0
In-Reply-To: <20170504154717.GA24353@infradead.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC, PATCH] x86_64: KAISER - do not map kernel in user mode
To: Christoph Hellwig <hch@infradead.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, kirill.shutemov@linux.intel.com, Ingo
 Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 04.05.2017 17:47, Christoph Hellwig wrote:
> I'll try to read the paper.  In the meantime: how different is your
> approach from then one here?
>
> 	https://lwn.net/Articles/39283/
>
> and how different is the performance impact?

The approach sounds very similar, but we have fewer changes because we 
don't want to change memory allocation but only split the virtual memory 
- everything can stay where it is.

We found that the CR3 switch seems to be significantly improved in 
modern microarchitectures (we performed our performance tests on a 
Skylake i7-6700K). We think the TLB maybe uses the full CR3 base address 
as a tag, relaxing the necessity of flushing the entire TLB upon CR3 
updates a bit.
Direct runtime overhead is switching the CR3, but that's it.
Indirectly, we're potentially increasing the number of TLB entries that 
are required on one or the other level of the TLB. For TLB-intense tasks 
this might lead to more significant performance penalties.

I'm sure the overhead on older systems is larger than on recent systems.
