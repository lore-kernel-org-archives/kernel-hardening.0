Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 17 Jan 2017 17:12:27 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170117161227.GA12846@kroah.com>
References: <20170116164944.GA28984@kroah.com>
 <20170116165031.GB29693@kroah.com>
 <1484667945.2886.4.camel@poochiereds.net>
 <20170117155642.GA29027@kroah.com>
 <1484669260.2886.8.camel@poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1484669260.2886.8.camel@poochiereds.net>
Subject: [kernel-hardening] Re: [PATCH 2/3] Make static usermode helper binaries constant
To: Jeff Layton <jlayton@poochiereds.net>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Sailer <t.sailer@alumni.ethz.ch>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 17, 2017 at 11:07:40AM -0500, Jeff Layton wrote:
> On Tue, 2017-01-17 at 16:56 +0100, Greg KH wrote:
> > On Tue, Jan 17, 2017 at 10:45:45AM -0500, Jeff Layton wrote:
> > > On Mon, 2017-01-16 at 17:50 +0100, Greg KH wrote:
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > There are a number of usermode helper binaries that are "hard coded" in
> > > > the kernel today, so mark them as "const" to make it harder for someone
> > > > to change where the variables point to.
> > > > 
> > > > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > > Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
> > > > Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> > > > Cc: Johan Hovold <johan@kernel.org>
> > > > Cc: Alex Elder <elder@kernel.org>
> > > > Cc: "J. Bruce Fields" <bfields@fieldses.org>
> > > > Cc: Jeff Layton <jlayton@poochiereds.net>
> > > > Cc: David Howells <dhowells@redhat.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > 
> > 
> > > > --- a/fs/nfsd/nfs4layouts.c
> > > > +++ b/fs/nfsd/nfs4layouts.c
> > > > @@ -613,6 +613,7 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
> > > >  {
> > > >  	struct nfs4_client *clp = ls->ls_stid.sc_client;
> > > >  	char addr_str[INET6_ADDRSTRLEN];
> > > > +	static char const nfsd_recall_failed[] = "/sbin/nfsd-recall-failed";
> > > >  	static char *envp[] = {
> > > >  		"HOME=/",
> > > >  		"TERM=linux",
> > > > @@ -628,12 +629,13 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
> > > >  		"nfsd: client %s failed to respond to layout recall. "
> > > >  		"  Fencing..\n", addr_str);
> > > >  
> > > > -	argv[0] = "/sbin/nfsd-recall-failed";
> > > > +	argv[0] = (char *)nfsd_recall_failed;
> > > >  	argv[1] = addr_str;
> > > >  	argv[2] = ls->ls_file->f_path.mnt->mnt_sb->s_id;
> > > >  	argv[3] = NULL;
> > > >  
> > > > -	error = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
> > > > +	error = call_usermodehelper(nfsd_recall_failed, argv, envp,
> > > > +				    UMH_WAIT_PROC);
> > > >  	if (error) {
> > > >  		printk(KERN_ERR "nfsd: fence failed for client %s: %d!\n",
> > > >  			addr_str, error);
> > > 
> > > Do we need a similar fix in nfsd4_umh_cltrack_upcall?
> > 
> > Not that I can tell, as the call_usermodehelper() binary it calls is
> > dynamically created (it's not a static string).  Unless I'm misreading
> > the code?
> > 
> 
> It's a module_param_string:
> 
> static char cltrack_prog[PATH_MAX] = "/sbin/nfsdcltrack";
> module_param_string(cltrack_prog, cltrack_prog, sizeof(cltrack_prog),
>                         S_IRUGO|S_IWUSR);
> MODULE_PARM_DESC(cltrack_prog, "Path to the nfsdcltrack upcall
> program");
> 
> Maybe we should consider deprecating that module parameter and make it
> const as well?  I added it when I first developed that code, but I doubt
> anyone legitimately sets it.

That's fine with me, but was outside of the scope of this patch, I was
not trying to change any existing functionality :)

thanks,

greg k-h
