Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 16 Jun 2011 17:33:59 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110616133359.GA12564@albatros>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
 <201106161050.27716.arnd@arndb.de>
 <20110616085842.GB3215@albatros>
 <201106161340.16117.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106161340.16117.arnd@arndb.de>
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount
 options
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Arnd,

On Thu, Jun 16, 2011 at 13:40 +0200, Arnd Bergmann wrote:
> E.g. if all the sensitive information
> you are hiding in procfs is still available through netlink, your patch
> is pointless.

Ah, I've complitely missed this piece of a puzzle! :( With procfs, proc
connector and taskstats (probably, something else) should be restricted
too.

Thank you very much for this notice!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
