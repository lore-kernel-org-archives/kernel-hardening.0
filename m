Date: Tue, 6 Jun 2017 21:22:19 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170607042219.GC594@zzz>
References: <20170606215129.26388-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606215129.26388-1-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v2] security/keys: rewrite all of big_key crypto
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jason,

On Tue, Jun 06, 2017 at 11:51:29PM +0200, Jason A. Donenfeld wrote:
> issue now. And, some error paths forgot to zero out sensitive material, so
> this patch changes a kfree into a kzfree.

There are other places in big_key.c that should be doing kzfree() instead of
kfree().  Sorry, I actually recently did a patchset that fixed this for major
parts of the keyrings API, but I skipped the big_key type because it was one of
the more obscure key types (and frankly I have no idea what, if anything,
actually uses it).  Probably the switch to kzfree() should be its own patch
since it's a separate logical change.

>  {
>  	int ret = -EINVAL;
>  	struct scatterlist sgio;
> -	SKCIPHER_REQUEST_ON_STACK(req, big_key_skcipher);
> -
> -	if (crypto_skcipher_setkey(big_key_skcipher, key, ENC_KEY_SIZE)) {
> +	u8 req_on_stack[sizeof(struct aead_request) +
> +			crypto_aead_reqsize(big_key_aead)];
> +	struct aead_request *aead_req = (struct aead_request *)req_on_stack;
> +

The crypto API with CONFIG_VMAP_STACK=y and CONFIG_DEBUG_SG=y is unhappy with
using an aead_request on the stack, because it can't create a scatterlist from
it.  It will need to be on the heap instead.  (Or else the crypto API fixed.)

# cat .vimrc | keyctl padd big_key fred @s
[   43.687347] ------------[ cut here ]------------
[   43.692592] kernel BUG at ./include/linux/scatterlist.h:140!
[   43.697527] invalid opcode: 0000 [#1] SMP
[   43.700843] CPU: 0 PID: 219 Comm: keyctl Not tainted 4.12.0-rc4-next-20170606-xfstests-00003-gc6e36366c198 #120
[   43.707361] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
[   43.712167] task: ffff9ff6f97d8340 task.stack: ffffbd460049c000
[   43.714259] RIP: 0010:crypto_gcm_init_common+0x234/0x260
[   43.715786] RSP: 0018:ffffbd460049fac8 EFLAGS: 00010246
[   43.717031] RAX: 0000000000000000 RBX: ffffbd460049fba8 RCX: 0000000000000028
[   43.718688] RDX: 00001d4f4049fbb8 RSI: 000000000000001d RDI: ffffbd468049fbb8
[   43.720245] RBP: ffffbd460049fb00 R08: ffffbd460049fbd8 R09: ffffbd460049fbd8
[   43.721473] R10: 0000000000000000 R11: 0000000000000000 R12: ffffbd460049fbb8
[   43.722704] R13: 000000000000092f R14: ffffbd460049fb58 R15: ffffbd460049fba8
[   43.723927] FS:  00007f04df2f8700(0000) GS:ffff9ff6fe200000(0000) knlGS:0000000000000000
[   43.725262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.726065] CR2: 00007f04dec1a4c0 CR3: 000000003957e000 CR4: 00000000003406f0
[   43.727059] Call Trace:
[   43.727414]  crypto_gcm_encrypt+0x37/0xe0
[   43.727896]  big_key_crypt+0x106/0x160
[   43.728324]  big_key_preparse+0xc0/0x1d0
[   43.728784]  ? down_read+0x68/0xa0
[   43.729183]  key_create_or_update+0x13f/0x440
[   43.729688]  SyS_add_key+0xa1/0x1d0
[   43.730260]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[   43.730851] RIP: 0033:0x7f04dec22f19
[   43.731253] RSP: 002b:00007ffd622a0c88 EFLAGS: 00000206 ORIG_RAX: 00000000000000f8
[   43.732321] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f04dec22f19
[   43.733274] RDX: 0000000000606260 RSI: 00007ffd622a2866 RDI: 00007ffd622a285e
[   43.734192] RBP: 0000000000000000 R08: 00000000fffffffd R09: 000000000000001e
[   43.735026] R10: 000000000000092f R11: 0000000000000206 R12: 0000000000100000
[   43.735855] R13: 00007ffd622a0ca8 R14: 00007ffd622a0df8 R15: 0000000000404606
[   43.736690] Code: c8 01 48 89 83 d8 00 00 00 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 c7 c0 00 00 00 80 48 2b 05 69 36 74 00 e9 43 ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 48 c7 45 c8 01 
[   43.738740] RIP: crypto_gcm_init_common+0x234/0x260 RSP: ffffbd460049fac8
[   43.739402] ---[ end trace 6df3f493a6e39d76 ]---
Segmentation fault
