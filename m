References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <20170504154717.GA24353@infradead.org>
 <f9a4e8ed-1b22-0d73-924c-f5bb1e18ba93@iaik.tugraz.at>
 <CAFLxGvwuMN52-Xf46j7XuG+cnJ9xnZjXWhihpgxr9_EUX0Z+Bg@mail.gmail.com>
 <cc75a38a-4ea6-e300-0370-882dfbfd7a23@iaik.tugraz.at>
 <6013bf3f-c3bd-3836-e5e2-ea89cc2e556a@nod.at>
 <8aecf7d4-9767-5367-1bc0-75fbd4b17e46@iaik.tugraz.at>
 <07322e2c-e95f-ea35-bc1f-7b05c082e287@gdata-adan.de>
From: Richard Weinberger <richard@nod.at>
Message-ID: <22a14b06-9489-3494-bbb7-428d4e5fa186@nod.at>
Date: Tue, 9 May 2017 16:57:28 +0200
MIME-Version: 1.0
In-Reply-To: <07322e2c-e95f-ea35-bc1f-7b05c082e287@gdata-adan.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC, PATCH] x86_64: KAISER - do not
 mapkernel in user mode
To: "Fogh, Anders" <anders.fogh@gdata-adan.de>, Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: Christoph Hellwig <hch@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Am 09.05.2017 um 16:44 schrieb Fogh, Anders:
>>> i.e. how does it perform on recent AMD systems?
> 
> Sorry for the latency. Recent AMD is reported by Enrique Nissem to not
> be vulnerable to the prefetch attack. TSX attack doesn't apply to AMD.
> Hund, Willems & Holz wrote in 2013 that AMD was vulnerable to that
> attack. The BTB is almost surely working in a different manner of
> fashion if at all. So AMD may or may not be vulnerable to the DPF
> attack, but none of the modern attacks should work - at least out of the
> box.

But the promoted patch will also run on AMD systems, that's why I asked
for the overhead.

Thanks,
//richard
