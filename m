Date: Wed, 7 Jun 2017 20:31:16 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170608003116.zgznzb37ms7wj4vl@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-5-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-5-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v4 04/13] security/keys: ensure RNG is seeded before use
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Safford <safford@us.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:47:55PM +0200, Jason A. Donenfeld wrote:
> -static inline void key_alloc_serial(struct key *key)
> +static inline int key_alloc_serial(struct key *key)

> @@ -170,7 +168,7 @@ static inline void key_alloc_serial(struct key *key)
>  	rb_insert_color(&key->serial_node, &key_serial_tree);
>  
>  	spin_unlock(&key_serial_lock);
> -	return;
> +	return 0;
>  
>  	/* we found a key with the proposed serial number - walk the tree from
>  	 * that point looking for the next unused serial number */

> @@ -314,7 +312,9 @@ struct key *key_alloc(struct key_type *type, const char *desc,
>  
>  	/* publish the key by giving it a serial number */
>  	atomic_inc(&user->nkeys);
> -	key_alloc_serial(key);
> +	ret = key_alloc_serial(key);
> +	if (ret < 0)
> +		goto security_error;
>  
>  error:
>  	return key;

I'm guessing you changed key_alloc_serial() to return an int back when
you were thinking that you might use get_random_bytes_wait(), which
could return -ERESTARTSYS.

Now that you're not doing this, but using get_random_u32() instead,
there's no point to change the function signature of
key_alloc_serial() and add an error check in key_alloc() that will
never fail, right?  That's just adding a dead code path.  Which the
compiler can probably optimize away, but why make the code slightly
harder to read than necessasry?

						- Ted
