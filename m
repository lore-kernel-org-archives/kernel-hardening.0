Reply-To: kernel-hardening@lists.openwall.com
References: <20161214035927.30004-1-Jason@zx2c4.com>
 <CAHmME9q9ffdtWRbzyMO1ktTdtEFdfumTfojTTNLXFhoa+R+MWQ@mail.gmail.com>
 <8ea3fdff-23c4-b81d-2588-44549bd2d8c1@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB02401ED@AcuExch.aculab.com>
 <707472e1-b385-836d-c4c6-791c1dcc0776@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB02402C0@AcuExch.aculab.com>
 <0f3c3694-c00b-aae2-5b08-25bc64bf6372@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB0240437@AcuExch.aculab.com>
 <f6813084-6f46-0b22-e9c3-97b2e266f8f6@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB0240529@AcuExch.aculab.com>
 <924ef794-eae0-2a6b-508b-069718339edc@stressinduktion.org>
 <CAHmME9pTLFu3-4n6m_OMj5jVWGE-+yC-4CnkynD--H4Nt8_cpA@mail.gmail.com>
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Message-ID: <18d1e9d1-1e52-b9a6-de26-2f33859ec052@stressinduktion.org>
Date: Thu, 15 Dec 2016 21:31:20 +0100
MIME-Version: 1.0
In-Reply-To: <CAHmME9pTLFu3-4n6m_OMj5jVWGE-+yC-4CnkynD--H4Nt8_cpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/4] siphash: add cryptographically secure hashtable
 function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, David Laight <David.Laight@aculab.com>
Cc: Netdev <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "Daniel J . Bernstein" <djb@cr.yp.to>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hello,

On 15.12.2016 19:50, Jason A. Donenfeld wrote:
> Hi David & Hannes,
> 
> This conversation is veering off course.

Why?

> I think this doesn't really
> matter at all. Gcc converts u64 into essentially a pair of u32 on
> 32-bit platforms, so the alignment requirements for 32-bit is at a
> maximum 32 bits. On 64-bit platforms the alignment requirements are
> related at a maximum to the biggest register size, so 64-bit
> alignment. For this reason, no matter the behavior of __aligned(8),
> we're okay. Likewise, even without __aligned(8), if gcc aligns structs
> by their biggest member, then we get 4 byte alignment on 32-bit and 8
> byte alignment on 64-bit, which is fine. There's no 32-bit platform
> that will trap on a 64-bit unaligned access because there's no such
> thing as a 64-bit access there. In short, we're fine.

ARM64 and x86-64 have memory operations that are not vector operations
that operate on 128 bit memory.

How do you know that the compiler for some architecture will not chose a
more optimized instruction to load a 64 bit memory value into two 32 bit
registers if you tell the compiler it is 8 byte aligned but it actually
isn't? I don't know the answer but telling the compiler some data is 8
byte aligned while it isn't really pretty much seems like a call for
trouble.

Why can't a compiler not vectorize this code if it can prove that it
doesn't conflict with other register users?

Bye,
Hannes
