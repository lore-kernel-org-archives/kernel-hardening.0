Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 22 Aug 2011 13:24:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110822092429.GA29597@albatros>
References: <20110817191550.GA18554@albatros>
 <20110820142723.GA5708@albatros>
 <20110820163120.GA7256@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110820163120.GA7256@openwall.com>
Subject: Re: [kernel-hardening] kmalloc() nofail allocations
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

Major problem with the idea in general:


static inline struct page *
__alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
	struct zonelist *zonelist, enum zone_type high_zoneidx,
	nodemask_t *nodemask, struct zone *preferred_zone,
	int migratetype)
{
    ...
	/* Avoid allocations with no watermarks from looping endlessly */
	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
		goto nopage;
    ...
}


Unlikely, but fully possible case - we want some memory and the OOM killer
kills us for our wish.

Also there are some flags, which I didn't take into consideration in the
checks of the previous patch, like __GFP_WAIT, but these are solvable
problems.


We cannot use __GFP_NOFAIL as it is marked as a legacy flag, which
shouldn't be used in a new code.  Otherwise, we'd return the same old
behaviour as before.


However, now I want to bring the subject to LKML (it starts to be
interesting) to clarify (and document, etc.) the allocation bahaviour,
when it should be cheched for NULL, whether these are really "nofail"
allocations, etc.

Thanks,

-- 
Vasiliy
