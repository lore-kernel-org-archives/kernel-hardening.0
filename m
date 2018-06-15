Date: Fri, 15 Jun 2018 17:40:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Message-ID: <20180615164009.GD30522@ZenIV.linux.org.uk>
References: <20180615152335.208202-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615152335.208202-1-jannh@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 15, 2018 at 05:23:35PM +0200, Jann Horn wrote:

> I've mostly copypasted ib_safe_file_access() over as
> scsi_safe_file_access() because I couldn't find a good common header -
> please tell me if you know a better way.
> The duplicate pr_err_once() calls are so that each of them fires once;
> otherwise, this would probably have to be a macro.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---

WTF do you mean, in ->release()?  That makes no sense whatsoever -
what kind of copy_{to,from}_user() would be possible in there?
