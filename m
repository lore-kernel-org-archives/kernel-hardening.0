Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAHmME9p+xEBTKz+Wfy5Ypav4HU7H+rnA-0hLgd1sMmthDzOmvw@mail.gmail.com>
References: <8ea3fdff-23c4-b81d-2588-44549bd2d8c1@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB02401ED@AcuExch.aculab.com>
 <707472e1-b385-836d-c4c6-791c1dcc0776@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB02402C0@AcuExch.aculab.com>
 <0f3c3694-c00b-aae2-5b08-25bc64bf6372@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB0240437@AcuExch.aculab.com>
 <f6813084-6f46-0b22-e9c3-97b2e266f8f6@stressinduktion.org>
 <063D6719AE5E284EB5DD2968C1650D6DB0240529@AcuExch.aculab.com>
 <924ef794-eae0-2a6b-508b-069718339edc@stressinduktion.org>
 <CAHmME9pTLFu3-4n6m_OMj5jVWGE-+yC-4CnkynD--H4Nt8_cpA@mail.gmail.com>
 <20161215210933.GY3207@twins.programming.kicks-ass.net> <CAHmME9p+xEBTKz+Wfy5Ypav4HU7H+rnA-0hLgd1sMmthDzOmvw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Dec 2016 13:14:16 -0800
Message-ID: <CA+55aFzxY9n13an-axtzCkHM+HdjOXb9Kai4QOMxyce_kXFRXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/4] siphash: add
 cryptographically secure hashtable function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hannes Frederic Sowa <hannes@stressinduktion.org>, David Laight <David.Laight@aculab.com>, Netdev <netdev@vger.kernel.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "Daniel J . Bernstein" <djb@cr.yp.to>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 15, 2016 at 1:11 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Indeed, I stand corrected. But in any case, the use of __aligned(8) in
> the patchset ensures that things are fixed and that we don't have this
> issue.

I think you can/should just use the natural alignment for "u64".

For architectures that need 8-byte alignment, u64 will already be
properly aligned. For architectures (like x86-32) that only need
4-byte alignment, you get it.

              Linus
