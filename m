Return-Path: <kernel-hardening-return-21644-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2945AC636D4
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Feb 2023 09:41:54 +0000 (UTC)
Received: (qmail 25710 invoked by uid 550); 15 Feb 2023 09:41:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25675 invoked from network); 15 Feb 2023 09:41:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1676454092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rj4QsSGZ5Ti6ptzVHUWoMKmIN/uODtiAOITM+xUG0ig=;
	b=1qnGuDE8Kd6iPK+w2Uaqi0kNRDl0aaIp4xwfABv4MBhpIcJGeUoCdLBwhweTukDmiut4/b
	YmKcUt7CtMLj6AMFIoPBznYEWOvMHhiWW2HvKj/vhEFFlmsM4E6NsBHdetjq+V7nCXLZvy
	RHCLrBM0e05V6GF8MWJqSzudNRc0dEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1676454092;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rj4QsSGZ5Ti6ptzVHUWoMKmIN/uODtiAOITM+xUG0ig=;
	b=b3iht4bq2jf1bjHFLUvFLxPGHssskD+epp7k3/5Fc1W8C1DNKeLaACA1zFJ5qXVn2qZS2h
	2hfN33n7ufd8R2CQ==
Message-ID: <884f051f-d1ed-756f-aef3-6ed3005de090@suse.cz>
Date: Wed, 15 Feb 2023 10:41:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] mm/slab: always use cache from obj
To: lijiazi <jqqlijiazi@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, "Jiazi.Li" <jiazi.li@transsion.com>,
 linux-mm@kvack.org, Kees Cook <keescook@chromium.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20230214101949.7461-1-jiazi.li@transsion.com>
 <bb6ad3ee-8d00-bdd5-3f50-a8f836892d51@suse.cz>
 <20230215053748.GA11780@Jiazi.Li>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230215053748.GA11780@Jiazi.Li>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/15/23 06:49, lijiazi wrote:
> On Tue, Feb 14, 2023 at 11:33:21AM +0100, Vlastimil Babka wrote:
>> On 2/14/23 11:19, Jiazi.Li wrote:
>> > If free obj to a wrong cache, in addition random, different offset
>> > and object_size will also cause problems:
>> > 1. The offset of a cache with a ctor is not zero, free an object from
>> > this cache to cache with offset zero, will write next freepointer to
>> > wrong location, resulting in confusion of freelist.
>> 
>> Kernels hardened against freelist corruption will enable
>> CONFIG_SLAB_FREELIST_HARDENED, so that's already covered, no?
>> 
> Yes, HARDENED already covered.
>> > 2. If wrong cache want init on free, and cache->object_size is large
>> > than obj size, which may lead to overwrite issue.
>> 
>> In general, being defensive against usage errors is part of either hardening
>> or debugging, which is what the existing code takes into account.
>> 
> My consideration is for the wrong cache problem on version without
> HARDENED or debugging, it is likely to cause kernel panic, and such
> problem is difficult to analyze on non-debug version.
> When reproducing this problem on debug version, it will not cause kernel
> panic, but only print the WARN log, then use correct cache to free obj.
> Because we want to reproduce kernel panic problem, so may ignore WARN
> log and think that can not reproduce problem on debug version.

If you need the panic in order to e.g. capture a crash dump, you could
enable slab debugging and boot with panic_on_warn to make the WARN result in
panic.

> Thanks for your reply, I will enable CONFIG_SLAB_FREELIST_HARDENED on
> non-debug version later.
>> > Compared with adding a lot of if-else, it may be better to use obj's
>> > cache directly.
>> > 
>> > Signed-off-by: Jiazi.Li <jiazi.li@transsion.com>
>> > ---
>> >  mm/slab.h | 4 ----
>> >  1 file changed, 4 deletions(-)
>> > 
>> > diff --git a/mm/slab.h b/mm/slab.h
>> > index 63fb4c00d529..ed39b2e4f27b 100644
>> > --- a/mm/slab.h
>> > +++ b/mm/slab.h
>> > @@ -670,10 +670,6 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
>> >  {
>> >  	struct kmem_cache *cachep;
>> >  
>> > -	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
>> > -	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
>> > -		return s;
>> > -
>> >  	cachep = virt_to_cache(x);
>> >  	if (WARN(cachep && cachep != s,
>> >  		  "%s: Wrong slab cache. %s but object is from %s\n",
>> 

