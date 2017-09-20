Date: Wed, 20 Sep 2017 13:56:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170920205642.GA20023@infradead.org>
References: <1505940337-79069-1-git-send-email-keescook@chromium.org>
 <1505940337-79069-15-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505940337-79069-15-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v3 14/31] vxfs: Define usercopy region in vxfs_inode slab
 cache
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

I've only got this single email from you, which on it's own doesn't
compile and seems to be part of a 31 patch series.

So as-is NAK, doesn't work.

Please make sure to always send every patch in a series to every
developer you want to include.
