Subject: Re: [PATCH 1/4] x86/crypto: camellia: Fix function prototypes
References: <20180415041542.5364-1-jmoreira@suse.de>
 <20180415041542.5364-2-jmoreira@suse.de>
 <20180416061044.z6eb4psw2sbszemb@gmail.com>
From: =?UTF-8?Q?Jo=c3=a3o_Moreira?= <jmoreira@suse.de>
Message-ID: <15bd0d05-e046-1b35-9f14-91e507e6b162@suse.de>
Date: Mon, 16 Apr 2018 11:35:58 -0300
MIME-Version: 1.0
In-Reply-To: <20180416061044.z6eb4psw2sbszemb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Ingo Molnar <mingo@kernel.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

> 
>> +static inline void camellia_enc_blk(void *ctx, u8 *dst, const u8 *src)
>>   {
>> -	__camellia_enc_blk(ctx, dst, src, false);
>> +	__camellia_enc_blk((struct camellia_ctx *) ctx, dst, src, false);
>>   }
> 
> I don't see how this is an improvement: instead of having a proper type there's
> now an opaque type and an ugly (and dangerous) type cast.
> 
> What does "compatible with CFI requirements" mean?

For "compatible with CFI requirements", I meant: given a set of 
functions that are invoked through a given set of pointers, all 
functions and pointers in these sets have the same prototype. I added a 
note about this CFI heuristic in the cover letter, but I guess I should 
have been clearer there and added something more substantial to the 
commit message.

Regarding the changes, this was the most straight-forward way I found to 
make the sources compliant with the above, not requiring deeper semantic 
changes to the underneath invoking code. On the other hand, I agree that 
there is a collateral damage and that an ideal fix would be the other 
way around -- removing the opaque type from the pointer instead of 
adding it to the functions.

I'll try to think of another way and send if I come to something.

Tks,
João.
