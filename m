Subject: Re: [PATCH v2] net: dsa: drop some VLAs in switch.c
References: <1525706596-13601-1-git-send-email-s.mesoraca16@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d7fa9cf7-7c7e-b01c-8925-ce6dafc8721c@gmail.com>
Date: Mon, 7 May 2018 11:14:02 -0700
MIME-Version: 1.0
In-Reply-To: <1525706596-13601-1-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>, David Laight <David.Laight@ACULAB.COM>
List-ID: <kernel-hardening.lists.openwall.com>

On 05/07/2018 08:23 AM, Salvatore Mesoraca wrote:
> We avoid 2 VLAs by using a pre-allocated field in dsa_switch.
> We also try to avoid dynamic allocation whenever possible.
> 
> Link: http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> Link: http://lkml.kernel.org/r/20180505185145.GB32630@lunn.ch
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  include/net/dsa.h |  3 +++
>  net/dsa/dsa2.c    | 14 ++++++++++++++
>  net/dsa/switch.c  | 22 ++++++++++------------
>  3 files changed, 27 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 60fb4ec..576791d 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -256,6 +256,9 @@ struct dsa_switch {
>  	/* Number of switch port queues */
>  	unsigned int		num_tx_queues;
>  
> +	unsigned long		*bitmap;
> +	unsigned long		_bitmap;
> +
>  	/* Dynamically allocated ports, keep last */
>  	size_t num_ports;
>  	struct dsa_port ports[];
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index adf50fb..cebf35f0 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -748,6 +748,20 @@ struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
>  	if (!ds)
>  		return NULL;
>  
> +	/* We avoid allocating memory outside dsa_switch
> +	 * if it is not needed.
> +	 */
> +	if (n <= sizeof(ds->_bitmap) * 8) {
> +		ds->bitmap = &ds->_bitmap;

Should not this be / BITS_PER_BYTE? If the sizeof(unsigned long) is <=
8, then you don't need to allocate it, otherwise, you have to.

I would actually just always dynamically allocate the bitmap, optimizing
for the case where we have fewer than or 8 ports is not worth IMHO.
-- 
Florian
