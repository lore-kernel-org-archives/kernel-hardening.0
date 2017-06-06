MIME-Version: 1.0
In-Reply-To: <26642.1496743729@warthog.procyon.org.uk>
References: <20170606005108.5646-1-Jason@zx2c4.com> <20170606005108.5646-6-Jason@zx2c4.com>
 <26642.1496743729@warthog.procyon.org.uk>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 14:23:09 +0200
Message-ID: <CAHmME9qgfvZFFn8UVF=pckQj54W70hiZH6Kx4N+t85JdhrjMKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 05/13] security/keys: ensure RNG is seeded before use
To: David Howells <dhowells@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Safford <safford@us.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 12:08 PM, David Howells <dhowells@redhat.com> wrote:
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
>> +             key->serial = get_random_u32() >> 1;
>
> If this may sleep, it must be interruptible.

That won't sleep. I could have made it get_random_u32_wait(), but we'd
get into trouble at boottime. So instead, for now, I just use
get_random_u32 rather than get_random_bytes, which can use the
architectural random number generator, when the platform has one,
which is available early on.
