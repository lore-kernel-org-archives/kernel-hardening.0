Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161214035927.30004-1-Jason@zx2c4.com>
References: <20161214035927.30004-1-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 14 Dec 2016 13:46:05 +0100
Message-ID: <CAHmME9q9ffdtWRbzyMO1ktTdtEFdfumTfojTTNLXFhoa+R+MWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/4] siphash: add cryptographically secure hashtable function
To: David Laight <David.Laight@aculab.com>
Cc: Netdev <netdev@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "Daniel J . Bernstein" <djb@cr.yp.to>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi David,

On Wed, Dec 14, 2016 at 10:56 AM, David Laight <David.Laight@aculab.com> wrote:
> ...
>> +u64 siphash24(const u8 *data, size_t len, const u8 key[SIPHASH24_KEY_LEN])
> ...
>> +     u64 k0 = get_unaligned_le64(key);
>> +     u64 k1 = get_unaligned_le64(key + sizeof(u64));
> ...
>> +             m = get_unaligned_le64(data);
>
> All these unaligned accesses are going to get expensive on architectures
> like sparc64.

Yes, the unaligned accesses aren't pretty. Since in pretty much all
use cases thus far, the data can easily be made aligned, perhaps it
makes sense to create siphash24() and siphash24_unaligned(). Any
thoughts on doing something like that?

Jason
