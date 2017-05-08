References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <CAJcbSZHcAi37FfFBKF4MsC3WM-RY5ar_e1pgMScb=S3+_-wqVQ@mail.gmail.com>
 <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
 <CAJcbSZEOMssjUoMUBmArNeuOPoZ0gQJmEQ_WQaSOPiHp1XcNaQ@mail.gmail.com>
 <01ebda5d918d9cbfd36d8ec4e6c12f55@cs.tu-darmstadt.de>
 <a7cc85fd-b261-0c83-8636-eb57c9ba71f9@iaik.tugraz.at>
From: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Message-ID: <62c69fb5-03a8-4f30-cbc1-4955e9efbb18@iaik.tugraz.at>
Date: Mon, 8 May 2017 15:53:20 +0200
MIME-Version: 1.0
In-Reply-To: <a7cc85fd-b261-0c83-8636-eb57c9ba71f9@iaik.tugraz.at>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: David Gens <david.gens@cs.tu-darmstadt.de>, Thomas Garnier <thgarnie@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, clementine.maurice@iaik.tugraz.at, moritz.lipp@iaik.tugraz.at, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, anders.fogh@gdata-adan.de
List-ID: <kernel-hardening.lists.openwall.com>

On 06.05.2017 10:38, Daniel Gruss wrote:
> On 2017-05-06 06:02, David Gens wrote:
>> Assuming that their patch indeed leaks per-cpu addresses.. it might not
>> necessarily
>> be required to change it.
>
> I think we're not leaking them (unless we still have some bug in our code).

Just to correct my answer here as well: Although we experimented with fixed mappings for per-cpu addresses, the current 
patch does not incorporate this yet, so it indeed still leaks. However, it is not a severe problem. The mapping of the 
required (per-cpu) variables would be at a fixed location in the user CR3, instead of the ones that are used in the kernel.
