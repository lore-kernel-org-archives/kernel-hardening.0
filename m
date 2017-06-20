MIME-Version: 1.0
Sender: joel.stan@gmail.com
In-Reply-To: <20170620060344.ngbnzg2mz5hvq4kw@thunk.org>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org>
From: Joel Stanley <joel@jms.id.au>
Date: Tue, 20 Jun 2017 15:57:53 +0930
Message-ID: <CACPK8Xd+RXu5gT9yA3TK-Y+1n5m4BYkgLDonNGh5tkHog9M5pA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH] random: silence compiler warnings
 and fix race
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 3:33 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 19, 2017 at 10:57:18PM +0200, Jason A. Donenfeld wrote:
>>
>> With rc6 already released and rc7 coming up, I'd really appreciate you
>> stepping in here and either ACKing the above commit, or giving your
>> two cents about it in case I need to roll something different.
>
> I actually had set up an earlier version of your patch for on Saturday
> while I was in Beijing.  (Like Linus, I'm attending the LinuxCon China
> conference Monday and Tuesday.)  I had even created the signed tag,
> but I didn't send the pull request to Linus because I was waiting to
> see about how discussions over the locking strategy and the spammy log
> messages on PowerPC was going to get resolved.
>
> I've since respun the commit to reflect your newer patch (see the
> random_for_linus_stable tag on random.git) and rebased the dev branch
> on top of that.  Please take a look and comment.
>
> The other open issue I want to resolve before sending a pull request
> this week is whether we want to change the default for
> CONFIG_WARN_UNSEEDED_RANDOM so that the answer is 'n'.  It *is* spammy
> for PowerPC, because they aren't getting their CRNG initialized
> quickly enough, so several userspace processes are getting
> fork/exec'ed with an uninitialized CRNG.

It's very spammy for ARM as well. I booted next-20170619 on an Aspeed
(32-bit ARM) board and by the time I made it to a shell the log buffer
contained only warnings:

[   10.452921] random: arch_pick_mmap_layout+0xa8/0xe8 get_random_u32
called with crng_init=0
[   10.461255] random: load_elf_binary+0x3c8/0x104c get_random_u32
called with crng_init=0
[   10.471464] random: arch_setup_additional_pages+0x6c/0x110
get_random_u32 called with crng_init=0
[   10.480429] random: randomize_page+0x44/0x58 get_random_u32 called
with crng_init=0
[   10.494802] random: arch_pick_mmap_layout+0xa8/0xe8 get_random_u32
called with crng_init=0
[   10.503141] random: load_elf_binary+0x3c8/0x104c get_random_u32
called with crng_init=0
[   10.511571] random: arch_setup_additional_pages+0x6c/0x110
get_random_u32 called with crng_init=0
[   10.520527] random: randomize_page+0x44/0x58 get_random_u32 called
with crng_init=0
[   10.537847] random: arch_pick_mmap_layout+0xa8/0xe8 get_random_u32
called with crng_init=0
[   10.546182] random: load_elf_binary+0x3c8/0x104c get_random_u32
called with crng_init=0
[   10.554611] random: arch_setup_additional_pages+0x6c/0x110
get_random_u32 called with crng_init=0
[   10.563563] random: randomize_page+0x44/0x58 get_random_u32 called
with crng_init=0

So +1 for defaulting CONFIG_WARN_UNSEEDED_RANDOM=n.

Cheers,

Joel


> That being said, it is a
> valid warning because it means that the initial stack canary for the
> first couple of PowerPC processes are being created without a fully
> initialized CRNG, which may mean that an attacker might be able to
> circumvent the stack canary on the first couple of processes.  So that
> could potentially be a real security issue on Power.  OTOH, most Power
> users aren't going to be able to do anything about the fact the stack
> canaries of the system daemons started during early boot don't have
> strong randomness, so perhaps we should disable the warning by
> default.
>
> Opinions?
>
>                                                 - Ted
