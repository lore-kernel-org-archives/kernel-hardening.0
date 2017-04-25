References: <20170425140809.23881-1-Jason@zx2c4.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <00e2b74b-69cd-07c5-6a0e-5b3e856a783e@cogentembedded.com>
Date: Tue, 25 Apr 2017 18:42:44 +0300
MIME-Version: 1.0
In-Reply-To: <20170425140809.23881-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/5] skbuff: return -EMSGSIZE in skb_to_sgvec to prevent
 overflow
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, David.Laight@aculab.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello!

On 04/25/2017 05:08 PM, Jason A. Donenfeld wrote:

> This is a defense-in-depth measure in response to bugs like
> 4d6fa57b4dab0d77f4d8e9d9c73d1e63f6fe8fee.

    You need to also specify the summary line enclosed in (""). And it's 
enough to specify 12 digits of SHA1 ID...

> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
[...]

MBR, Sergei
