From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-14-Jason@zx2c4.com> <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
Date: Thu, 15 Jun 2017 21:03:48 +1000
Message-ID: <871sqlpl63.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel uses unseeded randomness
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Theodore Ts'o <tytso@mit.edu> writes:
> On Tue, Jun 06, 2017 at 07:48:04PM +0200, Jason A. Donenfeld wrote:
>> This enables an important dmesg notification about when drivers have
>> used the crng without it being seeded first. Prior, these errors would
>> occur silently, and so there hasn't been a great way of diagnosing these
>> types of bugs for obscure setups. By adding this as a config option, we
>> can leave it on by default, so that we learn where these issues happen,
>> in the field, will still allowing some people to turn it off, if they
>> really know what they're doing and do not want the log entries.
...
>
> This patch is pretty spammy.  On my KVM test kernel:
>
> random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
> random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
> random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
> random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
...
>
> At the very least we probably should do a logical "uniq" on the output
> (e.g., if we have complained about the previous callsite, don't whinge
> about it again).
>
> commit 9d9035bc6d7871a73d7f9aada4e63cb190874a68
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu Jun 8 04:16:59 2017 -0400
>
>     random: suppress duplicate crng_init=0 warnings
>     
>     Suppress duplicate CONFIG_WARN_UNSEEDED_RANDOM warnings to avoid
>     spamming dmesg.
>     
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Even with this patch, it's still pretty spammy (today's linux-next):

 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_randomize_brk+0xa4/0xd0 get_random_u64 called with crng_init=0
 random: arch_mmap_rnd+0x78/0xb0 get_random_u64 called with crng_init=0
 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_randomize_brk+0xa4/0xd0 get_random_u64 called with crng_init=0
 random: arch_mmap_rnd+0x78/0xb0 get_random_u64 called with crng_init=0
 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_randomize_brk+0xa4/0xd0 get_random_u64 called with crng_init=0
 random: arch_mmap_rnd+0x78/0xb0 get_random_u64 called with crng_init=0
 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_randomize_brk+0xa4/0xd0 get_random_u64 called with crng_init=0
 random: arch_mmap_rnd+0x78/0xb0 get_random_u64 called with crng_init=0
 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_mmap_rnd+0x78/0xb0 get_random_u64 called with crng_init=0
 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_randomize_brk+0xa4/0xd0 get_random_u64 called with crng_init=0
 Initializing random number generator... random: arch_mmap_rnd+0x78/0xb0 get_random_u64 called with crng_init=0
 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_randomize_brk+0xa4/0xd0 get_random_u64 called with crng_init=0
 random: arch_mmap_rnd+0x78/0xb0 get_random_u64 called with crng_init=0
 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_randomize_brk+0xa4/0xd0 get_random_u64 called with crng_init=0
 random: arch_mmap_rnd+0x78/0xb0 get_random_u64 called with crng_init=0
 random: load_elf_binary+0x57c/0x1550 get_random_u64 called with crng_init=0
 random: arch_randomize_brk+0xa4/0xd0 get_random_u64 called with crng_init=0


Do I need to be doing anything to fix these? (this is on powerpc)

cheers
