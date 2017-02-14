Date: Tue, 14 Feb 2017 21:38:11 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <1487036728.15297.1.camel@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.20.1702142137500.20182@namei.org>
References: <alpine.LRH.2.20.1702131634000.8914@namei.org> <1487036728.15297.1.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC PATCH 3/4] integrity: mark default IMA rules as
 __ro_after_init
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 13 Feb 2017, Mimi Zohar wrote:

> On Mon, 2017-02-13 at 16:34 +1100, James Morris wrote:
> > The default IMA rules are loaded during init and then do not
> > change, so mark them as __ro_after_init.
> > 
> > Signed-off-by: James Morris <james.l.morris@oracle.com>
> 
> Thanks!

Is that an acked-by?


-- 
James Morris
<jmorris@namei.org>
