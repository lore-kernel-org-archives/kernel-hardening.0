Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 21 Jun 2011 15:31:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110621153102.762557f3.akpm@linux-foundation.org>
In-Reply-To: <1308163895-5963-1-git-send-email-segoon@openwall.com>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount
 options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


Plese cc Alexey on procfs things.

On Wed, 15 Jun 2011 22:51:35 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> This patch series adds support of procfs mount options and adds
> mount options to restrict /proc/<pid>/ directories to owners and
> /proc/<pid>/net/* to root.  Additional group may be defined via
> gid=, and this group will be privileged to study others /proc/<pid>/
> and networking information.
> 
> Similar features are implemented for old kernels in -ow patches (for
> Linux 2.2 and 2.4) and for Linux 2.6 in -grsecurity, but both of them
> are implemented as configure options, not cofigurable in runtime, with
> changes of gid of /proc/<pid>/, and without backward-compatible
> /proc/<pid>/net/* handling.

This all seems highly specific to one particular set of requirements. 
We have one set of access permission rules and then dive into procfs
and hard-wire those rules into the implementation?  What happens if
someone else has a similar but slightly different set of requirements? 
More kernel patches?

IOW is there some more general way of doing all this?  <handwaving>Like
better permissions/chmod support in procfs and an inherited-across-fork
per-process procfs permissions mask.</handwaving>


Does all this code support `mount -o remount' as expected?
