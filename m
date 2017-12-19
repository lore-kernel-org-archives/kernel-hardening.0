Date: Tue, 19 Dec 2017 07:02:12 -0800
From: Matthew Wilcox <willy@infradead.org>
Message-ID: <20171219150212.GB30842@bombadil.infradead.org>
References: <20171219133236.GE13680@bombadil.infradead.org>
 <20171219144211.GY2787@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219144211.GY2787@dhcp22.suse.cz>
Subject: [kernel-hardening] Re: [PATCH] Provide useful debugging information for VM_BUG
To: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 19, 2017 at 03:42:11PM +0100, Michal Hocko wrote:
> On Tue 19-12-17 05:32:36, Matthew Wilcox wrote:
> > 
> > From: Matthew Wilcox <mawilcox@microsoft.com>
> > 
> > With the recent addition of hashed kernel pointers, places which need
> > to produce useful debug output have to specify %px, not %p.  This patch
> > fixes all the VM debug to use %px.  This is appropriate because it's
> > debug output that the user should never be able to trigger, and kernel
> > developers need to see the actual pointers.
> 
> Agreed. This is essentially a BUG_ON so we shouldn't hide information.
> I am just wondering why %px rather than %lx (like __show_regs e.g.)?

commit 7b1924a1d930eb27fc79c4e4e2a6c1c970623e68
Author: Tobin C. Harding <me@tobin.cc>
Date:   Thu Nov 23 10:59:45 2017 +1100

    vsprintf: add printk specifier %px
    
    printk specifier %p now hashes all addresses before printing. Sometimes
    we need to see the actual unmodified address. This can be achieved using
    %lx but then we face the risk that if in future we want to change the
    way the Kernel handles printing of pointers we will have to grep through
    the already existent 50 000 %lx call sites. Let's add specifier %px as a
    clear, opt-in, way to print a pointer and maintain some level of
    isolation from all the other hex integer output within the Kernel.
    
    Add printk specifier %px to print the actual unmodified address.
    
    Signed-off-by: Tobin C. Harding <me@tobin.cc>

> > Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.  Andrew, will you take this, or does it go through the hardening tree?
