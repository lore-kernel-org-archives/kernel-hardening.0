Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 15 Jun 2011 20:31:48 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110615163147.GA17087@albatros>
References: <1308146299-13015-1-git-send-email-segoon@openwall.com>
 <20110615092221.b143c45a.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615092221.b143c45a.rdunlap@xenotime.net>
Subject: [kernel-hardening] Re: [RFC 5/5 v3] procfs: add documentation for procfs mount options
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Nikanth Karthikesan <knikanth@suse.de>, David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2011 at 09:22 -0700, Randy Dunlap wrote:
> On Wed, 15 Jun 2011 17:58:19 +0400 Vasiliy Kulikov wrote:
> > +hidepid=1 means users may not access any /proc/<pid>/ directories, but their
> 
> comma not needed above. [...]

Indeed, thank you for the fixes!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
