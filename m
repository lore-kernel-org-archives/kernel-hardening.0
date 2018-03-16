Subject: Re: [PATCH v4 2/2] Remove false-positive VLAs when using max()
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-3-git-send-email-keescook@chromium.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1ce21a4c-9dba-516b-943d-0f5ddc939584@suse.com>
Date: Fri, 16 Mar 2018 09:52:33 +0200
MIME-Version: 1.0
In-Reply-To: <1521143266-31350-3-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input@vger.kernel.org, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 15.03.2018 21:47, Kees Cook wrote:
> As part of removing VLAs from the kernel[1], we want to build with -Wvla,
> but it is overly pessimistic and only accepts constant expressions for
> stack array sizes, instead of also constant values. The max() macro
> triggers the warning, so this refactors these uses of max() to use the
> new const_max() instead.
> 
> [1] https://lkml.org/lkml/2018/3/7/621

For the btrfs portion :

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/input/touchscreen/cyttsp4_core.c |  2 +-
>  fs/btrfs/tree-checker.c                  |  3 ++-
>  lib/vsprintf.c                           |  4 ++--
>  net/ipv4/proc.c                          |  8 ++++----
>  net/ipv6/proc.c                          | 10 ++++------
>  5 files changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
> index 727c3232517c..f89497940051 100644
> --- a/drivers/input/touchscreen/cyttsp4_core.c
> +++ b/drivers/input/touchscreen/cyttsp4_core.c
> @@ -868,7 +868,7 @@ static void cyttsp4_get_mt_touches(struct cyttsp4_mt_data *md, int num_cur_tch)
>  	struct cyttsp4_touch tch;
>  	int sig;
>  	int i, j, t = 0;
> -	int ids[max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
> +	int ids[const_max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
>  
>  	memset(ids, 0, si->si_ofs.tch_abs[CY_TCH_T].max * sizeof(int));
>  	for (i = 0; i < num_cur_tch; i++) {
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index c3c8d48f6618..1ddd6cc3c4fc 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -341,7 +341,8 @@ static int check_dir_item(struct btrfs_root *root,
>  		 */
>  		if (key->type == BTRFS_DIR_ITEM_KEY ||
>  		    key->type == BTRFS_XATTR_ITEM_KEY) {
> -			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
> +			char namebuf[const_max(BTRFS_NAME_LEN,
> +					       XATTR_NAME_MAX)];
>  
>  			read_extent_buffer(leaf, namebuf,
>  					(unsigned long)(di + 1), name_len);
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index d7a708f82559..9d5610b643ce 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -744,8 +744,8 @@ char *resource_string(char *buf, char *end, struct resource *res,
>  #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
>  #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
>  #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
> -	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
> -		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
> +	char sym[const_max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
> +			   2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
>  
>  	char *p = sym, *pend = sym + sizeof(sym);
>  	int decode = (fmt[0] == 'R') ? 1 : 0;
> diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
> index dc5edc8f7564..fad6f989004e 100644
> --- a/net/ipv4/proc.c
> +++ b/net/ipv4/proc.c
> @@ -46,7 +46,7 @@
>  #include <net/sock.h>
>  #include <net/raw.h>
>  
> -#define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
> +#define TCPUDP_MIB_MAX const_max(UDP_MIB_MAX, TCP_MIB_MAX)
>  
>  /*
>   *	Report socket allocation statistics [mea@utu.fi]
> @@ -404,7 +404,7 @@ static int snmp_seq_show_tcp_udp(struct seq_file *seq, void *v)
>  	struct net *net = seq->private;
>  	int i;
>  
> -	memset(buff, 0, TCPUDP_MIB_MAX * sizeof(unsigned long));
> +	memset(buff, 0, sizeof(buff));
>  
>  	seq_puts(seq, "\nTcp:");
>  	for (i = 0; snmp4_tcp_list[i].name; i++)
> @@ -421,7 +421,7 @@ static int snmp_seq_show_tcp_udp(struct seq_file *seq, void *v)
>  			seq_printf(seq, " %lu", buff[i]);
>  	}
>  
> -	memset(buff, 0, TCPUDP_MIB_MAX * sizeof(unsigned long));
> +	memset(buff, 0, sizeof(buff));
>  
>  	snmp_get_cpu_field_batch(buff, snmp4_udp_list,
>  				 net->mib.udp_statistics);
> @@ -432,7 +432,7 @@ static int snmp_seq_show_tcp_udp(struct seq_file *seq, void *v)
>  	for (i = 0; snmp4_udp_list[i].name; i++)
>  		seq_printf(seq, " %lu", buff[i]);
>  
> -	memset(buff, 0, TCPUDP_MIB_MAX * sizeof(unsigned long));
> +	memset(buff, 0, sizeof(buff));
>  
>  	/* the UDP and UDP-Lite MIBs are the same */
>  	seq_puts(seq, "\nUdpLite:");
> diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
> index b67814242f78..58bbfc4fa7fa 100644
> --- a/net/ipv6/proc.c
> +++ b/net/ipv6/proc.c
> @@ -30,10 +30,8 @@
>  #include <net/transp_v6.h>
>  #include <net/ipv6.h>
>  
> -#define MAX4(a, b, c, d) \
> -	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
> -#define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
> -			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
> +#define SNMP_MIB_MAX const_max(const_max(UDP_MIB_MAX, TCP_MIB_MAX), \
> +			       const_max(IPSTATS_MIB_MAX, ICMP_MIB_MAX))
>  
>  static int sockstat6_seq_show(struct seq_file *seq, void *v)
>  {
> @@ -199,7 +197,7 @@ static void snmp6_seq_show_item(struct seq_file *seq, void __percpu *pcpumib,
>  	int i;
>  
>  	if (pcpumib) {
> -		memset(buff, 0, sizeof(unsigned long) * SNMP_MIB_MAX);
> +		memset(buff, 0, sizeof(buff));
>  
>  		snmp_get_cpu_field_batch(buff, itemlist, pcpumib);
>  		for (i = 0; itemlist[i].name; i++)
> @@ -218,7 +216,7 @@ static void snmp6_seq_show_item64(struct seq_file *seq, void __percpu *mib,
>  	u64 buff64[SNMP_MIB_MAX];
>  	int i;
>  
> -	memset(buff64, 0, sizeof(u64) * SNMP_MIB_MAX);
> +	memset(buff64, 0, sizeof(buff64));
>  
>  	snmp_get_cpu_field64_batch(buff64, itemlist, mib, syncpoff);
>  	for (i = 0; itemlist[i].name; i++)
> 
