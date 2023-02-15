Return-Path: <kernel-hardening-return-21645-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 30C82C636D4
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Feb 2023 14:32:54 +0000 (UTC)
Received: (qmail 1811 invoked by uid 550); 15 Feb 2023 14:30:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14012 invoked from network); 15 Feb 2023 05:50:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cfjyb6YgPsA07U5Gf28JYt2DM3rLGD4qk8TtTKhzCcE=;
        b=MrRLtD2Cw4ZuAEMf6+lkO+XmQ1dV0uOFwWHkFEsE2oO/HUPZTry5l3p0XhQOD91JP6
         D4HN6TVn8A05ndtd0ZD3DsA5NNYFykmw1t9fCudUvQGvNSdpAZlXUmntBDZFkr4CfkHy
         rJzqNjMZGIkGGLVe2OICz/3AdsV69AikgwFGaPkVCyXriLssX96dm/C+vZUTT0HhRe8D
         Vy3XTRv6tgy1II1mDr8pyKPxARgrlLsQJjzxv9h4YUWvve0XSNO+NBO3BGXAs/4orbhi
         S5SfmghiKGwNrvd2R3RhborPxoAT62EkRr5qRKtspIGwE8/tLhaye+COP/PJ+1m7BkT4
         f2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cfjyb6YgPsA07U5Gf28JYt2DM3rLGD4qk8TtTKhzCcE=;
        b=uoJPmhjugLoVI/UAuyAgw5b8/b8VAcgH93WZFyXAltkhToc3tsokruJHvPVle+BTW+
         o1OZ2VrUlP9u14Gy8kciAD6Vutkas+rUSWUoStmgBlwreb6XWhrOt4FQKKTKihS46pf7
         S/aCVe62GhNmFEDzQh8sDrQie8GJgyESXfVjilw0k25/93pWopAG1WumSZ6PxiOugaKz
         0Fh6MmME6RimtRgV9NU+2zJ9rGdbd1EGAUghL4Dc4gou1l8RmmOPKTpPGzKxTVYxJqvl
         ycuZnIVQiYPYxBC6kTCHGaFoo6lnekvmbdAZZd+V2Ij8TKKY/9pkt2jSEvJEv7pBlFIp
         1qew==
X-Gm-Message-State: AO0yUKXSIMlN7ogAr1QsqJ5zJOL+uUJumvrhQH6yPGwFR3Xq+d+yxxdi
	UdhMarQq2xkk4ATwVQ7RWgU=
X-Google-Smtp-Source: AK7set9jL/YurVg1LrqMWj6gU+z5tA67pKXcqVUOF1awjSU3saKBO6H3ndM/q+6QU8miQSh5MvPbhA==
X-Received: by 2002:a17:903:110f:b0:19a:67c0:53ee with SMTP id n15-20020a170903110f00b0019a67c053eemr1337211plh.54.1676440195905;
        Tue, 14 Feb 2023 21:49:55 -0800 (PST)
Date: Wed, 15 Feb 2023 13:49:53 +0800
From: lijiazi <jqqlijiazi@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Jiazi.Li" <jiazi.li@transsion.com>, linux-mm@kvack.org,
	Kees Cook <keescook@chromium.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH] mm/slab: always use cache from obj
Message-ID: <20230215053748.GA11780@Jiazi.Li>
References: <20230214101949.7461-1-jiazi.li@transsion.com>
 <bb6ad3ee-8d00-bdd5-3f50-a8f836892d51@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb6ad3ee-8d00-bdd5-3f50-a8f836892d51@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Feb 14, 2023 at 11:33:21AM +0100, Vlastimil Babka wrote:
> On 2/14/23 11:19, Jiazi.Li wrote:
> > If free obj to a wrong cache, in addition random, different offset
> > and object_size will also cause problems:
> > 1. The offset of a cache with a ctor is not zero, free an object from
> > this cache to cache with offset zero, will write next freepointer to
> > wrong location, resulting in confusion of freelist.
> 
> Kernels hardened against freelist corruption will enable
> CONFIG_SLAB_FREELIST_HARDENED, so that's already covered, no?
> 
Yes, HARDENED already covered.
> > 2. If wrong cache want init on free, and cache->object_size is large
> > than obj size, which may lead to overwrite issue.
> 
> In general, being defensive against usage errors is part of either hardening
> or debugging, which is what the existing code takes into account.
> 
My consideration is for the wrong cache problem on version without
HARDENED or debugging, it is likely to cause kernel panic, and such
problem is difficult to analyze on non-debug version.
When reproducing this problem on debug version, it will not cause kernel
panic, but only print the WARN log, then use correct cache to free obj.
Because we want to reproduce kernel panic problem, so may ignore WARN
log and think that can not reproduce problem on debug version.

Thanks for your reply, I will enable CONFIG_SLAB_FREELIST_HARDENED on
non-debug version later.
> > Compared with adding a lot of if-else, it may be better to use obj's
> > cache directly.
> > 
> > Signed-off-by: Jiazi.Li <jiazi.li@transsion.com>
> > ---
> >  mm/slab.h | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 63fb4c00d529..ed39b2e4f27b 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -670,10 +670,6 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
> >  {
> >  	struct kmem_cache *cachep;
> >  
> > -	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
> > -	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
> > -		return s;
> > -
> >  	cachep = virt_to_cache(x);
> >  	if (WARN(cachep && cachep != s,
> >  		  "%s: Wrong slab cache. %s but object is from %s\n",
> 
