Reply-To: kernel-hardening@lists.openwall.com
References: <707472e1-b385-836d-c4c6-791c1dcc0776@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB02402C0@AcuExch.aculab.com>
 <0f3c3694-c00b-aae2-5b08-25bc64bf6372@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB0240437@AcuExch.aculab.com>
 <f6813084-6f46-0b22-e9c3-97b2e266f8f6@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB0240529@AcuExch.aculab.com>
 <924ef794-eae0-2a6b-508b-069718339edc@stressinduktion.org>
 <CAHmME9pTLFu3-4n6m_OMj5jVWGE-+yC-4CnkynD--H4Nt8_cpA@mail.gmail.com>
 <18d1e9d1-1e52-b9a6-de26-2f33859ec052@stressinduktion.org>
 <CAHmME9rDCb=2rojJba13Uew9V9qAbxv1qcJGHwEAKoahxyE9QA@mail.gmail.com>
 <20161215210425.GX3207@twins.programming.kicks-ass.net>
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Message-ID: <2a5f162b-71b1-588f-8546-23b6431aac8e@stressinduktion.org>
Date: Thu, 15 Dec 2016 22:09:16 +0100
MIME-Version: 1.0
In-Reply-To: <20161215210425.GX3207@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/4] siphash: add cryptographically secure hashtable
 function
To: Peter Zijlstra <peterz@infradead.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: David Laight <David.Laight@aculab.com>, Netdev <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "Daniel J . Bernstein" <djb@cr.yp.to>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 15.12.2016 22:04, Peter Zijlstra wrote:
> On Thu, Dec 15, 2016 at 09:43:04PM +0100, Jason A. Donenfeld wrote:
>> On Thu, Dec 15, 2016 at 9:31 PM, Hannes Frederic Sowa
>> <hannes@stressinduktion.org> wrote:
>>> ARM64 and x86-64 have memory operations that are not vector operations
>>> that operate on 128 bit memory.
>>
>> Fair enough. imull I guess.
> 
> imull is into rdx:rax, not memory. I suspect he's talking about
> cmpxchg16b.

Exactly and I think I saw a ll/sc 128 bit on armv8 to atomically
manipulate linked lists.

Bye,
Hannes
