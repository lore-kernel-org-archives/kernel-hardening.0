Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 16 Jun 2011 10:50:27 +0200
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1308163895-5963-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161050.27716.arnd@arndb.de>
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wednesday 15 June 2011, Vasiliy Kulikov wrote:
> 
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

The patches all look good to me implementation-wise.

I have no opinion on whether it's a good idea to include the feature or not.

	Arnd
