Message-ID: <1518639587.3678.25.camel@perches.com>
Subject: Re: [PATCH v2 3/8] Convert virtio_console to kvzalloc_struct
From: Joe Perches <joe@perches.com>
Date: Wed, 14 Feb 2018 12:19:47 -0800
In-Reply-To: <20180214201154.10186-4-willy@infradead.org>
References: <20180214201154.10186-1-willy@infradead.org>
	 <20180214201154.10186-4-willy@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2018-02-14 at 12:11 -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  drivers/char/virtio_console.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index 468f06134012..e0816cc2c6bd 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -433,8 +433,7 @@ static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
>  	 * Allocate buffer and the sg list. The sg list array is allocated
>  	 * directly after the port_buffer struct.
>  	 */
> -	buf = kmalloc(sizeof(*buf) + sizeof(struct scatterlist) * pages,
> -		      GFP_KERNEL);
> +	buf = kvzalloc_struct(buf, sg, pages, GFP_KERNEL);
>  	if (!buf)
>  		goto fail;

kvfree?
