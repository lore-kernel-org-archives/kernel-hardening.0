Date: Tue, 29 Aug 2017 22:31:26 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20170829123126.GB10621@dastard>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
 <1503956111-36652-16-git-send-email-keescook@chromium.org>
 <20170829081453.GA10196@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829081453.GA10196@infradead.org>
Subject: [kernel-hardening] Re: [PATCH v2 15/30] xfs: Define usercopy region in xfs_inode slab
 cache
To: Christoph Hellwig <hch@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 29, 2017 at 01:14:53AM -0700, Christoph Hellwig wrote:
> One thing I've been wondering is wether we should actually just
> get rid of the online area.  Compared to reading an inode from
> disk a single additional kmalloc is negligible, and not having the
> inline data / extent list would allow us to reduce the inode size
> significantly.

Probably should.  I've already been looking at killing the inline
extents array to simplify the management of the extent list (much
simpler to index by rbtree when we don't have direct/indirect
structures), so killing the inline data would get rid of the other
part of the union the inline data sits in.

OTOH, if we're going to have to dynamically allocate the memory for
the extent/inline data for the data fork, it may just be easier to
make the entire data fork a dynamic allocation (like the attr fork).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
