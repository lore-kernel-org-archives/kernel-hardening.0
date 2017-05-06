References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <CAJcbSZHcAi37FfFBKF4MsC3WM-RY5ar_e1pgMScb=S3+_-wqVQ@mail.gmail.com>
 <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
 <CAJcbSZEOMssjUoMUBmArNeuOPoZ0gQJmEQ_WQaSOPiHp1XcNaQ@mail.gmail.com>
 <01ebda5d918d9cbfd36d8ec4e6c12f55@cs.tu-darmstadt.de>
From: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Message-ID: <a7cc85fd-b261-0c83-8636-eb57c9ba71f9@iaik.tugraz.at>
Date: Sat, 6 May 2017 10:38:23 +0200
MIME-Version: 1.0
In-Reply-To: <01ebda5d918d9cbfd36d8ec4e6c12f55@cs.tu-darmstadt.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: David Gens <david.gens@cs.tu-darmstadt.de>, Thomas Garnier <thgarnie@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, clementine.maurice@iaik.tugraz.at, moritz.lipp@iaik.tugraz.at, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, anders.fogh@gdata-adan.de
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-05-06 06:02, David Gens wrote:
> Assuming that their patch indeed leaks per-cpu addresses.. it might not
> necessarily
> be required to change it.

I think we're not leaking them (unless we still have some bug in our 
code). The basic idea is that any part that is required for the context 
switch is at a fixed location (unrelated to the location of code / data 
/ per-cpu data / ...) and thus does not reveal any randomized offsets. 
Then the attacker cannot gain any knowledge through the side channel 
anymore.
For any attack the attacker could then only use the few KBs of memory 
that cannot be unmapped because of the way x86 works. Hardening these 
few KBs seems like an easier task than doing the same for the entire kernel.

(The best solution would of course be Intel introducing CR3A and CR3B 
just like ARM has TTBR0 and TTBR1 - on ARM this entirely prevents any 
prefetch / double-fault side-channel attacks.)
