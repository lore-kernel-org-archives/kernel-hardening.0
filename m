Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Sep 2016 00:33:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20160914073340.GA28090@infradead.org>
References: <20160902113909.32631-1-juerg.haefliger@hpe.com>
 <20160914071901.8127-1-juerg.haefliger@hpe.com>
 <20160914071901.8127-4-juerg.haefliger@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160914071901.8127-4-juerg.haefliger@hpe.com>
Subject: [kernel-hardening] Re: [RFC PATCH v2 3/3] block: Always use a bounce buffer when XPFO
 is enabled
To: Juerg Haefliger <juerg.haefliger@hpe.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org, vpk@cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 14, 2016 at 09:19:01AM +0200, Juerg Haefliger wrote:
> This is a temporary hack to prevent the use of bio_map_user_iov()
> which causes XPFO page faults.
> 
> Signed-off-by: Juerg Haefliger <juerg.haefliger@hpe.com>

Sorry, but if your scheme doesn't support get_user_pages access to
user memory is't a steaming pile of crap and entirely unacceptable.
