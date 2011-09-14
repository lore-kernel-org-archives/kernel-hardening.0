Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 14 Sep 2011 23:14:17 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110914191417.GA15936@albatros>
References: <20110910164001.GA2342@albatros>
 <20110910164134.GA2442@albatros>
 <1316025701.4478.65.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316025701.4478.65.camel@nimitz>
Subject: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 14, 2011 at 11:41 -0700, Dave Hansen wrote:
> On Sat, 2011-09-10 at 20:41 +0400, Vasiliy Kulikov wrote:
> > @@ -4584,7 +4584,8 @@ static const struct file_operations proc_slabstats_operations = {
> >  
> >  static int __init slab_proc_init(void)
> >  {
> > -       proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
> > +       proc_create("slabinfo", S_IWUSR | S_IRUSR, NULL,
> > +                   &proc_slabinfo_operations);
> >  #ifdef CONFIG_DEBUG_SLAB_LEAK
> >         proc_create("slab_allocators", 0, NULL, &proc_sla 
> 
> If you respin this, please don't muck with the whitespace.

OK, I was just removing checkpatch warnings.

>  Otherwise,
> I'm fine with this.  Distros are already starting to do this anyway in
> userspace.
> 
> Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>

Thank you!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
