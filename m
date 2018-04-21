Date: Sat, 21 Apr 2018 10:14:49 +0200
From: Boris Brezillon <boris.brezillon@bootlin.com>
Subject: Re: [patch V2 5/8] rslib: Split rs control struct
Message-ID: <20180421101449.50419733@bbrezillon>
In-Reply-To: <20180419100935.175488049@linutronix.de>
References: <20180419100441.548834519@linutronix.de>
	<20180419100935.175488049@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 19 Apr 2018 12:04:46 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The decoder library uses variable length arrays on stack. To get rid of
> them it would be simple to allocate fixed length arrays on stack, but those
> might become rather large. The other solution is to allocate the buffers in
> the rs control structure, but this cannot be done as long as the structure
> can be shared by several users. Sharing is desired because the RS polynom
> tables are large and initialization is time consuming.
> 
> To solve this split the codec information out of the control structure and
> have a pointer to a shared codec in it. Instantiate the control structure
> for each user, create a new codec if no shareable is avaiable yet.  Adjust
> all affected usage sites to the new scheme.
> 
> This allows to add per instance decoder buffers to the control structure
> later on.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Segher Boessenkool <segher@kernel.crashing.org>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Colin Cross <ccross@android.com>
> Cc: Andrew Morton <akpm@linuxfoundation.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Alasdair Kergon <agk@redhat.com>
> 
> ---
>  drivers/mtd/nand/raw/cafe_nand.c    |    7 +
>  drivers/mtd/nand/raw/diskonchip.c   |    7 +

For NAND relate stuff:

Acked-by: Boris Brezillon <boris.brezillon@bootlin.com>

Don't know which release this patch series is targeting, but if it's
4.18 I'll need an immutable branch just in case other patches touch the
same files.

>  include/linux/rslib.h           |   18 +++--
>  lib/reed_solomon/decode_rs.c    |    1 
>  lib/reed_solomon/encode_rs.c    |    1 
>  lib/reed_solomon/reed_solomon.c |  144 ++++++++++++++++++++++------------------
>  6 files changed, 104 insertions(+), 74 deletions(-)
> 
> --- a/drivers/mtd/nand/raw/cafe_nand.c
> +++ b/drivers/mtd/nand/raw/cafe_nand.c
> @@ -394,12 +394,13 @@ static int cafe_nand_read_page(struct mt
>  
>  		for (i=0; i<8; i+=2) {
>  			uint32_t tmp = cafe_readl(cafe, NAND_ECC_SYN01 + (i*2));
> -			syn[i] = cafe->rs->index_of[tmp & 0xfff];
> -			syn[i+1] = cafe->rs->index_of[(tmp >> 16) & 0xfff];
> +
> +			syn[i] = cafe->rs->codec->index_of[tmp & 0xfff];
> +			syn[i+1] = cafe->rs->codec->index_of[(tmp >> 16) & 0xfff];
>  		}
>  
>  		n = decode_rs16(cafe->rs, NULL, NULL, 1367, syn, 0, pos, 0,
> -		                pat);
> +				pat);
>  
>  		for (i = 0; i < n; i++) {
>  			int p = pos[i];
> --- a/drivers/mtd/nand/raw/diskonchip.c
> +++ b/drivers/mtd/nand/raw/diskonchip.c
> @@ -142,6 +142,7 @@ static int doc_ecc_decode(struct rs_cont
>  	int i, j, nerr, errpos[8];
>  	uint8_t parity;
>  	uint16_t ds[4], s[5], tmp, errval[8], syn[4];
> +	struct rs_codec *cd = rs->codec;
>  
>  	memset(syn, 0, sizeof(syn));
>  	/* Convert the ecc bytes into words */
> @@ -162,15 +163,15 @@ static int doc_ecc_decode(struct rs_cont
>  	for (j = 1; j < NROOTS; j++) {
>  		if (ds[j] == 0)
>  			continue;
> -		tmp = rs->index_of[ds[j]];
> +		tmp = cd->index_of[ds[j]];
>  		for (i = 0; i < NROOTS; i++)
> -			s[i] ^= rs->alpha_to[rs_modnn(rs, tmp + (FCR + i) * j)];
> +			s[i] ^= cd->alpha_to[rs_modnn(cd, tmp + (FCR + i) * j)];
>  	}
>  
>  	/* Calc syn[i] = s[i] / alpha^(v + i) */
>  	for (i = 0; i < NROOTS; i++) {
>  		if (s[i])
> -			syn[i] = rs_modnn(rs, rs->index_of[s[i]] + (NN - FCR - i));
> +			syn[i] = rs_modnn(cd, cd->index_of[s[i]] + (NN - FCR - i));
>  	}
>  	/* Call the decoder library */
>  	nerr = decode_rs16(rs, NULL, NULL, 1019, syn, 0, errpos, 0, errval);
> --- a/include/linux/rslib.h
> +++ b/include/linux/rslib.h
> @@ -13,7 +13,7 @@
>  #include <linux/list.h>
>  
>  /**
> - * struct rs_control - rs control structure
> + * struct rs_codec - rs codec data
>   *
>   * @mm:		Bits per symbol
>   * @nn:		Symbols per block (= (1<<mm)-1)
> @@ -27,9 +27,9 @@
>   * @gfpoly:	The primitive generator polynominal
>   * @gffunc:	Function to generate the field, if non-canonical representation
>   * @users:	Users of this structure
> - * @list:	List entry for the rs control list
> + * @list:	List entry for the rs codec list
>  */
> -struct rs_control {
> +struct rs_codec {
>  	int		mm;
>  	int		nn;
>  	uint16_t	*alpha_to;
> @@ -45,6 +45,14 @@ struct rs_control {
>  	struct list_head list;
>  };
>  
> +/**
> + * struct rs_control - rs control structure per instance
> + * @codec:	The codec used for this instance
> + */
> +struct rs_control {
> +	struct rs_codec	*codec;
> +};
> +
>  /* General purpose RS codec, 8-bit data width, symbol width 1-15 bit  */
>  #ifdef CONFIG_REED_SOLOMON_ENC8
>  int encode_rs8(struct rs_control *rs, uint8_t *data, int len, uint16_t *par,
> @@ -78,7 +86,7 @@ void free_rs(struct rs_control *rs);
>  
>  /** modulo replacement for galois field arithmetics
>   *
> - *  @rs:	the rs control structure
> + *  @rs:	Pointer to the RS codec
>   *  @x:		the value to reduce
>   *
>   *  where
> @@ -88,7 +96,7 @@ void free_rs(struct rs_control *rs);
>   *  Simple arithmetic modulo would return a wrong result for values
>   *  >= 3 * rs->nn
>  */
> -static inline int rs_modnn(struct rs_control *rs, int x)
> +static inline int rs_modnn(struct rs_codec *rs, int x)
>  {
>  	while (x >= rs->nn) {
>  		x -= rs->nn;
> --- a/lib/reed_solomon/decode_rs.c
> +++ b/lib/reed_solomon/decode_rs.c
> @@ -10,6 +10,7 @@
>   * Generic data width independent code which is included by the wrappers.
>   */
>  {
> +	struct rs_codec *rs = rsc->codec;
>  	int deg_lambda, el, deg_omega;
>  	int i, j, r, k, pad;
>  	int nn = rs->nn;
> --- a/lib/reed_solomon/encode_rs.c
> +++ b/lib/reed_solomon/encode_rs.c
> @@ -10,6 +10,7 @@
>   * Generic data width independent code which is included by the wrappers.
>   */
>  {
> +	struct rs_codec *rs = rsc->codec;
>  	int i, j, pad;
>  	int nn = rs->nn;
>  	int nroots = rs->nroots;
> --- a/lib/reed_solomon/reed_solomon.c
> +++ b/lib/reed_solomon/reed_solomon.c
> @@ -11,22 +11,23 @@
>   *
>   * The generic Reed Solomon library provides runtime configurable
>   * encoding / decoding of RS codes.
> - * Each user must call init_rs to get a pointer to a rs_control
> - * structure for the given rs parameters. This structure is either
> - * generated or a already available matching control structure is used.
> - * If a structure is generated then the polynomial arrays for
> - * fast encoding / decoding are built. This can take some time so
> - * make sure not to call this function from a time critical path.
> - * Usually a module / driver should initialize the necessary
> - * rs_control structure on module / driver init and release it
> - * on exit.
> - * The encoding puts the calculated syndrome into a given syndrome
> - * buffer.
> - * The decoding is a two step process. The first step calculates
> - * the syndrome over the received (data + syndrome) and calls the
> - * second stage, which does the decoding / error correction itself.
> - * Many hw encoders provide a syndrome calculation over the received
> - * data + syndrome and can call the second stage directly.
> + *
> + * Each user must call init_rs to get a pointer to a rs_control structure
> + * for the given rs parameters. The control struct is unique per instance.
> + * It points to a codec which can be shared by multiple control structures.
> + * If a codec is newly allocated then the polynomial arrays for fast
> + * encoding / decoding are built. This can take some time so make sure not
> + * to call this function from a time critical path.  Usually a module /
> + * driver should initialize the necessary rs_control structure on module /
> + * driver init and release it on exit.
> + *
> + * The encoding puts the calculated syndrome into a given syndrome buffer.
> + *
> + * The decoding is a two step process. The first step calculates the
> + * syndrome over the received (data + syndrome) and calls the second stage,
> + * which does the decoding / error correction itself.  Many hw encoders
> + * provide a syndrome calculation over the received data + syndrome and can
> + * call the second stage directly.
>   */
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
> @@ -36,13 +37,13 @@
>  #include <linux/slab.h>
>  #include <linux/mutex.h>
>  
> -/* This list holds all currently allocated rs control structures */
> -static LIST_HEAD (rslist);
> +/* This list holds all currently allocated rs codec structures */
> +static LIST_HEAD(codec_list);
>  /* Protection for the list */
>  static DEFINE_MUTEX(rslistlock);
>  
>  /**
> - * rs_init - Initialize a Reed-Solomon codec
> + * codec_init - Initialize a Reed-Solomon codec
>   * @symsize:	symbol size, bits (1-8)
>   * @gfpoly:	Field generator polynomial coefficients
>   * @gffunc:	Field generator function
> @@ -50,18 +51,17 @@ static DEFINE_MUTEX(rslistlock);
>   * @prim:	primitive element to generate polynomial roots
>   * @nroots:	RS code generator polynomial degree (number of roots)
>   *
> - * Allocate a control structure and the polynom arrays for faster
> + * Allocate a codec structure and the polynom arrays for faster
>   * en/decoding. Fill the arrays according to the given parameters.
>   */
> -static struct rs_control *rs_init(int symsize, int gfpoly, int (*gffunc)(int),
> -				  int fcr, int prim, int nroots)
> +static struct rs_codec *codec_init(int symsize, int gfpoly, int (*gffunc)(int),
> +				   int fcr, int prim, int nroots)
>  {
> -	struct rs_control *rs;
>  	int i, j, sr, root, iprim;
> +	struct rs_codec *rs;
>  
> -	/* Allocate the control structure */
> -	rs = kmalloc(sizeof (struct rs_control), GFP_KERNEL);
> -	if (rs == NULL)
> +	rs = kmalloc(sizeof(*rs), GFP_KERNEL);
> +	if (!rs)
>  		return NULL;
>  
>  	INIT_LIST_HEAD(&rs->list);
> @@ -138,6 +138,9 @@ static struct rs_control *rs_init(int sy
>  	/* convert rs->genpoly[] to index form for quicker encoding */
>  	for (i = 0; i <= nroots; i++)
>  		rs->genpoly[i] = rs->index_of[rs->genpoly[i]];
> +
> +	rs->users = 1;
> +	list_add(&rs->list, &codec_list);
>  	return rs;
>  
>  	/* Error exit */
> @@ -154,26 +157,36 @@ static struct rs_control *rs_init(int sy
>  
>  
>  /**
> - *  free_rs - Free the rs control structure, if it is no longer used
> - *  @rs:	the control structure which is not longer used by the
> + *  free_rs - Free the rs control structure
> + *  @rs:	The control structure which is not longer used by the
>   *		caller
> + *
> + * Free the control structure. If @rs is the last user of the associated
> + * codec, free the codec as well.
>   */
>  void free_rs(struct rs_control *rs)
>  {
> +	struct rs_codec *cd;
> +
> +	if (!rs)
> +		return;
> +
> +	cd = rs->codec;
>  	mutex_lock(&rslistlock);
> -	rs->users--;
> -	if(!rs->users) {
> -		list_del(&rs->list);
> -		kfree(rs->alpha_to);
> -		kfree(rs->index_of);
> -		kfree(rs->genpoly);
> -		kfree(rs);
> +	cd->users--;
> +	if(!cd->users) {
> +		list_del(&cd->list);
> +		kfree(cd->alpha_to);
> +		kfree(cd->index_of);
> +		kfree(cd->genpoly);
> +		kfree(cd);
>  	}
>  	mutex_unlock(&rslistlock);
> +	kfree(rs);
>  }
>  
>  /**
> - * init_rs_internal - Find a matching or allocate a new rs control structure
> + * init_rs_internal - Allocate rs control, find a matching codec or allocate a new one
>   *  @symsize:	the symbol size (number of bits)
>   *  @gfpoly:	the extended Galois field generator polynomial coefficients,
>   *		with the 0th coefficient in the low order bit. The polynomial
> @@ -190,8 +203,8 @@ static struct rs_control *init_rs_intern
>  					   int (*gffunc)(int), int fcr,
>  					   int prim, int nroots)
>  {
> -	struct list_head	*tmp;
> -	struct rs_control	*rs;
> +	struct list_head *tmp;
> +	struct rs_control *rs;
>  
>  	/* Sanity checks */
>  	if (symsize < 1)
> @@ -203,33 +216,39 @@ static struct rs_control *init_rs_intern
>  	if (nroots < 0 || nroots >= (1<<symsize))
>  		return NULL;
>  
> +	rs = kzalloc(sizeof(*rs), GFP_KERNEL);
> +	if (!rs)
> +		return NULL;
> +
>  	mutex_lock(&rslistlock);
>  
>  	/* Walk through the list and look for a matching entry */
> -	list_for_each(tmp, &rslist) {
> -		rs = list_entry(tmp, struct rs_control, list);
> -		if (symsize != rs->mm)
> +	list_for_each(tmp, &codec_list) {
> +		struct rs_codec *cd = list_entry(tmp, struct rs_codec, list);
> +
> +		if (symsize != cd->mm)
>  			continue;
> -		if (gfpoly != rs->gfpoly)
> +		if (gfpoly != cd->gfpoly)
>  			continue;
> -		if (gffunc != rs->gffunc)
> +		if (gffunc != cd->gffunc)
>  			continue;
> -		if (fcr != rs->fcr)
> +		if (fcr != cd->fcr)
>  			continue;
> -		if (prim != rs->prim)
> +		if (prim != cd->prim)
>  			continue;
> -		if (nroots != rs->nroots)
> +		if (nroots != cd->nroots)
>  			continue;
>  		/* We have a matching one already */
> -		rs->users++;
> +		cd->users++;
> +		rs->codec = cd;
>  		goto out;
>  	}
>  
>  	/* Create a new one */
> -	rs = rs_init(symsize, gfpoly, gffunc, fcr, prim, nroots);
> -	if (rs) {
> -		rs->users = 1;
> -		list_add(&rs->list, &rslist);
> +	rs->codec = codec_init(symsize, gfpoly, gffunc, fcr, prim, nroots);
> +	if (!rs->codec) {
> +		kfree(rs);
> +		rs = NULL;
>  	}
>  out:
>  	mutex_unlock(&rslistlock);
> @@ -237,7 +256,7 @@ static struct rs_control *init_rs_intern
>  }
>  
>  /**
> - * init_rs - Find a matching or allocate a new rs control structure
> + * init_rs - Create a RS control struct and initialize it
>   *  @symsize:	the symbol size (number of bits)
>   *  @gfpoly:	the extended Galois field generator polynomial coefficients,
>   *		with the 0th coefficient in the low order bit. The polynomial
> @@ -254,9 +273,8 @@ struct rs_control *init_rs(int symsize,
>  }
>  
>  /**
> - * init_rs_non_canonical - Find a matching or allocate a new rs control
> - *                         structure, for fields with non-canonical
> - *                         representation
> + * init_rs_non_canonical - Allocate rs control struct for fields with
> + *                         non-canonical representation
>   *  @symsize:	the symbol size (number of bits)
>   *  @gffunc:	pointer to function to generate the next field element,
>   *		or the multiplicative identity element if given 0.  Used
> @@ -275,7 +293,7 @@ struct rs_control *init_rs_non_canonical
>  #ifdef CONFIG_REED_SOLOMON_ENC8
>  /**
>   *  encode_rs8 - Calculate the parity for data values (8bit data width)
> - *  @rs:	the rs control structure
> + *  @rsc:	the rs control structure
>   *  @data:	data field of a given type
>   *  @len:	data length
>   *  @par:	parity data, must be initialized by caller (usually all 0)
> @@ -285,7 +303,7 @@ struct rs_control *init_rs_non_canonical
>   *  symbol size > 8. The calling code must take care of encoding of the
>   *  syndrome result for storage itself.
>   */
> -int encode_rs8(struct rs_control *rs, uint8_t *data, int len, uint16_t *par,
> +int encode_rs8(struct rs_control *rsc, uint8_t *data, int len, uint16_t *par,
>  	       uint16_t invmsk)
>  {
>  #include "encode_rs.c"
> @@ -296,7 +314,7 @@ EXPORT_SYMBOL_GPL(encode_rs8);
>  #ifdef CONFIG_REED_SOLOMON_DEC8
>  /**
>   *  decode_rs8 - Decode codeword (8bit data width)
> - *  @rs:	the rs control structure
> + *  @rsc:	the rs control structure
>   *  @data:	data field of a given type
>   *  @par:	received parity data field
>   *  @len:	data length
> @@ -311,7 +329,7 @@ EXPORT_SYMBOL_GPL(encode_rs8);
>   *  syndrome result and the received parity before calling this code.
>   *  Returns the number of corrected bits or -EBADMSG for uncorrectable errors.
>   */
> -int decode_rs8(struct rs_control *rs, uint8_t *data, uint16_t *par, int len,
> +int decode_rs8(struct rs_control *rsc, uint8_t *data, uint16_t *par, int len,
>  	       uint16_t *s, int no_eras, int *eras_pos, uint16_t invmsk,
>  	       uint16_t *corr)
>  {
> @@ -323,7 +341,7 @@ EXPORT_SYMBOL_GPL(decode_rs8);
>  #ifdef CONFIG_REED_SOLOMON_ENC16
>  /**
>   *  encode_rs16 - Calculate the parity for data values (16bit data width)
> - *  @rs:	the rs control structure
> + *  @rsc:	the rs control structure
>   *  @data:	data field of a given type
>   *  @len:	data length
>   *  @par:	parity data, must be initialized by caller (usually all 0)
> @@ -331,7 +349,7 @@ EXPORT_SYMBOL_GPL(decode_rs8);
>   *
>   *  Each field in the data array contains up to symbol size bits of valid data.
>   */
> -int encode_rs16(struct rs_control *rs, uint16_t *data, int len, uint16_t *par,
> +int encode_rs16(struct rs_control *rsc, uint16_t *data, int len, uint16_t *par,
>  	uint16_t invmsk)
>  {
>  #include "encode_rs.c"
> @@ -342,7 +360,7 @@ EXPORT_SYMBOL_GPL(encode_rs16);
>  #ifdef CONFIG_REED_SOLOMON_DEC16
>  /**
>   *  decode_rs16 - Decode codeword (16bit data width)
> - *  @rs:	the rs control structure
> + *  @rsc:	the rs control structure
>   *  @data:	data field of a given type
>   *  @par:	received parity data field
>   *  @len:	data length
> @@ -355,7 +373,7 @@ EXPORT_SYMBOL_GPL(encode_rs16);
>   *  Each field in the data array contains up to symbol size bits of valid data.
>   *  Returns the number of corrected bits or -EBADMSG for uncorrectable errors.
>   */
> -int decode_rs16(struct rs_control *rs, uint16_t *data, uint16_t *par, int len,
> +int decode_rs16(struct rs_control *rsc, uint16_t *data, uint16_t *par, int len,
>  		uint16_t *s, int no_eras, int *eras_pos, uint16_t invmsk,
>  		uint16_t *corr)
>  {
> 
> 
> 
> 
> 
