MIME-Version: 1.0
In-Reply-To: <201706080107.xhkKszte%fengguang.wu@intel.com>
References: <20170606005108.5646-4-Jason@zx2c4.com> <201706080107.xhkKszte%fengguang.wu@intel.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 7 Jun 2017 20:16:05 +0200
Message-ID: <CAHmME9qp5J6yhj+TYtZEhC-snqWB85gdYQ1=-eUysaYT8BkgwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 03/13] random: invalidate batched entropy after crng init
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Strange, not all compilers do this warning. Fixing with:

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 12758db..5252690 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2061,8 +2061,8 @@ static DEFINE_PER_CPU(struct batched_entropy,
batched_entropy_u64);
u64 get_random_u64(void)
{
       u64 ret;
-       bool use_lock = crng_init < 2;
-       unsigned long flags;
+       const bool use_lock = READ_ONCE(crng_init) < 2;
+       unsigned long flags = 0;
       struct batched_entropy *batch;

#if BITS_PER_LONG == 64
@@ -2099,8 +2099,8 @@ static DEFINE_PER_CPU(struct batched_entropy,
batched_entropy_u32);
u32 get_random_u32(void)
{
       u32 ret;
-       bool use_lock = crng_init < 2;
-       unsigned long flags;
+       const bool use_lock = READ_ONCE(crng_init) < 2;
+       unsigned long flags = 0;
       struct batched_entropy *batch;

       if (arch_get_random_int(&ret))

Const, because it's more correct. READ_ONCE to be certain that the
compiler doesn't try to paste the expression into both uses. And
finally flags=0 to shutup the compiler.

If anybody has a better way of approaching this, feel free to chime in.
