Return-Path: <kernel-hardening-return-21643-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 54E74C05027
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Feb 2023 10:33:45 +0000 (UTC)
Received: (qmail 20268 invoked by uid 550); 14 Feb 2023 10:33:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20232 invoked from network); 14 Feb 2023 10:33:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1676370801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BdyhHxCFHNdKTeaDsahoGwV349kyBnkEf6Wsf/DdUp4=;
	b=ZrVFCzpjTL3J8gSulNtXS2mh2kgcT7WHAq5LHTfrtNFkFq6wfrp4mp8yGLa3udbidoE1RF
	RLKG1iaxVuabrCswm+gfKKB9dH5fqD4Pg064zexbQ0faHqbrSt+1W2q0gkyP8flbaJR6KM
	ImqS+TtNKaaYbw7Pnf7nXP4jfe4qUGM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1676370801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BdyhHxCFHNdKTeaDsahoGwV349kyBnkEf6Wsf/DdUp4=;
	b=R/JJ/7wMTu3FKN0WvMLDKTcggvyH1bA7cXDHvmflWbFa/njAGf9534r0yNPfUL19yJGapw
	WxmAlrpDpvL135AA==
Message-ID: <bb6ad3ee-8d00-bdd5-3f50-a8f836892d51@suse.cz>
Date: Tue, 14 Feb 2023 11:33:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] mm/slab: always use cache from obj
Content-Language: en-US
To: "Jiazi.Li" <jqqlijiazi@gmail.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: "Jiazi.Li" <jiazi.li@transsion.com>, linux-mm@kvack.org,
 Kees Cook <keescook@chromium.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20230214101949.7461-1-jiazi.li@transsion.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230214101949.7461-1-jiazi.li@transsion.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/23 11:19, Jiazi.Li wrote:
> If free obj to a wrong cache, in addition random, different offset
> and object_size will also cause problems:
> 1. The offset of a cache with a ctor is not zero, free an object from
> this cache to cache with offset zero, will write next freepointer to
> wrong location, resulting in confusion of freelist.

Kernels hardened against freelist corruption will enable
CONFIG_SLAB_FREELIST_HARDENED, so that's already covered, no?

> 2. If wrong cache want init on free, and cache->object_size is large
> than obj size, which may lead to overwrite issue.

In general, being defensive against usage errors is part of either hardening
or debugging, which is what the existing code takes into account.

> Compared with adding a lot of if-else, it may be better to use obj's
> cache directly.
> 
> Signed-off-by: Jiazi.Li <jiazi.li@transsion.com>
> ---
>  mm/slab.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 63fb4c00d529..ed39b2e4f27b 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -670,10 +670,6 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
>  {
>  	struct kmem_cache *cachep;
>  
> -	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
> -	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
> -		return s;
> -
>  	cachep = virt_to_cache(x);
>  	if (WARN(cachep && cachep != s,
>  		  "%s: Wrong slab cache. %s but object is from %s\n",

