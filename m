From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2017 00:58:07 -0500
In-Reply-To: <alpine.LRH.2.20.1702142137500.20182@namei.org>
References: <alpine.LRH.2.20.1702131634000.8914@namei.org>
	 <1487036728.15297.1.camel@linux.vnet.ibm.com>
	 <alpine.LRH.2.20.1702142137500.20182@namei.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1487138287.15297.23.camel@linux.vnet.ibm.com>
Subject: [kernel-hardening] Re: [RFC PATCH 3/4] integrity: mark default IMA rules as
 __ro_after_init
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-02-14 at 21:38 +1100, James Morris wrote:
> On Mon, 13 Feb 2017, Mimi Zohar wrote:
> 
> > On Mon, 2017-02-13 at 16:34 +1100, James Morris wrote:
> > > The default IMA rules are loaded during init and then do not
> > > change, so mark them as __ro_after_init.
> > > 
> > > Signed-off-by: James Morris <james.l.morris@oracle.com>
> > 
> > Thanks!
> 
> Is that an acked-by?

Yes, thanks.

Mimi
