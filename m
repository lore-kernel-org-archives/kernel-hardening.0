Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 16 Jun 2011 13:40:15 +0200
References: <1308163895-5963-1-git-send-email-segoon@openwall.com> <201106161050.27716.arnd@arndb.de> <20110616085842.GB3215@albatros>
In-Reply-To: <20110616085842.GB3215@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161340.16117.arnd@arndb.de>
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thursday 16 June 2011, Vasiliy Kulikov wrote:
> > I have no opinion on whether it's a good idea to include the feature or not.
> 
> Why not?  Have you some specific complains where it can be perhaps too
> strong/insufficient/non-configurable?

No, not at all. I just haven't had the need for this myself, and I'm not
enough of a security person to judge whether the vulnerability addressed
by the patch is a relevant one. E.g. if all the sensitive information
you are hiding in procfs is still available through netlink, your patch
is pointless. Similarly if there is no recorded case of an attack that
relies on any of the information in procfs.

	Arnd
