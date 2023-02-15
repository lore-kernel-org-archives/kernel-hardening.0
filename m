Return-Path: <kernel-hardening-return-21646-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1A470C636D4
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Feb 2023 14:33:30 +0000 (UTC)
Received: (qmail 5636 invoked by uid 550); 15 Feb 2023 14:31:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9750 invoked from network); 15 Feb 2023 10:03:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRY/QGNXp4X1OL8xgNxCb7uWXA+X8wBiaGwcFoGIasM=;
        b=Xe685pvLVItZsFKsShJBDXiqZKWHo0cpq/zVwtDk9rs1vFdRlXsJqz+zNnKXBONdk0
         t95V6ORXWEKqU9nO57lrpiZBtOmg/1VXGtfdtXleF5SU+oIJ+hyTZre1gEFCJ73OJrPU
         qeSKVyta4SfPxPIBg8E3CMvujA5YAeExCwgIi/U0Yg9WGEX6JDMKApC2k8J8wCpd5FVe
         0y68/tUxHumkUvMKZmD6TwF470CophZA3MvwF+qefcnTIfJiZOIk70cA99kI76CnIyD7
         xgzqnqsjadLFE0/eqoEQTXRRZTVLlTniOdTNvv0Eesc+kIVcicaDwJhSPNd32exnAko/
         5UeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YRY/QGNXp4X1OL8xgNxCb7uWXA+X8wBiaGwcFoGIasM=;
        b=h0aO94oCTHKaTqjVCgXBi7CV+FSUi8IKAJxgAcFktq/7PnYcK8QGyw0r7CaHdJ20Td
         rpgDDCQ/VgrSJxnyIdenuAO2OYbCr722bVDk5wosL4Mu8yY4kJPFn0BnJPNXQjNCI7y1
         I1u0Wp0i4MBp7iGodQmYNlf8ekqzDyavtfbGnRJSwguoHjA3w0SJPz6Hr7jgLU3LBTc4
         SqkJdqSb5U/SGkPqrB9RzJ14dqtUccIL4fp1s64mwHe6lHHVpF//j6N/3ARMPuy0Hha4
         Ou3cID+/sFTepJouHpGZJk7RFHoR0qIdPZeNsaKCxzB6nUPXfxhPPPhx9wq3NyGB8wlo
         dBww==
X-Gm-Message-State: AO0yUKUln0NnbyduCA1tK4uNEHy8FFhBJTaPB2AtKlWUZkg2woQ2+hao
	j3YhrDhL1OHlAmx2WJmi68w=
X-Google-Smtp-Source: AK7set+ofMfLycAUI87OA9i4ajNRuYIKCqR6/aj+0MbH4bO3WebqsRQe1RKWZAdFXSYGwHx2yUWcCw==
X-Received: by 2002:a17:90b:1e0a:b0:22b:eb46:7d2 with SMTP id pg10-20020a17090b1e0a00b0022beb4607d2mr2022077pjb.47.1676455410880;
        Wed, 15 Feb 2023 02:03:30 -0800 (PST)
Date: Wed, 15 Feb 2023 18:03:27 +0800
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
Message-ID: <20230215100327.GA12544@Jiazi.Li>
References: <20230214101949.7461-1-jiazi.li@transsion.com>
 <bb6ad3ee-8d00-bdd5-3f50-a8f836892d51@suse.cz>
 <20230215053748.GA11780@Jiazi.Li>
 <884f051f-d1ed-756f-aef3-6ed3005de090@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <884f051f-d1ed-756f-aef3-6ed3005de090@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Wed, Feb 15, 2023 at 10:41:32AM +0100, Vlastimil Babka wrote:
> On 2/15/23 06:49, lijiazi wrote:
> > On Tue, Feb 14, 2023 at 11:33:21AM +0100, Vlastimil Babka wrote:
> >> On 2/14/23 11:19, Jiazi.Li wrote:
> >> > If free obj to a wrong cache, in addition random, different offset
> >> > and object_size will also cause problems:
> >> > 1. The offset of a cache with a ctor is not zero, free an object from
> >> > this cache to cache with offset zero, will write next freepointer to
> >> > wrong location, resulting in confusion of freelist.
> >> 
> >> Kernels hardened against freelist corruption will enable
> >> CONFIG_SLAB_FREELIST_HARDENED, so that's already covered, no?
> >> 
> > Yes, HARDENED already covered.
> >> > 2. If wrong cache want init on free, and cache->object_size is large
> >> > than obj size, which may lead to overwrite issue.
> >> 
> >> In general, being defensive against usage errors is part of either hardening
> >> or debugging, which is what the existing code takes into account.
> >> 
> > My consideration is for the wrong cache problem on version without
> > HARDENED or debugging, it is likely to cause kernel panic, and such
> > problem is difficult to analyze on non-debug version.
> > When reproducing this problem on debug version, it will not cause kernel
> > panic, but only print the WARN log, then use correct cache to free obj.
> > Because we want to reproduce kernel panic problem, so may ignore WARN
> > log and think that can not reproduce problem on debug version.
> 
> If you need the panic in order to e.g. capture a crash dump, you could
> enable slab debugging and boot with panic_on_warn to make the WARN result in
> panic.
>

Thank you for your suggestion.
I used to think that the debug version has less tolerance for errors
than non-debug version, so I didn't add panic_on_warn.

> > Thanks for your reply, I will enable CONFIG_SLAB_FREELIST_HARDENED on
> > non-debug version later.
> >> > Compared with adding a lot of if-else, it may be better to use obj's
> >> > cache directly.
> >> > 
> >> > Signed-off-by: Jiazi.Li <jiazi.li@transsion.com>
> >> > ---
> >> >  mm/slab.h | 4 ----
> >> >  1 file changed, 4 deletions(-)
> >> > 
> >> > diff --git a/mm/slab.h b/mm/slab.h
> >> > index 63fb4c00d529..ed39b2e4f27b 100644
> >> > --- a/mm/slab.h
> >> > +++ b/mm/slab.h
> >> > @@ -670,10 +670,6 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
> >> >  {
> >> >  	struct kmem_cache *cachep;
> >> >  
> >> > -	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
> >> > -	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
> >> > -		return s;
> >> > -
> >> >  	cachep = virt_to_cache(x);
> >> >  	if (WARN(cachep && cachep != s,
> >> >  		  "%s: Wrong slab cache. %s but object is from %s\n",
> >> 
> 
