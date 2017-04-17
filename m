Date: Mon, 17 Apr 2017 08:51:29 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170417065129.GB21022@kroah.com>
References: <20170417060706.28674-1-matt@nmatt.com>
 <20170417060706.28674-3-matt@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170417060706.28674-3-matt@nmatt.com>
Subject: [kernel-hardening] Re: [PATCH 2/4] add tiocsti_restrict variable
To: Matt Brown <matt@nmatt.com>
Cc: jmorris@namei.org, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 17, 2017 at 02:07:04AM -0400, Matt Brown wrote:
> adding extern variable tiocsti_restrict to allow it to be included
> in sysctl
> 
> Signed-off-by: Matt Brown <matt@nmatt.com>
> ---
>  include/linux/tty.h | 2 ++
>  1 file changed, 2 insertions(+)

I'm all for breaking up changes to be tiny logical pieces, but this is
really not needed.  Please make it "one logical feature" per patch.

thanks,

greg k-h
