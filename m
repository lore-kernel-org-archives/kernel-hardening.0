References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <20170504154717.GA24353@infradead.org>
 <f9a4e8ed-1b22-0d73-924c-f5bb1e18ba93@iaik.tugraz.at>
 <CAFLxGvwuMN52-Xf46j7XuG+cnJ9xnZjXWhihpgxr9_EUX0Z+Bg@mail.gmail.com>
 <cc75a38a-4ea6-e300-0370-882dfbfd7a23@iaik.tugraz.at>
 <6013bf3f-c3bd-3836-e5e2-ea89cc2e556a@nod.at>
From: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Message-ID: <8aecf7d4-9767-5367-1bc0-75fbd4b17e46@iaik.tugraz.at>
Date: Mon, 8 May 2017 00:18:14 +0200
MIME-Version: 1.0
In-Reply-To: <6013bf3f-c3bd-3836-e5e2-ea89cc2e556a@nod.at>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Hellwig <hch@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-05-08 00:02, Richard Weinberger wrote:
> Ahh, *very* recent is the keyword then. ;)
> I was a bit confused since in your paper the overhead is less than 1%.

Yes, only for very recent platforms (Skylake). While working on the 
paper we were surprised that we found overheads that small.

> What platforms did you test?

We tested it on multiple platforms for stability, but we only ran longer 
performance tests on different Skylake i7-6700K systems we mentioned in 
the paper.

> i.e. how does it perform on recent AMD systems?

Unfortunately, we don't have any AMD systems at hand. I'm also not sure 
how AMD is affected by the issue in the first place. Although unlikely, 
there is the possibility that the problem of KASLR information leakage 
through microarchitectural side channels might be Intel-specific.
