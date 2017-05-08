References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <CAJcbSZHcAi37FfFBKF4MsC3WM-RY5ar_e1pgMScb=S3+_-wqVQ@mail.gmail.com>
 <55fa194e-69bd-fe39-f915-6f77673aea36@iaik.tugraz.at>
 <CAJcbSZEOMssjUoMUBmArNeuOPoZ0gQJmEQ_WQaSOPiHp1XcNaQ@mail.gmail.com>
 <01ebda5d918d9cbfd36d8ec4e6c12f55@cs.tu-darmstadt.de>
 <a7cc85fd-b261-0c83-8636-eb57c9ba71f9@iaik.tugraz.at>
 <20170508102100.GA5480@leverpostej>
 <db80ae9d-15bc-5d32-afce-ea98a6059fb8@iaik.tugraz.at>
 <20170508132235.GC5480@leverpostej>
From: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Message-ID: <f599b1b6-38b3-71a7-5814-3f7fea7a7038@iaik.tugraz.at>
Date: Mon, 8 May 2017 15:43:28 +0200
MIME-Version: 1.0
In-Reply-To: <20170508132235.GC5480@leverpostej>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Mark Rutland <mark.rutland@arm.com>
Cc: David Gens <david.gens@cs.tu-darmstadt.de>, Thomas Garnier <thgarnie@google.com>, kernel list <linux-kernel@vger.kernel.org>, Kernel
 Hardening <kernel-hardening@lists.openwall.com>, clementine.maurice@iaik.tugraz.at, moritz.lipp@iaik.tugraz.at, Michael
 Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, anders.fogh@gdata-adan.de
List-ID: <kernel-hardening.lists.openwall.com>

On 08.05.2017 15:22, Mark Rutland wrote:
> Specifically, I think this does not align with the statement in 2.1
> regarding the two TTBRs:
>
>   This simplifies privilege checks and does not require any address
>   translation for invalid memory accesses and thus no cache lookups.
>
> ... since the use of the TTBRs is orthogonal to privilege checks and/or
> the design of the TLBs.

Ok, this is a good point, we will try to clarify this in the paper.
