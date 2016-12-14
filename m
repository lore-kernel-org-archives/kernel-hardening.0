Reply-To: kernel-hardening@lists.openwall.com
References: <20161214035927.30004-1-Jason@zx2c4.com>
 <CAHmME9q9ffdtWRbzyMO1ktTdtEFdfumTfojTTNLXFhoa+R+MWQ@mail.gmail.com>
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Message-ID: <8ea3fdff-23c4-b81d-2588-44549bd2d8c1@stressinduktion.org>
Date: Wed, 14 Dec 2016 23:03:26 +0100
MIME-Version: 1.0
In-Reply-To: <CAHmME9q9ffdtWRbzyMO1ktTdtEFdfumTfojTTNLXFhoa+R+MWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/4] siphash: add cryptographically secure hashtable
 function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, David Laight <David.Laight@aculab.com>
Cc: Netdev <netdev@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "Daniel J . Bernstein" <djb@cr.yp.to>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 14.12.2016 13:46, Jason A. Donenfeld wrote:
> Hi David,
> 
> On Wed, Dec 14, 2016 at 10:56 AM, David Laight <David.Laight@aculab.com> wrote:
>> ...
>>> +u64 siphash24(const u8 *data, size_t len, const u8 key[SIPHASH24_KEY_LEN])
>> ...
>>> +     u64 k0 = get_unaligned_le64(key);
>>> +     u64 k1 = get_unaligned_le64(key + sizeof(u64));
>> ...
>>> +             m = get_unaligned_le64(data);
>>
>> All these unaligned accesses are going to get expensive on architectures
>> like sparc64.
> 
> Yes, the unaligned accesses aren't pretty. Since in pretty much all
> use cases thus far, the data can easily be made aligned, perhaps it
> makes sense to create siphash24() and siphash24_unaligned(). Any
> thoughts on doing something like that?

I fear that the alignment requirement will be a source of bugs on 32 bit
machines, where you cannot even simply take a well aligned struct on a
stack and put it into the normal siphash(aligned) function without
adding alignment annotations everywhere. Even blocks returned from
kmalloc on 32 bit are not aligned to 64 bit.

Can we do this a runtime check and just have one function (siphash)
dealing with that?

Bye,
Hannes
