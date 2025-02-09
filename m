Return-Path: <kernel-hardening-return-21925-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 662C4C02199
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 03:42:49 +0000 (UTC)
Received: (qmail 13762 invoked by uid 550); 9 Feb 2025 03:42:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13724 invoked from network); 9 Feb 2025 03:42:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1739072543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m04RA4OznHMeMccQGW/Q5QOIqkOO+cTX8fddgkQ9Jf4=;
	b=qbbnBV9AK/t4kMPwwQvS48iOul9vL0A9Cuu8wYCRApdFVWKohOYMOKUYBfQvlEZ81DtfQI
	24Uqo2HleZNIBC3JFOF5/vQBQklUITXNlZCBRyAypNn/w1AE5GfpZXa/p58p/Z+rNk01Rl
	68WWabLx9+KHJFOXNicSevoRpopYoT8pgg8Brs1fr4C0xdFPrY2nLFNj1ZfCJNFr0Gw7ZR
	WXAgwILb1cpvTarnWsCxAEASveXq/V9GI5sDIBZkF916e61wcvWZE2dZ0fCMYhJpmb7V+1
	KxpeGAJS02VruyTn0AQNeKToKzQGHtr4ktXIuifmdHW3H5JZJPwC86L3eEt3TA==
Date: Sat, 8 Feb 2025 22:42:19 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH] NFSv4: harden nfs4_get_uniquifier() function
Message-ID: <dupajamhv63sqan3ybqi3sode4qt3ehtmvqa3qnbdxb6uvntsf@6oshvrg2j2f2>
References: <k7n2k4zqqnf6yisotj6ofgne7lvmwgy3yghygvwixfmkyrcwgl@4z26pbujl3gq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k7n2k4zqqnf6yisotj6ofgne7lvmwgy3yghygvwixfmkyrcwgl@4z26pbujl3gq>
X-Rspamd-Queue-Id: 4YrD6k6SH3z9sQ5

I wanted to check in on this. Anything I should change?

Thanks,
Ethan

On 25/01/19 11:55PM, Ethan Carter Edwards wrote:
> If the incorrect buffer size were passed into nfs4_get_uniquifier
> function then a memory access error could occur. This change prevents us
> from accidentally passing an unrelated variable into the buffer copy
> function.
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> ---
>  fs/nfs/nfs4proc.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index 405f17e6e0b4..18311bf5338d 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -6408,7 +6408,7 @@ static void nfs4_init_boot_verifier(const struct nfs_client *clp,
>  }
>  
>  static size_t
> -nfs4_get_uniquifier(struct nfs_client *clp, char *buf, size_t buflen)
> +nfs4_get_uniquifier(struct nfs_client *clp, char *buf)
>  {
>  	struct nfs_net *nn = net_generic(clp->cl_net, nfs_net_id);
>  	struct nfs_netns_client *nn_clp = nn->nfs_client;
> @@ -6420,12 +6420,12 @@ nfs4_get_uniquifier(struct nfs_client *clp, char *buf, size_t buflen)
>  		rcu_read_lock();
>  		id = rcu_dereference(nn_clp->identifier);
>  		if (id)
> -			strscpy(buf, id, buflen);
> +			strscpy(buf, id, sizeof(buf));
>  		rcu_read_unlock();
>  	}
>  
>  	if (nfs4_client_id_uniquifier[0] != '\0' && buf[0] == '\0')
> -		strscpy(buf, nfs4_client_id_uniquifier, buflen);
> +		strscpy(buf, nfs4_client_id_uniquifier, sizeof(buf));
>  
>  	return strlen(buf);
>  }
> @@ -6449,7 +6449,7 @@ nfs4_init_nonuniform_client_string(struct nfs_client *clp)
>  		1;
>  	rcu_read_unlock();
>  
> -	buflen = nfs4_get_uniquifier(clp, buf, sizeof(buf));
> +	buflen = nfs4_get_uniquifier(clp, buf);
>  	if (buflen)
>  		len += buflen + 1;
>  
> @@ -6496,7 +6496,7 @@ nfs4_init_uniform_client_string(struct nfs_client *clp)
>  	len = 10 + 10 + 1 + 10 + 1 +
>  		strlen(clp->cl_rpcclient->cl_nodename) + 1;
>  
> -	buflen = nfs4_get_uniquifier(clp, buf, sizeof(buf));
> +	buflen = nfs4_get_uniquifier(clp, buf);
>  	if (buflen)
>  		len += buflen + 1;
>  
> -- 
> 2.48.0
> 
