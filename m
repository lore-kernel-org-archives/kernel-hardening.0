Date: Sun, 28 May 2017 00:53:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170528075313.GB22193@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495829844-69341-2-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 01/20] NFS: Avoid cross-structure casting
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 01:17:05PM -0700, Kees Cook wrote:
> When the call to nfs_devname() fails, the error path attempts to retain
> the error via the mnt variable, but this requires a cast across very
> different types (char * to struct vfsmount *), which the upcoming
> structure layout randomization plugin flags as being potentially
> dangerous in the face of randomization. This is a false positive, but
> what this code actually wants to do is retain the error value, so this
> patch explicitly sets it, instead of using what seems to be an
> unexpected cast.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Trond Myklebust <trond.myklebust@primarydata.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

And I think we should get this (and the other cast patches) in ASAP,
independent of the fat of the randstruct plugin.
