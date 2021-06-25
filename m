Return-Path: <SRS0=s5Xv=LT=lists.openwall.com=kernel-hardening-return-21324-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595AAC2B9F4
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 16:25:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6693D6161C
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 16:25:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6693D6161C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21324-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19515 invoked by uid 550); 25 Jun 2021 16:25:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19471 invoked from network); 25 Jun 2021 16:25:07 -0000
Date: Fri, 25 Jun 2021 12:24:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: <linux-kernel@vger.kernel.org>, <kernel-hardening@lists.openwall.com>,
 <ying.xue@windriver.com>, <zhiquan.li@windriver.com>
Subject: Re: [PATCH 1/2] seq_buf: fix overflow when length is bigger than 8
Message-ID: <20210625122453.5e2fe304@oasis.local.home>
In-Reply-To: <20210625155348.58266-1-yun.zhou@windriver.com>
References: <20210625155348.58266-1-yun.zhou@windriver.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Jun 2021 23:53:47 +0800
Yun Zhou <yun.zhou@windriver.com> wrote:

> There's two variables being increased in that loop (i and j), and i
> follows the raw data, and j follows what is being written into the buffer.
> We should compare 'i' to MAX_MEMHEX_BYTES or compare 'j' to HEX_CHARS.
> Otherwise, if 'j' goes bigger than HEX_CHARS, it will overflow the
> destination buffer.
> 
> This bug was introduced by commit 6d2289f3faa71dcc ("tracing: Make
> trace_seq_putmem_hex() more robust")

No it wasn't. The bug was in the original code:

  5e3ca0ec76fce ("ftrace: introduce the "hex" output method")

Which had this:

> static notrace int
> trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
> {
>         unsigned char hex[HEX_CHARS];
>         unsigned char *data;
>         unsigned char byte;
>         int i, j;
> 
>         BUG_ON(len >= HEX_CHARS);

If len is 16 (and HEX_CHARS is 17) the bug wouldn't happen.

> 
>         data = mem;
> 
> #ifdef __BIG_ENDIAN
>         for (i = 0, j = 0; i < len; i++) {
> #else
>         for (i = len-1, j = 0; i >= 0; i--) {
> #endif

The above starts at len-1 (15) and will iterate 15 times.

>                 byte = data[i];
> 
>                 hex[j]   = byte & 0x0f;
>                 if (hex[j] >= 10)
>                         hex[j] += 'a' - 10;
>                 else
>                         hex[j] += '0';
>                 j++;
> 
>                 hex[j] = byte >> 4;
>                 if (hex[j] >= 10)
>                         hex[j] += 'a' - 10;
>                 else
>                         hex[j] += '0';
>                 j++;

j is incremented twice for every loop, and if len was 15, that is 30 times.

Needless to say, once i iterated 9 times, then j would be 18, and one
more than the size of hex. And boom, it breaks.



>         }
>         hex[j] = ' ';
>         j++;
> 
>         return trace_seq_putmem(s, hex, j);
> }



> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
>  lib/seq_buf.c | 29 +++++++++++------------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/lib/seq_buf.c b/lib/seq_buf.c
> index 6aabb609dd87..aa2f666e584e 100644
> --- a/lib/seq_buf.c
> +++ b/lib/seq_buf.c
> @@ -210,7 +210,8 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
>   * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
>   * @s: seq_buf descriptor
>   * @mem: The raw memory to write its hex ASCII representation of
> - * @len: The length of the raw memory to copy (in bytes)
> + * @len: The length of the raw memory to copy (in bytes).
> + *       It can be not larger than 8.
>   *
>   * This is similar to seq_buf_putmem() except instead of just copying the
>   * raw memory into the buffer it writes its ASCII representation of it
> @@ -228,27 +229,19 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
>  
>  	WARN_ON(s->size == 0);
>  
> -	while (len) {
> -		start_len = min(len, HEX_CHARS - 1);
> +	start_len = min(len, MAX_MEMHEX_BYTES);
>  #ifdef __BIG_ENDIAN
> -		for (i = 0, j = 0; i < start_len; i++) {
> +	for (i = 0, j = 0; i < start_len; i++) {
>  #else
> -		for (i = start_len-1, j = 0; i >= 0; i--) {
> +	for (i = start_len-1, j = 0; i >= 0; i--) {
>  #endif
> -			hex[j++] = hex_asc_hi(data[i]);
> -			hex[j++] = hex_asc_lo(data[i]);
> -		}
> -		if (WARN_ON_ONCE(j == 0 || j/2 > len))
> -			break;
> -
> -		/* j increments twice per loop */
> -		len -= j / 2;
> -		hex[j++] = ' ';
> -
> -		seq_buf_putmem(s, hex, j);
> -		if (seq_buf_has_overflowed(s))
> -			return -1;
> +		hex[j++] = hex_asc_hi(data[i]);
> +		hex[j++] = hex_asc_lo(data[i]);
>  	}
> +
> +	seq_buf_putmem(s, hex, j);
> +	if (seq_buf_has_overflowed(s))
> +		return -1;
>  	return 0;
>  }
>  

The above is *way* too complex for a backport that should go back to
the beginning. You were partially, correct, and the proper fix would be:


diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 707453f5d58e..eb68b5b3eb26 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -229,8 +229,10 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 
 	WARN_ON(s->size == 0);
 
+	BUILD_BUG_ON(MAX_MEMHEX_BYTES * 2 >= HEX_CHARS);
+
 	while (len) {
-		start_len = min(len, HEX_CHARS - 1);
+		start_len = min(len, MAX_MEMHEX_BYTES - 1);
 #ifdef __BIG_ENDIAN
 		for (i = 0, j = 0; i < start_len; i++) {
 #else
-- 
2.29.2


That solves the first bug, and is easy to backport.

The second bug, is that data doesn't go forward (as you stated in your
original patch) which would be:

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index eb68b5b3eb26..39b9374d3a1e 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -244,13 +244,14 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 		if (WARN_ON_ONCE(j == 0 || j/2 > len))
 			break;
 
-		/* j increments twice per loop */
-		len -= j / 2;
 		hex[j++] = ' ';
 
 		seq_buf_putmem(s, hex, j);
 		if (seq_buf_has_overflowed(s))
 			return -1;
+
+		len -= start_len;
+		data += start_len;
 	}
 	return 0;
 }

Why are you making it so complicated?

-- Steve
