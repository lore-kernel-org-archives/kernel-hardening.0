Date: Tue, 29 Aug 2017 01:14:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170829081453.GA10196@infradead.org>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
 <1503956111-36652-16-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503956111-36652-16-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 15/30] xfs: Define usercopy region in xfs_inode slab
 cache
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

One thing I've been wondering is wether we should actually just
get rid of the online area.  Compared to reading an inode from
disk a single additional kmalloc is negligible, and not having the
inline data / extent list would allow us to reduce the inode size
significantly.

Kees/David:  how many of these patches are file systems with some
sort of inline data?  Given that it's only about 30 patches declaring
allocations either entirely valid for user copy or not might end up
being nicer in many ways than these offsets.
