Date: Thu, 4 May 2017 08:47:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170504154717.GA24353@infradead.org>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
Subject: [kernel-hardening] Re: [RFC, PATCH] x86_64: KAISER - do not map kernel in user mode
To: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: kernel list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, kirill.shutemov@linux.intel.com, Ingo Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 04, 2017 at 12:02:47PM +0200, Daniel Gruss wrote:
> After several recent works [1,2,3] KASLR on x86_64 was basically considered
> dead by many researchers. We have been working on an efficient but effective
> fix for this problem and found that not mapping the kernel space when
> running in user mode is the solution to this problem [4] (the corresponding
> paper [5] will be presented at ESSoS17).

I'll try to read the paper.  In the meantime: how different is your
approach from then one here?

	https://lwn.net/Articles/39283/

and how different is the performance impact?
